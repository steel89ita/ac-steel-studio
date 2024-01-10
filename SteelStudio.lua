-------------------------------- CLASSES --------------------------------
require('helpers/helpers')
local json = require('lib/json')

-------------------------------- Initializing --------------------------------
sim = ac.getSim() ---@type ac.StateSim
car = ac.getCar(sim.focusedCar) or ac.getCar(0) ---@type ac.StateCar?

local steelConfig = "steelstudio.json"

trackPath = ac.getFolder(ac.FolderID.ContentTracks) .. "\\" .. ac.getTrackID()
steelStudioPath = trackPath .. "\\extension\\" .. steelConfig

local foundSteelstudioConf = nil ---@type boolean?


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





---- UI PREFERENCES ----


-------------------------------- To be decided --------------------------------

local frame = 1

local light = nil ---@type ac.LightSource?
local alignOnce = true

local initializedBackgrounds = false
local initializedUI = false

local confFilename = nil



local teleported = false

local configBackgrounds = {}

-- Storage data - not relative to track customizations
local storage = ac.storage {
  defaultColor = rgb(0.6, 0.9, 1),
  hideCrew = false,
  hideDrivers = false,
  colorPickerType = ui.ColorPickerFlags.PickerHueBar
}



local function setStorageSettings()
  ac.console("Steel Studio: Applying Saved Storage Settings")

  if storage.hideCrew then crew:setVisible(false) end
  if storage.hideDrivers then drivers:setVisible(false) end

end

function script.onShowWindowMain()
  ac.console("Opened App, here initialize it")
  setStorageSettings()



  --[[ if light then
    alignOnce = true
    light:dispose()
    light = nil
  end ]]
  --storage.initializedBackgrounds = false
end

local function welcomeTab()
  ui.text('Welcome!')
  if foundSteelstudioConf then
    ui.textWrapped("Steel Studio file found. This track is compatible with Steel Studio! Select one of the tabs to begin to customize the track or move your car.")
  else
    ui.textWrapped("No Steel Studio file found. Don't worry, this track is still not compatible wih Steel Studio, but you can begin setting it from a blank template.")
  end
end


local function themesTab()
  ui.text('Themes')

  ui.textWrapped('To be implemented. The idea of "Themes" is a collection of backgrounds, car positions and possibly other stuff.')

  --[[ 
  if ui.button('change color') then
    changeMaterialTexture("01ROAD_FLOOR", "txDiffuse", rgbm(0.55, 0.27, 0.44, 1.0))
    changeMaterialTexture("Cube.010", "txDiffuse", rgbm(0.25, 0.57, 0.44, 1.0))
    changeMaterialTexture("Cube.011", "txDiffuse", rgbm(0.25, 0.27, 0.64, 1.0))
  end

  if ui.button('change color2') then
    configBackgrounds[1].color = rgbm(0.15, 0.57, 0.24, 1.0)
    --changeMaterialTexture("01ROAD_FLOOR", "txDiffuse", rgbm(0.15, 0.57, 0.24, 1.0))
    --changeMaterialTexture("Cube.010", "txDiffuse", rgbm(0.35, 0.37, 0.64, 1.0))
    --changeMaterialTexture("Cube.011", "txDiffuse", rgbm(0.65, 0.67, 0.64, 1.0))
  end

  if ui.button('random color') then
    changeMaterialTexture("01ROAD_FLOOR", "txDiffuse", rgbm(math.random(), math.random(), math.random(), 1.0))
    changeMaterialTexture("Cube.010", "txDiffuse", rgbm(math.random(), math.random(), math.random(), 1.0))
    changeMaterialTexture("Cube.011", "txDiffuse", rgbm(math.random(), math.random(), math.random(), 1.0))
  end ]]

end

local function aboutTab()
  ui.text('Steel Studio v.0.1')
  --ui.text('physics late: ' .. ac.getSim().physicsLate)
  ui.text('CPU occupancy: ' .. ac.getSim().cpuOccupancy)
  --ui.text('CPU time: ' .. ac.getSim().cpuTime)
end


local function backgroundsTab()
  for i, controller in ipairs(configBackgrounds) do
    --TODO: convert string to rgbm

    --ac.debug("controllercolor", controller.color)
    --local r, g, b, m = string.match(controller.color, '([%d.]+), ([%d.]+), ([%d.]+), ([%d.]+)')
    --ac.debug("r", r)
    --ac.debug("g", g)
    --ac.debug("b", b)
    --ac.debug("m", m)

    --rgbm(tonumber(r), tonumber(g), tonumber(b), tonumber(m))
    local window = addColorController("colorController" .. i, controller.label, controller.color,
      controller.meshNames, controller.texture, storage.colorPickerType)

  
        ac.debug("picked color", window)
  

    

    --[[ if ui.button("Remove " .. controller.label) then
                removeColorController(controller.id)
            end ]]
    --if window
    --ac.console(window)
  end
  

  if ui.button("Shuffle Palette") then
    for i, obj in ipairs(configBackgrounds) do
      configBackgrounds[i].color = rgbm(math.random(), math.random(), math.random(), 1.0)
    end
  end
  


end


local function teleportCar(position, direction)
  local customCarPosition = vec3(position)
  local customCarDirection = -vec3(direction)
  TeleportTimer = setInterval(function()
    physics.setCarPosition(0, customCarPosition, customCarDirection)
    clearInterval(TeleportTimer)
  end)
end

local function teleportTab()
  ui.text('TAB 2')

  
  


  
  if ui.button('Teleport 1') then teleportCar(vec3(54.07, 7.92154, -32.5626), vec3(0.0481339, -0.165144, 0.985094)) end
  if ui.button('Teleport 2') then teleportCar(vec3(13.0424, 1.69585, 18.6731), vec3(-0.630298, -0.41161, -0.658256)) end


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
  ac.debug("Track path", trackPath)
  ac.debug("Steel Studio path", steelStudioPath)
  ac.debug("Found Steel Studio Conf", foundSteelstudioConf)

  ac.debug("camera direction", ac.getSim().cameraLook)
  ac.debug("car position", carPosition)
  ac.debug("car look", carLook)
  ac.debug("car steer", carSteer)
  ac.debug("car skin", carSkin)


  ac.debug("config Backgrounds", configBackgrounds)
  ac.debug("Initialized Backgrounds", initializedBackgrounds)

end


local function extrasTab()
  ui.text('EXTRA')


  


  if ui.checkbox('Hide Pit Crew', storage.hideCrew) then
    storage.hideCrew = not storage.hideCrew
  end

  if ui.checkbox('Hide Drivers', storage.hideDrivers) then
    storage.hideDrivers = not storage.hideDrivers
  end

  if storage.hideCrew then
    crew:setVisible(false)
  else
    crew:setVisible(true)
  end

  if storage.hideDrivers then
    drivers:setVisible(false)
  else
    drivers:setVisible(true)
  end
end


local function generateBackgroundsTable(data, targetTable)
for i, bkg in ipairs(data) do
        --ac.console(i)
        local r, g, b, m = string.match(bkg.color, '([%d.]+), ([%d.]+), ([%d.]+), ([%d.]+)')

        local content = {
          meshNames = bkg.meshNames,
          color = rgbm(tonumber(r), tonumber(g), tonumber(b), tonumber(m)),
          texture = bkg.texture,
          label = bkg.label
        }

        table.insert(targetTable, content)
      end

end

local function tryOpenSteelStudioConf()

  -- Load the JSON file
  local file = io.open(steelStudioPath, "r")
  if file == nil then
    foundSteelstudioConf = false
    --ac.console("error: no steel conf found for track")
  else
    --ac.console("nice: steel conf found for track")
    foundSteelstudioConf = true
    local data = file:read("*all")
    file:close()



    -- Parse the json data into a Lua table
    local records = json.decode(data)

    if (initializedBackgrounds == false) then

      ---- Generate backgrounds table from json records
      generateBackgroundsTable(records.backgrounds, configBackgrounds)


      initializedBackgrounds = true
    end

    
  end

end

function script.windowMain(dt)


  debugger()



  tryOpenSteelStudioConf()



  ui.beginOutline()



  -- used to set background colors across all tabs according to configBackgrounds
  for i, item in ipairs(configBackgrounds) do
    changeMaterialTexture(item.meshNames, item.texture, item.color)
  end


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

  frame = frame + 1
end



function script.onHideWindowMain()
  ac.console("Closed app")
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

  if ui.button("Hue Wheel", vec2(0,0), ui.ButtonFlags.Activable) then
    if storage.colorPickerType == ui.ColorPickerFlags.PickerHueBar then
      storage.colorPickerType = ui.ColorPickerFlags.PickerHueWheel
    else
      storage.colorPickerType = ui.ColorPickerFlags.PickerHueBar
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
