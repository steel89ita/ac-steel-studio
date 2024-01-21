-------------------------------- CLASSES --------------------------------
require('helpers/ValueHelpers')
require('helpers/Backgrounds')
require('helpers/Themes')
require('helpers/Locations')
require('helpers/Objects')
require('helpers/Audio')
local json = require('lib/json')

-------------------------------- CONSTANTS --------------------------------
require('Storage')
require('constants')

-------------------------------- Initializing --------------------------------
sim = ac.getSim() ---@type ac.StateSim
car = ac.getCar(sim.focusedCar) or ac.getCar(0) ---@type ac.StateCar?



local steelConfig = "steelstudio.json"

trackPath = ac.getFolder(ac.FolderID.ContentTracks) .. "\\" .. ac.getTrackID()
steelStudioPath = trackPath .. "\\extension\\" .. steelConfig
extensionPath = trackPath .. "\\extension\\"

records = nil

local foundSteelStudioConf = nil ---@type boolean?
local validSteelStudioConf = nil ---@type boolean?

steelStudioData = {}

---- CAR VALUES ---

carPosition = car.position
carLook = car.look
carSteer = car.steer


startPosition = nil
startLook = nil
--local skinDir = ac.getFolder(ac.FolderID.ContentCars) .. '/' .. ac.getCarID(0) .. '/skins/my_skin'



---- MESHES: CREW AND DRIVERS ----

crew = ac.findNodes('?Meccanico_PALETTA?')
drivers = ac.findNodes('?DRIVER?')


---- BACKGROUND VALUES ----

local bkgIdx = 0
changedValues = 'Original settings'

---- THEME CONFIGURATION ----

local themes = {}
local currentTheme = {}

local emptyTheme = {
  theme = "New Theme",
  backgrounds = {},
  locations = {}
}

---- ERRORS on inputs ----

local errors = {
  inputLocation = ''
}

-------------------------------- To be decided --------------------------------

local count = 1

local light = nil ---@type ac.LightSource?
local alignOnce = true

local initializedBackgrounds = false
local initializedUI = false

local confFilename = nil



local teleported = false




function saveLocations()
  --local bckName = "Steelstudio" .. ".json"
  --io.copyFile(extensionPath .. "empty.json", extensionPath .. bckName)

  local file = io.open(LOCATIONS_FILE_PATH, "w")

  if file then
    ac.console("File existing, writing")

    local content = deepcopy(LOCATIONS)

    ac.debug("CONTENT", content)
    file:write(json.encode(content))
    file:close()
  end




  ui.toast(ui.Icons.Confirm, "Locations file saved!")
  --forceReload()
  --saveState.saved = true
end

function saveObjects()
  --local bckName = "Steelstudio" .. ".json"
  --io.copyFile(extensionPath .. "empty.json", extensionPath .. bckName)

  local file = io.open(OBJECTS_FILE_PATH, "w")

  if file then
    logFile(LOGS_FILE_PATH, 'Save Objects: Existing file, writing changes')

    local content = deepcopy(OBJECTS)

    ac.debug("CONTENT", content)
    file:write(json.encode(content))
    file:close()
  end




  ui.toast(ui.Icons.Confirm, "Locations file saved!")
  --forceReload()
  --saveState.saved = true
end


function saveTheme(themeContent)
  --local bckName = "Steelstudio" .. ".json"
  --io.copyFile(extensionPath .. "empty.json", extensionPath .. bckName)

  local fileName = THEMES_PREFIX .. themeContent.theme
  local file = io.open(STEEL_STUDIO_FOLDER_PATH .. '\\' .. fileName .. '.json', "w")

  if file then
    ac.console("File existing, writing")

    local content = deepcopy(themeContent)

    ac.debug("THEME CONTENT", themeContent)


    for k, background in pairs(content.backgrounds) do
      local val = content.backgrounds[k].color
      ac.debug("val", dump(val))
      content.backgrounds[k].color = tostring(val.r .. ", " .. val.g .. ", " .. val.b .. ", " .. val.mult)
    end

    ac.debug("CONTENT", content)
    file:write(json.encode(content))
    file:close()
  else
    ui.toast(ui.Icons.Bomb, "File not found!")
  end




  -- ui.toast(ui.Icons.Confirm, filename .. " saved!")
  --forceReload()
  --saveState.saved = true
end


function recycleTheme(themeName)
  local fileName = THEMES_PREFIX .. themeName
  local filePath = STEEL_STUDIO_FOLDER_PATH .. '\\' .. fileName .. '.json'

  --local file = io.open(filePath, "r")

  --ac.debug("Theme path", filePath)

  --ui.toast(ui.Icons.ArrowUp, filePath)

  local exists = io.exists(filePath)
  if exists then


    io.deleteFile(filePath)
    ui.toast(ui.Icons.Confirm, filePath .. " deleted")

    
  end

  



    

  

end

--function script.onShowWindowMain()
--ac.console("Opened App, here initialize it")
--
function save()
  --local bckName = "Steelstudio" .. ".json"
  --io.copyFile(extensionPath .. "empty.json", extensionPath .. bckName)

  local file = io.open(extensionPath .. steelConfig, "w")

  if file then
    ac.console("File existing, writing")

    local content = deepcopy(themes)

    -- for every theme in themes
    for k, theme in pairs(content) do
      -- for every background in theme
      for k, background in pairs(theme.backgrounds) do
        local val = theme.backgrounds[k].color
        ac.debug("val", dump(val))
        theme.backgrounds[k].color = tostring(val.r .. ", " .. val.g .. ", " .. val.b .. ", " .. val.mult)
      end
    end

    ac.debug("CONTENT", content)
    file:write(json.encode(content))
    file:close()
  end




  -- ui.toast(ui.Icons.Confirm, filename .. " saved!")
  --forceReload()
  --saveState.saved = true
end

--[[ if light then
    alignOnce = true
    light:dispose()
    light = nil
  end ]]
--storage.initializedBackgrounds = false
--end

local function welcomeTab()
  ui.text('Welcome!')
  if foundSteelStudioConf then
    ui.textWrapped(
      "Steel Studio file found. This track is compatible with Steel Studio! Select one of the tabs to begin to customize the track or move your car.")
  else
    ui.textWrapped(
      "No Steel Studio file found. Don't worry, this track is still not compatible wih Steel Studio, but you can begin setting it from a blank template.")
  end
end


local function themesTab()
  ui.textWrapped(
    '"Themes" are a collection of backgrounds, car positions and possibly other stuff.')



  -- don't show theme settings if there is no current theme
  if CURRENT_THEME and next(CURRENT_THEME) == nil then
    ui.text("No themes found. Start by adding a new theme here. ")

    if ui.button("Add new theme") then
      CURRENT_THEME = deepcopy(emptyTheme)
    end

    return
  end


  local defaultLabel = 'Theme ' .. #LOADED_THEMES + 1

  local newThemeLabel = ui.inputText("New Theme: ", defaultLabel, ui.InputTextFlags.Placeholder)

  ui.sameLine(0, 8)

  ui.pushStyleColor(ui.StyleColor.Button, COLOR_GREEN)
  if ui.button("Save current theme") then
    local currTheme = deepcopy(CURRENT_THEME)
    currTheme.theme = newThemeLabel
    --themes[inputstring] = currTheme
    table.insert(LOADED_THEMES, currTheme)
    saveTheme(currTheme)
  end
  ui.popStyleColor()

  ac.debug("input", newThemeLabel)

  ui.newLine()

  for k, item in ipairs(LOADED_THEMES) do
    ac.debug("itemKey", k)
    ac.debug("item", item)

    ui.beginGroup(400)

    if ui.button(item['theme'], vec2(ui.availableSpaceX() - 40, 0)) then
      CURRENT_THEME = deepcopy(item)
    end
    ui.sameLine(0, 8)
    if ui.button(item['theme'] .. "X") then
      ui.modalPopup('Delete ' .. item['theme'], 'Are you sure to delete the selected theme?', function(okPressed)
        if okPressed then
          table.remove(LOADED_THEMES, k)
          recycleTheme(item['theme'])
        end
      end)
      
    end
    ui.endGroup()
  end

  ac.debug("CURRENT_THEME", CURRENT_THEME)


  -- from steel studio data, create themes buttons
  for k, item in pairs(steelStudioData) do
    --[[ ui.text(item['theme'])
    ui.text(steelStudioData[k].backgrounds[1].color)
    if ui.button(item['theme']) then
      currentTheme.backgrounds = transformBackgroundTable(steelStudioData[k].backgrounds)
    end ]]
  end

end





local function backgroundsTab(dt)
  --TODO: Based on Current theme. If I change values, do I need to save a new theme?

  -- don't show background settings if there is no current theme
  if CURRENT_THEME and not CURRENT_THEME.backgrounds then
    ui.text("No background found in current theme. ")
    return
  else
    ui.text(changedValues)


    for i, controller in ipairs(CURRENT_THEME.backgrounds) do
      ac.debug("controller color", controller.color)

      addColorController("colorController" .. i, controller.label, controller.color,
        controller.meshNames, controller.texture, Storage.colorPickerType)


      ac.debug("picker", controller)
    end

    if ui.button("Add new Color Controller") then
      ac.debug("dt", dt)
      table.insert(CURRENT_THEME.backgrounds,
        newBackground("notworking", rgb(0, 0, 0), "notworking", "no-really" .. bkgIdx))

      bkgIdx = bkgIdx + 1
    end

    if ui.button("Shuffle Palette") then
      for i in ipairs(CURRENT_THEME.backgrounds) do
        CURRENT_THEME.backgrounds[i].color = rgbm(math.random(), math.random(), math.random(), 1.0)
      end
    end

    ac.debug("CURRENT_THEME", CURRENT_THEME)
  end
end




local function teleportTab()
  -- don't show location settings if there is no current theme

  


  if not LOCATIONS then
    ui.text("No locations found for current track. ")
    return
  else if not physics.allowed() then
    ui.text("Can't teleport cars in current session mode. Currently, it's only allowed in Practice Mode. ")
    return
    else
    
      local carName = CARS[SELECTED_CAR]:name()
      
      ui.combo("Teleport Car", carName, function()
        for k, v in pairs(CARS) do
          if ui.selectable(v:name()) then
            SELECTED_CAR = v.index + 1
          end
        end
      end)


    local locationsIdx = "Point " .. #LOCATIONS + 1

    inputstring = ui.inputText("Location name... " .. locationsIdx, locationsIdx, ui.InputTextFlags.Placeholder)

    ui.sameLine(0, 8)

    if ui.button("Add location", vec2(ui.availableSpaceX(), 0)) then
      errors.inputLocation = ''
      local currentPosition = dump(car.position)
      ac.debug("Car pos X", currentPosition)

      if (inputstring ~= nil and inputstring ~= '') then
        table.insert(LOCATIONS, {
          position = dump(car.position),
          look = dump(car.look),
          name = inputstring
        })
        inputstring = ''
      else
        errors.inputLocation = 'Error! Please enter a valid name.'
      end
    end

    ui.textColored(errors.inputLocation, rgbm.colors.red)


    -- create buttons for locations in current theme

    for k, item in pairs(LOCATIONS) do
      local position = stringToVec3(item['position'])
      local look = stringToVec3(item['look'])
      if ui.button(item['name']) then teleportCar(position, look, SELECTED_CAR - 1) end
    end


    if ui.button('Teleport to Starting Line') then physics.teleportCarTo(0, ac.SpawnSet.Start) end
    if ui.button('Teleport to Hotlap Start') then physics.teleportCarTo(0, ac.SpawnSet.HotlapStart) end
    if ui.button('Teleport to Pits') then physics.teleportCarTo(0, ac.SpawnSet.Pits) end

    if ui.button('Flip Car Direction') then teleportCar(carPosition, -carLook, SELECTED_CAR - 1) end

      ui.pushStyleColor(ui.StyleColor.Button, COLOR_GREEN)
      if ui.button("Save Locations") then
        saveLocations()
      end
      ui.popStyleColor()
  end
  end
end

local function objectsTab()



  -- show/hide objects depending on enabled flag
  --TODO: meshNames is table. iterate over the table
  for k, mesh in pairs(OBJECTS) do
    local foundMesh = ac.findMeshes(mesh['meshNames'][1])
    if not mesh['enabled'] then
      foundMesh:setVisible(false)
    else
      foundMesh:setVisible(true)
    end

  end
  
  
  if #OBJECTS == 0 then
    ui.text("No objects controller found for current track.")
    return
  else
    ui.text("Objects:")

    -- for every object, add a checkbox to allow changing enabled flag
    for k, v in pairs(OBJECTS) do
      local meshes = ac.findMeshes(v['meshNames'][1])
      ac.debug("FOUND MESHES", meshes)
      if ui.checkbox(v['name'], v['enabled']) then
        ac.console("Disable ")
        OBJECTS[k]['enabled'] = not OBJECTS[k]['enabled']
      end
    end

    ui.pushStyleColor(ui.StyleColor.Button, COLOR_GREEN)
    if ui.button("Save Objects") then
      saveObjects()
    end
    ui.popStyleColor()

  end
  ac.debug("OBJECTS", OBJECTS)
end


local function debugger()
  ac.debug("Track path", TRACK_PATH)
  ac.debug("Track Extension Path", TRACK_EXTENSION_PATH)
  ac.debug("Steel Studio Folder Path", STEEL_STUDIO_FOLDER_PATH)
  --ac.debug("Steel Studio path", steelStudioPath)
  ac.debug("Found Steel Studio Conf", foundSteelStudioConf)
  ac.debug("Valid Steel Studio Conf", validSteelStudioConf)

  ac.debug("camera direction", ac.getSim().cameraLook)
  ac.debug("car position", carPosition)
  ac.debug("car look", carLook)
  ac.debug("car steer", carSteer)
  ac.debug("car skin", carSkin)


  ac.debug("Initialized Backgrounds", initializedBackgrounds)

  ac.debug("Current Theme", currentTheme)


  --ac.debug("Current Backgrounds", currentTheme.backgrounds)

  ac.debug("LOADED THEMES", LOADED_THEMES)
  ac.debug("CURRENT_THEME", CURRENT_THEME)

  ac.debug("LOCATIONS", LOCATIONS)
  ac.debug("LOCATIONS FILE PATH", LOCATIONS_FILE_PATH)

  ac.debug("Initialized Audio", INITIALIZED_AUDIO)

end


local function extrasTab()
  ui.text('EXTRA')


  if ui.checkbox('Disable Audio', Storage.disableAudio) then

    if not Storage.disableAudio then
      ui.modalPopup('Disable Audio?',
        'Are you sure to disable audio? Keep in mind that this setting will be kept between gaming sessions. You will have to remember to re enable it.',
        function(okPressed)
          if okPressed then
            Storage.disableAudio = not Storage.disableAudio
          end
        end)
    else
      Storage.disableAudio = not Storage.disableAudio
    end
    

    
  end


  


  if ui.checkbox('Hide Pit Crew', Storage.hideCrew) then
    Storage.hideCrew = not Storage.hideCrew
  end

  if ui.checkbox('Hide Drivers', Storage.hideDrivers) then
    Storage.hideDrivers = not Storage.hideDrivers
  end

  if Storage.hideCrew then
    crew:setVisible(false)
  else
    crew:setVisible(true)
  end

  if Storage.hideDrivers then
    drivers:setVisible(false)
  else
    drivers:setVisible(true)
  end

  if Storage.disableAudio then
    for i, channel in pairs(AUDIO_VOLUME) do
      AUDIO_VOLUME[i] = 0
    end
  else
    AUDIO_VOLUME = deepcopy(INITIAL_AUDIO_VOLUME)
  end

  
  
  ac.debug("Audio Volume", AUDIO_VOLUME)

end


local function aboutTab()
  ui.text('Steel Studio v.0.1')
  --ui.text('physics late: ' .. ac.getSim().physicsLate)
  ui.text('CPU occupancy: ' .. ac.getSim().cpuOccupancy)
  --ui.text('CPU time: ' .. ac.getSim().cpuTime)

  ui.text("CONSTANT:" .. TEST_VALUE)
  changeConstant()
end




local function tryOpenSteelStudioConf()
  -- Load the JSON file
  local file = io.open(steelStudioPath, "r")
  if file == nil then
    foundSteelStudioConf = false
    --ac.console("error: no steel conf found for track")
  else
    --ac.console("nice: steel conf found for track")
    foundSteelStudioConf = true
    local data = file:read("*all")
    file:close()



    -- Parse the json data into a Lua table
    records = json.decode(data)

    -- return if there is no records, can't continue
    if records then
      validSteelStudioConf = true
      steelStudioData = records
    else
      validSteelStudioConf = false
      return
    end

    ac.debug("Steel Studio Data", steelStudioData)





    if (initializedBackgrounds == false) then
      ---- Setup Current Theme
      ---- we use the first theme at launch

      -- if the json doesn't have an array of themes, it's not valid
      -- I can't continue setting the first background
      if records[1] == nil then
        ac.console("Not a valid Steel Studio Theme!")
        return
      end

      --populate themes table. for theme buttons
      -- from steel studio data, create themes buttons
      for k, item in pairs(steelStudioData) do
        local theme = item
        --BUG: need to convert backgrounds?
        theme.backgrounds = transformBackgroundTable(steelStudioData[k].backgrounds)
        table.insert(themes, theme)
      end

      -- copy the first theme
      currentTheme = deepcopy(records[1])

      -- exit if no backgrounds in theme
      if currentTheme.backgrounds == nil then
        ac.console("No backgrounds found in theme!")
        return
      end

      --currentTheme.backgrounds = transformBackgroundTable(currentTheme.backgrounds)

      initializedBackgrounds = true
    end
  end
end


---- MAIN FUNCTION - WINDOW MAIN ----
function script.windowMain(dt)
  -- Debugger infos
  debugger()

  -- Load Storage Settings not relative to track: crew/drivers visibility, hue wheel preference
  SetStorageSettings()

  -- Set Audio Value according to Extras Tab Audio Toggle
  SetGameVolume()

  

  if not FETCHED_THEMES then
    FetchThemes()
    FETCHED_THEMES = true
  end

  if not FETCHED_LOCATIONS then
    FetchLocations()
    FETCHED_LOCATIONS = true
  end

  if not FETCHED_OBJECTS then
    FetchObjects()
  
    --[[ local foundMeshes = ac.findAny('LIGHTS')

    ac.debug("FMESHES", foundMeshes:name(2))
    for i, v in ipairs(foundMeshes) do
      ac.console(foundMeshes:name(i))
      logFile(LOGS_FILE_PATH, foundMeshes:name(i))
    end ]]
    
    FETCHED_OBJECTS = true
  end

  if not INITIALIZED_AUDIO then
    InitializeAudio()
    INITIALIZED_AUDIO = true
  end

  if not INITIALIZED_CARS then
    for i, c in ac.iterateCars() do
      table.insert(CARS, i, c)
    end
    INITIALIZED_CARS = true
  end


  -- Open Steel Studio Configuration and load themes - apply first theme
  -- tryOpenSteelStudioConf()


  -- used to set background colors across all tabs according to current theme
  if CURRENT_THEME and CURRENT_THEME.backgrounds ~= nil then
    for i, item in ipairs(CURRENT_THEME.backgrounds) do
      changeMaterialTexture(item.meshNames, item.texture, item.color)
    end
  end


  ui.beginOutline()


  



  ui.tabBar('someTabBarID', function()
    ui.tabItem('Welcome', welcomeTab)
    ui.tabItem('Themes', themesTab)
    ui.tabItem('Backgrounds', backgroundsTab)
    ui.tabItem('Teleport', teleportTab)
    ui.tabItem('Objects', objectsTab)
    ui.tabItem('Extra', extrasTab)
    ui.tabItem('About', aboutTab)
  end)


  ui.endOutline(rgbm(0, 0, 0, ac.windowFading()), 1)







  --[[ if checkCrew == true then
      checkCrew = not checkCrew
      mesh:setVisible(false)
    else
      mesh:setVisible(true)
    end ]]


  --ac.debug("Found node", mesh)
  --mesh.setVisible(mesh, false)

  --local teleport = physics.setCarPosition(0, pos, -ac.getSim().cameraLook)

  --teleport = nil
  --physics.setCarPosition(0, vec3(-0.0411275, -0.0275598, -2.67227), vec3(0, 0,0))

  --physics.setCarPosition(0, pos, -ac.getSim().cameraLook)
  --physics.setCarPosition(0, vec3(nil), -ac.getSim().cameraLook)

  --storageContent = dump(storage)
  --ac.console(storageContent)

  --ui.beginGroup(ui.availableSpaceX() - 24)

  --ac.console(colorControllers[1].color)


  --local newColor = storage.defaultColor:clone()
  --ui.colorButton('Color', newColor, ui.ColorPickerFlags.PickerHueBar)
  --if ui.itemEdited() then
  --storage.defaultColor = newColor
  --end
  --ui.sameLine(0, 4)
  --ui.setNextItemWidth(ui.availableSpaceX())


  --ui.popItemWidth()
  --ui.endGroup()
  --ui.sameLine(0, 4)



  --trackDirectory = ac.getFolder(ac.FolderID.ContentTracks) .. "\\" .. ac.getTrackID()
  --confFilename = trackDirectory .. "\\extension\\steel_studio.ini"


  --local ini = ac.INIConfig.load(confFilename, 10)
  --ac.debug("ini", ini)
  --local background1 = ini:get('ST_BACKGROUND', 'Red')

  --ac.debug("bg1", background1)
  --local r, g, b = string.match(background1, '"(%d+)", "(%d+)", "(%d+)"')




  --ac.debug("r", r)
  --ac.debug("backgorund1", rgb(tonumber(r), tonumber(g), tonumber(b)))











  -- Parse the data into separate variables
  --local id = records[2].id
  --local description1 = records[1].description
  --local description2 = records[2].description





  ui.pushItemWidth(ui.availableSpaceX())
end

function script.onHideWindowMain()
  ac.console("Closed app")
  initializedBackgrounds = false
  FETCHED_OBJECTS = false
  INITIALIZED_AUDIO = false
  --[[ if light then
    alignOnce = true
    light:dispose()
    light = nil
  end ]]
  --storage.initializedBackgrounds = false
end

function script.windowMainSettings(dt)
  ui.text('UI Preferences')

  ui.text('Color Picker Type')

  if ui.button("Hue Wheel", vec2(0, 0), ui.ButtonFlags.Activable) then
    if Storage.colorPickerType == ui.ColorPickerFlags.PickerHueBar then
      Storage.colorPickerType = ui.ColorPickerFlags.PickerHueWheel
    else
      Storage.colorPickerType = ui.ColorPickerFlags.PickerHueBar
    end
  end

  --[[ ui.childWindow('scrolling', vec2(200, 400), function()
    for i = 1, 1000 do
      ui.text('Row ' .. i)
    end
  end) ]]
end

--function script.update(dt)
--ac.console("UPDATE")
--[[ if light and (storage.align or alignOnce) then
    light.position:set(sim.cameraPosition):addScaled(sim.cameraLook, 0.1)
    light.direction:set(sim.cameraLook)
    alignOnce = false
  end ]]
--end
