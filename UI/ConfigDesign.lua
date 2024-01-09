function customfunc_2dclouds_set_init(custom)

    if custom then

        local _l_skydome_sets_path = ac.getFolder(4).."\\extension\\config-ext\\Pure\\Skydome_sets\\"
        custom.sets = {}

        io.scanDir(_l_skydome_sets_path, "*", function(name, attrib)
            if attrib.isDirectory then
                if file_exists(_l_skydome_sets_path..name.."\\skydome_script.lua") then
                    table.insert(custom.sets, name)
                end
            end
        end)

        custom.h = #custom.sets * 30

        custom.selected = ""
    end
end

function customfunc_2dclouds_set_render(custom)

    if custom then
        local x = ui.getCursorX()

        custom.selected = custom:getConnectValue(true)
        
        local new = nil
        for i=1, #custom.sets do
            ui.setCursorX(x)
            if ui.radioButton(custom.sets[i], (custom.selected == custom.sets[i])) then 
                custom.selected = custom.sets[i]
                new = custom.selected
            end
        end

        return new
    end

    return nil
end
















function createPureConfigUI(PureUIobj)
--[[
    for k,v in pairs(ui) do
        --if type(v) == "function" then
            ac.debug("ui."..k, v)
        --end
    end
]]

    local page, h, item, h_e
    local connect = PureUIobj:getConnect()


    page = PureUIobj:newPage("Main")

    page:newTextBlock(nil, nil, "Quality Presets")

    h = page:getHPos()
    h_e = 30
    item = page:newButton("qualityLOW", nil, "Low", {size={100,h_e},
                                                     position={0,h},
                                                     background_color={0.1,0.2,0.4}})
    item:setTooltip("Low Clouds settings:\nClouds quality = 0.0\nClouds render distance = 0.5")

    item = page:newButton("qualityMEDIUM", nil, "Medium", {size={100,h_e},
                                                     position={105,h},
                                                     background_color={0.2,0.4,0.1}})
    item:setTooltip("Medium Clouds settings:\nClouds quality = 0.5\nClouds render distance = 1.0")

    item = page:newButton("qualityHIGH", nil, "High", {size={100,h_e},
                                                     position={210,h},
                                                     background_color={0.4,0.3,0.1}})
    item:setTooltip("High Clouds settings:\nClouds quality = 0.85\nClouds render distance = 1.25")

    item = page:newButton("qualityVERYHIGH", nil, "Very High", {size={100,h_e},
                                                     position={315,h},
                                                     background_color={0.4,0.1,0.1}})
    item:setTooltip("Very high Clouds settings:\nClouds quality = 0.90\nClouds render distance = 2.0")
    
    page:shiftHPos(h_e + 20)
    page:newTextBlock(nil, nil, "Pure Checklist:")

    local color_red = {1,0,0}
    local color_orange = {1,0.5,0}
    local color_green = {0,1,0}
    if PureConfig_get_RefFreq() > 0 then
        page:newText(nil, nil, "Reflections frequency is not set to static.", {text_color=color_green} )
    else
        page:newText(nil, nil, "Reflections frequency is set to static!", {text_color=color_red} )
        page:newText(nil, nil, "> Change reflections frequency to minimum \"One face per frame\"" )
        page:newText(nil, nil, "> Settings -> Assetto Corsa -> Video -> Reflections" )
    end

    if PureConfig_get_RefFX() > 0 then
        page:newText(nil, nil, "ReflectionsFX is enabled.", {text_color=color_green} )
    else
        page:newText(nil, nil, "ReflectionsFX is deactivated!", {text_color=color_red} )
        page:newText(nil, nil, "> Activate ReflectionsFX !" )
        page:newText(nil, nil, "> Settings -> Custom Shaders Patch -> REFLECTIONS FX" )
    end
    
    if PureConfig_get_RefIBL() > 0 then
        page:newText(nil, nil, "ReflectionsFX is using proper physically-based sampling.", {text_color=color_green} )
    else
        page:newText(nil, nil, "ReflectionsFX is NOT using proper physically-based sampling.", {text_color=color_orange} )
        page:newText(nil, nil, "> Activate \"Use proper physically-based sampling\"." )
        page:newText(nil, nil, "> Settings -> Custom Shaders Patch -> REFLECTIONS FX" )
        page:newText(nil, nil, "> -> General Cubemap Reflections" )
    end

    -- check for clouds_render method and csp version
    if connect and connect:isConnected() then
        local clouds = connect:getByName("clouds_render.method") or 0
        if clouds > 0 and ac.getPatchVersionCode() < 1992 then
            -- CSP lower 1.77 and 2dclouds
            page:newText(nil, nil, "You need at least CSP 1.78 for skydomes!", {text_color=color_red} )
        end
    end

    page:shiftHPos(20)

    page:newButton("resetPure", "", "Reset Pure")
    page:newButton("resetToDefaults", "", "Reset To Defaults")


    page = PureUIobj:newPage("AI")
    page:newStateValue(nil,nil,"Ambient Luminance", "ambient.luminance")
    item = page:AutoCreateFromConnectName("AI_headlights.ambient_light")
    item:setTooltip("If ambient luminance is under this value, headlights will be switched on.")

    page:newStateValue(nil,nil,"Cubemap Brightness Estimation", "cbe.average")
    item = page:AutoCreateFromConnectName("AI_headlights.CBE")
    item:setTooltip("If CBE is under this value, headlights will be switched on.")

    page:newStateValue(nil,nil,"Fog Dense", "fog.dense")
    item = page:AutoCreateFromConnectName("AI_headlights.fog")
    item:setTooltip("If fog is over this value, headlights will be switched on.")


    page = PureUIobj:newPage("Light")
    page:newTextBlock(nil, nil, "Daylight Multiplier")
    item = page:AutoCreateFromConnectName("light.daylight_multiplier")
    
    page:newTextBlock(nil, nil, "Sunlight")
    item = page:AutoCreateFromConnectName("light.sun.hue")
    item = page:AutoCreateFromConnectName("light.sun.saturation")
    item = page:AutoCreateFromConnectName("light.sun.level")

    page:newTextBlock(nil, nil, "Ambient Light")
    item = page:AutoCreateFromConnectName("light.ambient.hue")
    item = page:AutoCreateFromConnectName("light.ambient.saturation")
    item = page:AutoCreateFromConnectName("light.ambient.level")
    item = page:AutoCreateFromConnectName("light.advanced_ambient_light")

    page:newTextBlock(nil, nil, "Directional Ambient Light")
    item = page:AutoCreateFromConnectName("light.directional_ambient.hue")
    item = page:AutoCreateFromConnectName("light.directional_ambient.saturation")
    item = page:AutoCreateFromConnectName("light.directional_ambient.level")

    page:newTextBlock(nil, nil, "Sky Light")
    item = page:AutoCreateFromConnectName("light.sky.hue")
    item = page:AutoCreateFromConnectName("light.sky.saturation")
    item = page:AutoCreateFromConnectName("light.sky.level")

    page:newTextBlock(nil, nil, "CSP Lights")
    item = page:AutoCreateFromConnectName("csp_lights.bounce")
    item = page:AutoCreateFromConnectName("csp_lights.emissive")
    item = page:AutoCreateFromConnectName("csp_lights.displays")

    page:newTextBlock(nil, nil, "Reflections")
    item = page:AutoCreateFromConnectName("reflections.saturation")
    item = page:AutoCreateFromConnectName("reflections.level")
    item = page:AutoCreateFromConnectName("reflections.emissive_boost")

    page:newTextBlock(nil, nil, "VAO")
    item = page:AutoCreateFromConnectName("vao.amount")
    item = page:AutoCreateFromConnectName("vao.track_exponent")
    item = page:AutoCreateFromConnectName("vao.dynamic_exponent")

    page:newTextBlock(nil, nil, "UI")
    item = page:AutoCreateFromConnectName("ui.white_reference_point")
    page:newStateValue(nil,nil,"White Reference Point", "ui.white_reference_point")


    page = PureUIobj:newPage("Night")

    page:newTextBlock(nil, nil, "Night Light Pollution Multipliers")
    item = page:AutoCreateFromConnectName("nlp.level")
    item = page:AutoCreateFromConnectName("nlp.density")

    page:newSeparator()

    page:newText(nil, nil, "Night Light Pollution")
    h = page:getHPos()
    page:newText(nil, nil, "Camera Position Relevance")
    page:newStateValue(nil,nil,"", "nlp.cam_pos_relevance", {position={165,h}})
    h = page:getHPos()
    page:newText(nil, nil, "Center")
    page:newStateValue(nil,nil,"X", "nlp.center.x", {position={50,h}, unit="m"})
    page:newStateValue(nil,nil,"Y", "nlp.center.y", {position={140,h}, unit="m"})
    page:newStateValue(nil,nil,"Z", "nlp.center.z", {position={230,h}, unit="m"})
    h = page:getHPos()
    page:newText(nil, nil, "Radius")
    page:newStateValue(nil,nil,"", "nlp.radius", {position={50,h}, unit="m"})
    h = page:getHPos()
    page:newText(nil, nil, "Density")
    page:newStateValue(nil,nil,"", "nlp.density", {position={50,h}})
    h = page:getHPos()
    page:newText(nil, nil, "Color")
    page:newStateValue(nil,nil,"R", "nlp.color.r", {position={50,h}})
    page:newStateValue(nil,nil,"G", "nlp.color.g", {position={110,h}})
    page:newStateValue(nil,nil,"B", "nlp.color.b", {position={170,h}})

    page:shiftHPos(20)
    page:newTextBlock(nil, nil, "Lowest Ambient Light")
    item = page:AutoCreateFromConnectName("nlp.lowest_ambient")


    page:shiftHPos(20)
    page:newTextBlock(nil, nil, "Stars")
    item = page:AutoCreateFromConnectName("stars.dynamic_adaption")
    item:setTooltip("If Pure's exposure calculation is used,\nthe exposure is used to improve\nthe star's light dynamics.")
    

    page = PureUIobj:newPage("Clouds")

    page:newTextBlock(nil, nil, "Clouds Render Method")
    item = page:AutoCreateFromConnectName("clouds_render.method")
    item:setTooltip("0: 3D clouds / multi layer\n1: 360° Skydomes")

    local method = PureUIobj.connect:getByName("clouds_render.method", false)

    if method < 1 then
        -- 3D clouds
        page:newTextBlock(nil, nil, "3D clouds")
        h = page:getHPos()
        page:newStateValue(nil,nil,"Cells", "clouds.cell_count", {position={0,h}})
        page:newStateValue(nil,nil,"Subparts", "clouds.subpart_count", {position={75,h}})
        page:newStateValue(nil,nil,"AC Clouds", "clouds.ac_count", {position={180,h}})
        page:shiftHPos(20)
        page:newSeparator()
        page:AutoCreateAllFromMainCategory("clouds", false, false) 
    end
    
    if method > 0 then
        -- 2D clouds

        -- check for clouds_render method and csp version
        if ac.getPatchVersionCode() < 1992 then
            -- CSP lower 1.77 and 2dclouds
            page:newText(nil, nil, "You need at least CSP 1.78 for skydomes!", {text_color=color_red} )
        else
    
            page:newTextBlock(nil, nil, "SKYDOMES")
            page:newTextBlock(nil, nil, "Sets")
            item = page:CreateCustomFromConnectName("clouds2D.set", "Custom", { custom_init = customfunc_2dclouds_set_init,
                                                                custom_render = customfunc_2dclouds_set_render,
                                                                bypassConnect = true })
            --
            item = page:AutoCreateFromConnectName("clouds2D.quality")
            item:setTooltip("1: low (4k)\n2: mid (8k)\n3: high (16k)\n4: ultra (native)")
            
            item = page:AutoCreateFromConnectName("clouds2D.crossfade_time")
            item:setTooltip("Skydome textures are faded/crossfaded in this amount of time.")

            h = page:getHPos()
            page:newTextBlock(nil, nil, "SHADOWS")
            
            item = page:AutoCreateFromConnectName("clouds2D.advanced_shadows")
            item:setTooltip("A 3D clouds layer without visible clouds, but their shadows")
            if item:getConnectValue() then
                page:newStateValue(nil,nil,"Clouds", "clouds.shadow", {position={100,h+5}})
                page:newStateValue(nil,nil,"Skydome", "clouds.cover_shadow", {position={200,h+5}})

                item = page:AutoCreateFromConnectName("clouds2D.advanced_shadows_sun_cover", {position={12,nil}})
                item:setTooltip("Take the skydome's sun cover into account, when making 3d clouds shadows.")

                item = page:AutoCreateFromConnectName("clouds2D.advanced_shadows_speed", {position={12,nil}})
                item:setTooltip("A speed multiplier of those 3d cloud shadows")
            else
                page:newStateValue(nil,nil,"Skydome", "clouds.cover_shadow", {position={100,h+5}})
            end

            page:newTextBlock(nil, nil, "MEMORY")

            item = page:AutoCreateFromConnectName("clouds2D.preload")
            item:setTooltip("Preload all textures to VRAM.\n\nNOT recommended to use!\n\nDue to asynchronous loading of the texture,\nAC's frame timing is not influenced")
            
            item = page:AutoCreateFromConnectName("clouds2D.unload")
            item:setTooltip("If selected, unused texture will be unloaded, to save VRAM.\nThey will be reloaded if needed.\nCSP 1.77p97 (1920) or higher needed!")
            page:newSeparator()
            page:newStateString(nil,nil, "", "clouds2D.info", {})

            page:newTextBlock(nil, nil, "CUSTOMIZATIONS")
            item = page:AutoCreateFromConnectName("clouds2D.brightness")
            item:setTooltip("A global custom brightness of the textures")
            item = page:AutoCreateFromConnectName("clouds2D.contrast")
            item:setTooltip("A global custom contrast of the textures")
        end
    end



    page = PureUIobj:newPage("PP")
    if PureConfig_PPactivated() then
        page:newTextBlock(nil, nil, "PP adjustments")
        page:AutoCreateAllFromMainCategory("pp", false, false)
    else
        page:newTextBlock(nil, nil, "Post Processing is deactivated")
        page:newTextBlock(nil, nil, "PP off Multiplier")
        page:AutoCreateAllFromMainCategory("ppoff", false, false)
    end      
    

    page:newSeparator()

    item = page:newButton("resetPure", nil, "Pure Script", {size={100,25}})
    item:setTooltip("Just resets Pure")
    h = page:getHPos() + 5
    page:newText(nil,nil,"Script loaded:", {position={0,h}})
    page:newStateString(nil,nil, "", "PP.script", {position={90,h}})
    page:shiftHPos(20)

    local n_customParameter = pureCustomScriptConnect:getParameterCount()
    --ü(n_customParameter)
    if n_customParameter > 0 then
        
        local script_version = pureCustomScriptConnect:getWFXVersion()
        if script_version > 0 then
            h = page:getHPos()
            page:newText(nil,nil,"Script version:", {position={0,h}})
            page:newText(nil,nil,script_version, {position={90,h}})
        end

        page:shiftHPos(25)

        -- custom script ui elements
        for i=0,n_customParameter-1 do page:AutoCreateFromConnectID(i, {customConnect = pureCustomScriptConnect}) end
        
        if n_customParameter > 1 then
            -- script name is already a parameter

            page:shiftHPos(10)
            item = page:newButton("SCRIPTsave", nil, "Save Script Settings", {size={200,25}})
            item:setTooltip("Saves only the Script's custom settings!")
            item = page:newButton("SCRIPTload", nil, "Load Script Settings", {size={200,25}})
            item:setTooltip("Loads only the Script's custom settings!")
            item = page:newButton("SCRIPTresetToDefaults", nil, "Reset Script Settings", {size={200,25}})
            item:setTooltip("Resets only the Script's custom settings!")
        else
            page:newText(nil, nil, "No Script Controls")
        end
    end






    page = PureUIobj:newPage("Sound")
    page:AutoCreateAllFromMainCategory("sound", false, false)
    

    page = PureUIobj:newPage("State")

    page:newText(nil, nil, "Stellar")
    h = page:getHPos() - 5
    page:newText(nil,nil,"Sun", {position={0,h}})
    page:newStateValue(nil,nil,"heading", "stellar.sun.heading", {position={40,h}, unit="°"})
    page:newStateValue(nil,nil,"angle", "stellar.sun.angle", {position={155,h}, unit="°"})
    page:newStateValue(nil,nil,"eclipse", "stellar.solar_eclipse", {position={252,h}})
    page:shiftHPos(15)
    h = page:getHPos() - 5
    page:newText(nil,nil,"Moon", {position={0,h}})
    page:newStateValue(nil,nil,"heading", "stellar.moon.heading", {position={40,h}, unit="°"})
    page:newStateValue(nil,nil,"angle", "stellar.moon.angle", {position={155,h}, unit="°"})
    page:newStateValue(nil,nil,"eclipse", "stellar.lunar_eclipse", {position={252,h}})
    page:shiftHPos(15)

    page:newSeparator()

    page:newText(nil, nil, "Weather")
    h = page:getHPos() - 5
    page:newStateValue(nil,nil,"Current", "weather.current", {position={0,h}})
    page:newStateValue(nil,nil,"Next", "weather.next", {position={90,h}})
    page:newStateValue(nil,nil,"Transition", "weather.transition", {position={165,h}})
    page:shiftHPos(15)

    page:newSeparator()



    page:newText(nil, nil, "Clouds")
    h = page:getHPos() - 5
    page:newStateValue(nil,nil,"Cells", "clouds.cell_count", {position={0,h}})
    page:newStateValue(nil,nil,"Subparts", "clouds.subpart_count", {position={75,h}})
    page:newStateValue(nil,nil,"AC Clouds", "clouds.ac_count", {position={180,h}})
    page:shiftHPos(15)
    h = page:getHPos()
    page:newText(nil, nil, "Cloud shadow at camera postition:")
    page:newStateValue(nil,nil,"", "clouds.shadow", {position={205,h}})

    page:newSeparator()

    page:newText(nil, nil, "Night Light Pollution")
    h = page:getHPos()
    page:newText(nil, nil, "Camera Position Relevance")
    page:newStateValue(nil,nil,"", "nlp.cam_pos_relevance", {position={165,h}})
    h = page:getHPos()
    page:newText(nil, nil, "Center")
    page:newStateValue(nil,nil,"X", "nlp.center.x", {position={50,h}, unit="m"})
    page:newStateValue(nil,nil,"Y", "nlp.center.y", {position={140,h}, unit="m"})
    page:newStateValue(nil,nil,"Z", "nlp.center.z", {position={230,h}, unit="m"})
    h = page:getHPos()
    page:newText(nil, nil, "Radius")
    page:newStateValue(nil,nil,"", "nlp.radius", {position={50,h}, unit="m"})
    h = page:getHPos()
    page:newText(nil, nil, "Density")
    page:newStateValue(nil,nil,"", "nlp.density", {position={50,h}})
    h = page:getHPos()
    page:newText(nil, nil, "Color")
    page:newStateValue(nil,nil,"R", "nlp.color.r", {position={50,h}})
    page:newStateValue(nil,nil,"G", "nlp.color.g", {position={110,h}})
    page:newStateValue(nil,nil,"B", "nlp.color.b", {position={170,h}})

    page:newSeparator()

    page:newText(nil, nil, "Cubemap Brightness Estimation")
    h = page:getHPos()
    page:newStateValue(nil,nil,"Minimum", "cbe.minimum")
    page:newStateValue(nil,nil,"Maximum", "cbe.maximum", {position={110,h}})
    page:newStateValue(nil,nil,"Average", "cbe.average", {position={225,h}})

    page:newSeparator()

    page:newText(nil, nil, "Track")
    h = page:getHPos()
    page:newText(nil, nil, "Orientation")
    page:newStateValue(nil,nil,"heading", "track.heading", {position={70,h}, unit="°"})

    page:newSeparator()

    page:newText(nil, nil, "Camera")
    h = page:getHPos()
    page:newText(nil, nil, "Orientation")
    page:newStateValue(nil,nil,"heading", "camera.orientation.heading", {position={70,h}, unit="°"})
    page:newStateValue(nil,nil,"angle", "camera.orientation.angle", {position={190,h}, unit="°"})
    h = page:getHPos()
    page:newText(nil, nil, "Position")
    page:newStateValue(nil,nil,"X", "camera.position.x", {position={70,h}, unit="m"})
    page:newStateValue(nil,nil,"Y", "camera.position.y", {position={170,h}, unit="m"})
    page:newStateValue(nil,nil,"Z", "camera.position.z", {position={270,h}, unit="m"})
    h = page:getHPos()
    page:newText(nil, nil, "Direction")
    page:newStateValue(nil,nil,"X", "camera.direction.x", {position={70,h}})
    page:newStateValue(nil,nil,"Y", "camera.direction.y", {position={170,h}})
    page:newStateValue(nil,nil,"Z", "camera.direction.z", {position={270,h}})
    h = page:getHPos()
    page:newText(nil, nil, "FOV")
    page:newStateValue(nil,nil,"", "camera.fov", {position={70,h}, unit="°"})
    h = page:getHPos()
    page:newText(nil, nil, "Movement")
    page:newStateValue(nil,nil,"X", "camera.moving.x", {position={70,h}, unit="m/f"})
    page:newStateValue(nil,nil,"Y", "camera.moving.y", {position={170,h}, unit="m/f"})
    page:newStateValue(nil,nil,"Z", "camera.moving.z", {position={270,h}, unit="m/f"})
    h = page:getHPos()
    page:newText(nil, nil, "Speed")
    page:newStateValue(nil,nil,"", "camera.speed", {position={70,h}, unit="km/h"})

    page:newSeparator()

    page:newText(nil, nil, "FPS")
    h = page:getHPos() - 5
    page:newStateValue(nil,nil,"sync", "fps.sync", {position={0,h}})
    page:newStateValue(nil,nil,"async", "fps.async", {position={120,h}})
    page:shiftHPos(15)


    page = PureUIobj:newPage("Debug")
    page:AutoCreateAllFromMainCategory("debug", false, false)

    
    page = PureUIobj:newPage("Shaders")
    page:AutoCreateAllFromMainCategory("shaders", true, true)
   
end