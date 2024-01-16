-------------------------------- CLASSES --------------------------------
require('helpers/ValueHelpers')
require('helpers/Backgrounds')
require('helpers/Themes')
require('helpers/Locations')
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
  if next(CURRENT_THEME) == nil then
    ui.text("No themes found. Start by adding a new theme here. ")

    if ui.button("Add new theme") then
      CURRENT_THEME = deepcopy(emptyTheme)
    end

    return
  end



  inputstring = ui.inputText("New Theme: ", inputstring, ui.InputTextFlags.Placeholder)

  ui.sameLine(0, 8)

  if ui.button("Save current theme") then
    local currTheme = deepcopy(currentTheme)
    currTheme.theme = inputstring
    --themes[inputstring] = currTheme
    table.insert(themes, currTheme)
    inputstring = ''
  end

  ac.debug("input", inputstring)

  ui.newLine()

  for k, item in pairs(THEMES) do
    ac.debug("itemKey", k)
    ac.debug("item", item)
    
    ui.beginGroup(400)
    
    if ui.button(item['theme'],vec2(ui.availableSpaceX() - 40,0)) then
      CURRENT_THEME = deepcopy(item)
    end
    ui.sameLine(0, 8)
    if ui.button("X") then
      table.remove(THEMES, k)
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


  if ui.button("Debug Random") then
    currentTheme.backgrounds[1].color = rgbm(math.random(), math.random(), math.random(), 1.0)
  end


  if ui.button("SAVE FILE") then
    save()
  end


end

local function aboutTab()
  ui.text('Steel Studio v.0.1')
  --ui.text('physics late: ' .. ac.getSim().physicsLate)
  ui.text('CPU occupancy: ' .. ac.getSim().cpuOccupancy)
  --ui.text('CPU time: ' .. ac.getSim().cpuTime)

  ui.text("CONSTANT:" .. TEST_VALUE)
  changeConstant()
end



local function backgroundsTab(dt)
  --TODO: Based on Current theme. If I change values, do I need to save a new theme?

  -- don't show background settings if there is no current theme
  if not CURRENT_THEME.backgrounds then
    ui.text("No background found in current theme. ")
    return
  end

  for i, controller in ipairs(CURRENT_THEME.backgrounds) do
    --ac.debug("controllercolor", controller.color)
    --local r, g, b, m = string.match(controller.color, '([%d.]+), ([%d.]+), ([%d.]+), ([%d.]+)')
    --ac.debug("r", r)
    --ac.debug("g", g)
    --ac.debug("b", b)
    --ac.debug("m", m)

    --rgbm(tonumber(r), tonumber(g), tonumber(b), tonumber(m))
    local window = addColorController("colorController" .. bkgIdx, controller.label, controller.color,
      controller.meshNames, controller.texture, Storage.colorPickerType)


    ac.debug("picked color", window)


    -- Increment background index, required for new color controllers created by the app
    bkgIdx = bkgIdx + 1

    --[[ if ui.button("Remove " .. controller.label) then
                removeColorController(controller.id)
            end ]]
    --if window
    --ac.console(window)
  end

  if ui.button("Add new Color Controller") then
    ac.debug("dt", dt)
    table.insert(currentTheme.backgrounds, newBackground("notworking", rgb(0, 0, 0), "notworking", "no-really" .. bkgIdx))

    bkgIdx = bkgIdx + 1
  end

  if ui.button("Shuffle Palette") then
    for i in ipairs(CURRENT_THEME.backgrounds) do
      CURRENT_THEME.backgrounds[i].color = rgbm(math.random(), math.random(), math.random(), 1.0)
    end
  end

  ac.debug("CURRENT_THEME", CURRENT_THEME)
end




local function teleportTab()


  -- don't show location settings if there is no current theme
  if not currentTheme.locations then
    ui.text("No locations found in current theme. ")
    return
  end


  ac.debug("Current Theme Locations", currentTheme.locations)


  inputstring = ui.inputText("Location name... ", inputstring, ui.InputTextFlags.Placeholder)

  ui.sameLine(0, 8)

  if ui.button("Save current location") then
    errors.inputLocation = ''
    local currentPosition = dump(car.position)
    ac.debug("Car pos X", currentPosition)
    
    if (inputstring ~= nil and inputstring ~= '') then
      table.insert(currentTheme.locations, {
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
  if currentTheme.locations then
    for k, item in ipairs(currentTheme.locations) do
      local position = stringToVec3(item['position'])
      local look = stringToVec3(item['look'])
      if ui.button(item['name']) then teleportCar(position, look) end
    end
  end

  if ui.button('Teleport to Starting Line') then physics.teleportCarTo(0, ac.SpawnSet.Start) end
  if ui.button('Teleport to Hotlap Start') then physics.teleportCarTo(0, ac.SpawnSet.HotlapStart) end
  if ui.button('Teleport to Pits') then physics.teleportCarTo(0, ac.SpawnSet.Pits) end

  if ui.button('Flip Car Direction') then teleportCar(carPosition, -carLook) end

  --[[ local customCarPosition = vec3(54.07, 7.92154, -32.5626)
        local customCarDirection = -vec3(0.0481339, -0.165144, 0.985094)
        clickToTeleport = setInterval(function()
            physics.setCarPosition(0, customCarPosition, customCarDirection)

            clearInterval(clickToTeleport)
        end) ]]

  --[[ local clickToTeleport


    local customCarPosition = vec3(54.07, 7.92154, -32.5626)
    local customCarDirection = -vec3(0.0481339, -0.165144, 0.985094)

    if not teleported then
        clickToTeleport = setInterval(function()
            --local pos = customCarPosition
            physics.setCarPosition(0, customCarPosition, customCarDirection)
            --physics.setCarPosition(0, pos, -ac.getSim().cameraLook)

            clearInterval(clickToTeleport)
            clickToTeleport = nil
            teleported = true
        end)
    end ]]
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

  ac.debug("Themes", themes)
end


local function extrasTab()
  ui.text('EXTRA')





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


  FetchThemes()
  FetchLocations()

  -- Open Steel Studio Configuration and load themes - apply first theme
  -- tryOpenSteelStudioConf()


  -- used to set background colors across all tabs according to current theme
  if CURRENT_THEME.backgrounds ~= nil then
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
