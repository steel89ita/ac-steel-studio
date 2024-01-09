-------------------------------- CLASSES --------------------------------
require('helpers/helpers')
local json = require('lib/json')

-------------------------------- Initializing --------------------------------
sim = ac.getSim()
car = ac.getCar(sim.focusedCar)

local frame = 1

local light = nil ---@type ac.LightSource?
local alignOnce = true

local initializedBackgrounds = false
local initializedUI = false
local trackDirectory = nil
local confFilename = nil

local steelConfig = "steelstudio.json"

local teleported = false

local configBackgrounds = {}

local colorControllers = {
    {
        meshNames = {"Plane.001"},
        color = rgbm(0, 0.9, 0.1, 1.0),
        texture = 'txDiffuse',
        label = 'Plane'
    },
    {
        meshNames = {"Set_Light_Spot.002_SUB1", "Set_Light_Spot.001_SUB1", "Set_Light_Spot.004_SUB1", "Set_Reflected_Light_Big_SUB2", "Set_Light_Spot.003_SUB1"},
        color = rgbm(0, 10, 240, 1.0),
        texture = 'txDiffuse',
        label = 'Spot Lights'
    },
    {
        meshNames = {"Light_Top_SUB0", "Light_Top_SUB1", "Light_Top_SUB2", "Light_Top_SUB3", "Light_Top_SUB4", "Light_Top_SUB5"},
        color = rgbm(10, 240, 0, 1.0),
        texture = 'txDiffuse',
        label = 'Lights Top'
    }
}

local storage = ac.storage{
    defaultColor = rgb(0.6, 0.9, 1),
    hideCrew = false,
  hideDrivers = false
}


local function initializeUI()
    ac.console("Initializing UI" .. frame)

    ui.text("TEST")

    if ui.checkbox('UI TEST', storage.hideCrew) then
        storage.hideCrew = not storage.hideCrew
    end
end


local function welcomeTab()
    ui.text('Welcome!')
end


local function themesTab()
    ui.text('Themes')
end


local function backgroundsTab()
    ui.text('physics late: ' .. ac.getSim().physicsLate)
    ui.text('CPU occupancy: ' .. ac.getSim().cpuOccupancy)
    ui.text('CPU time: ' .. ac.getSim().cpuTime)
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

    local carPosition = car.position
    local carLook = car.look
    local carSteer = car.steer
    ac.debug("camera direction", ac.getSim().cameraLook)
    ac.debug("car position", carPosition)
    ac.debug("car look", carLook)
    ac.debug("car steer", carSteer)


    if ui.button('Teleport 1') then teleportCar(vec3(54.07, 7.92154, -32.5626), vec3(0.0481339, -0.165144, 0.985094)) end
    if ui.button('Teleport 2') then teleportCar(vec3(13.0424, 1.69585, 18.6731), vec3(-0.630298, -0.41161, -0.658256)) end


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




local function extrasTab()
    ui.text('EXTRA')

    
    local crew = ac.findNodes('?Meccanico_PALETTA?')
    local drivers = ac.findNodes('?DRIVER?')

    
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

function script.windowMain(dt)
    
  


  

    ui.beginOutline()
      




    ui.tabBar('someTabBarID', function()
      ui.tabItem('Welcome', welcomeTab)
      ui.tabItem('Themes', themesTab)
        ui.tabItem('Backgrounds', backgroundsTab)
        ui.tabItem('Teleport', teleportTab)
    ui.tabItem('Extra', extrasTab)
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

    trackDirectory = ac.getFolder(ac.FolderID.ContentTracks) .. "\\" .. ac.getTrackID()
    confFilename = trackDirectory .. "\\extension\\steel_studio.ini"
    local steelStudioConf = trackDirectory .. "\\extension\\" .. steelConfig

    --local ini = ac.INIConfig.load(confFilename, 10)
    --ac.debug("ini", ini)
    --local background1 = ini:get('ST_BACKGROUND', 'Red')

    --ac.debug("bg1", background1)
    --local r, g, b = string.match(background1, '"(%d+)", "(%d+)", "(%d+)"')



    --ac.debug("r", r)
    --ac.debug("backgorund1", rgb(tonumber(r), tonumber(g), tonumber(b)))
    ac.debug("track directory", trackDirectory)
    ac.debug("config directory", confFilename)

    ac.debug("Steel Config File", steelStudioConf)
    
  -- Load the JSON file
    local file = io.open(steelStudioConf, "r")
    if file == nil then
        ac.debug("error","ERROR, NO STEEL CONFIG FILE FOR TRACK")
    else
      local data = file:read("*all")
        file:close()


      
        -- Parse the json data into a Lua table
        local records = json.decode(data)
        ac.debug("json", records)

        if (initializedBackgrounds == false ) then
          
for i, bkg in ipairs(records.backgrounds) do
          --ac.console(i)
            local r, g, b, m = string.match(bkg.color, '([%d.]+), ([%d.]+), ([%d.]+), ([%d.]+)')
            
          ac.debug("r", r)
        ac.debug("g", g)
        ac.debug("b", b)
            ac.debug("m", m)

            local content = {
              meshNames = bkg.meshNames,
              color = rgbm(tonumber(r), tonumber(g), tonumber(b), tonumber(m)),
              texture = bkg.texture,
              label = bkg.label
            }
            
         table.insert(configBackgrounds, content)
        end





          initializedBackgrounds = true
        end
        
        ac.debug("configBackgrounds", configBackgrounds)


    end
    





-- Parse the data into separate variables
--local id = records[2].id
--local description1 = records[1].description
--local description2 = records[2].description


    for i, controller in ipairs(configBackgrounds) do
        --TODO: convert string to rgbm
      
        --ac.debug("controllercolor", controller.color)
        --local r, g, b, m = string.match(controller.color, '([%d.]+), ([%d.]+), ([%d.]+), ([%d.]+)')
        --ac.debug("r", r)
        --ac.debug("g", g)
        --ac.debug("b", b)
         --ac.debug("m", m)

         --rgbm(tonumber(r), tonumber(g), tonumber(b), tonumber(m))
        local window = newColorController("colorController" .. i, controller.label, controller.color,
            controller.meshNames, controller.texture) 
                                        --[[ if ui.button("Remove " .. controller.label) then
                removeColorController(controller.id)
            end ]]
        --if window
        --ac.console(window)
    end
    
        
    ui.pushItemWidth(ui.availableSpaceX())
  
    frame = frame + 1
end


function script.onShowWindowMain()

    ac.console("Opened App, here initialize it")
  initializeUI()
    --[[ if light then
    alignOnce = true
    light:dispose()
    light = nil
  end ]]
    --storage.initializedBackgrounds = false
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

--function script.update(dt)
  --ac.console("UPDATE")
  --[[ if light and (storage.align or alignOnce) then
    light.position:set(sim.cameraPosition):addScaled(sim.cameraLook, 0.1)
    light.direction:set(sim.cameraLook)
    alignOnce = false
  end ]]
--end
