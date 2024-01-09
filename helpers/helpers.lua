
-------------------------------- UI Methods --------------------------------
function scale(value)
    return LBS * value
end



function newLight(position, color)
    local light = ac.LightSource(ac.LightType.Regular)
	light.position = position
	light.direction = vec3(0, 0, 1)
	light.spot = 0
	light.spotSharpness = 0.99
	light.color = color
	light.range = 10
	light.shadows = true
	light.fadeAt = 500
	light.fadeSmooth = 200
    return light
end



function newColorController(id, label, color, meshName, texture)
    local window = ui.childWindow(id, vec2(ui.availableSpaceX(), 100), function()
        ui.offsetCursorY(30)

        ui.columns(3, true, "cols")

        ui.text(label)

        ui.nextColumn()

        ac.debug("id", id)
        ac.debug("label", label)
        ac.debug("color", color)
        ac.debug("meshNames", meshName)
        ac.debug("texture", texture)

        

        if meshName == nil then
            meshName = ""
        end
        meshName = ui.inputText('Mesh:', meshName)

        local meshes = ac.findMeshes(meshName)
        if type(meshes) == "table" then
            for _, mesh in ipairs(meshes) do
                mesh:setMaterialTexture(texture, color)
            end
        elseif meshes then
            meshes:setMaterialTexture(texture, color)
        end

        ui.nextColumn()

        if meshName ~= "" then
            ui.colorButton(label, color,
                ui.ColorPickerFlags.PickerHueBar + ui.ColorPickerFlags.NoAlpha + ui.ColorPickerFlags.NoSidePreview)
        else
            ui.text("Enter mesh name to enable color picker")
        end

        ui.nextColumn()


        ui.offsetCursorY(40)
    end)
    return window
end

function addColorController(id, label, color, meshName, texture)
    
    local controller = {
        id = id,
        label = label,
        color = color,
        meshNames = meshName,
        texture = texture
    }
        ac.debug("id", id)
        ac.debug("label", label)
        ac.debug("color", color)
        ac.debug("meshNames", meshName)
        ac.debug("texture", texture)

        if meshName == nil then
            meshName = ""
        end
        --meshName = ui.inputText('Mesh:', meshName)

        local meshes = ac.findMeshes(meshName)
        if type(meshes) == "table" then
            for _, mesh in ipairs(meshes) do
                mesh:setMaterialTexture(texture, color:rgbm(1))
            end
        elseif meshes then
            meshes:setMaterialTexture(texture, color:rgbm(1))
        end

    if meshName ~= "" then
        controller.color = ui.colorButton(label, color,
            ui.ColorPickerFlags.PickerHueBar + ui.ColorPickerFlags.NoAlpha + ui.ColorPickerFlags.NoSidePreview)
    end
        
    return controller
end

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end


function contains(list, x)
    for _, v in pairs(list) do
        if v == x then return true end
    end
    return false
end