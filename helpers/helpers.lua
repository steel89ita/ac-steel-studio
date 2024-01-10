
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

function changeMaterialTexture(meshes, texture, color)
    local foundMeshes = ac.findMeshes(meshes)

    ac.console("Change Material texture begin")
    ac.console(foundMeshes)
    if type(foundMeshes) == "table" then
        for _, mesh in ipairs(foundMeshes) do
      mesh:setMaterialTexture(texture, color)
    end
    elseif foundMeshes then
        foundMeshes:setMaterialTexture(texture, color)
  end
end

function newColorController(id, label, color, meshName, texture)
  local pickedColor = nil
    local window = ui.childWindow(id, vec2(ui.availableSpaceX(), 100), function()
        
        ui.offsetCursorY(30)

        ui.columns(3, true, "cols")

        ui.text(label)

        ui.nextColumn()

        --ac.debug("id", id)
        --ac.debug("label", label)
        --ac.debug("color", color)
        --ac.debug("meshNames", meshName)
        --ac.debug("texture", texture)

        

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
            pickedColor = ui.colorButton(label, color,
                ui.ColorPickerFlags.PickerHueBar + ui.ColorPickerFlags.NoAlpha + ui.ColorPickerFlags.NoSidePreview)
        else
            ui.text("Enter mesh name to enable color picker")
        end

        ui.nextColumn()

        if pickedColor ~= nil then
            ui.text(pickedColor)
        end
        

        ui.offsetCursorY(40)
    end)
    return pickedColor
end

function addColorController(inputId, inputLabel, inputColor, inputMeshName, inputTexture, colorPickerType)
    
    local controller = {
        id = inputId,
        label = inputLabel,
        color = inputColor,
        meshNames = inputMeshName,
        texture = inputTexture
  }
    

    local pickerType = colorPickerType or ui.ColorPickerFlags.PickerHueBar
        --ac.debug("id", id)
        --ac.debug("label", label)
        --ac.debug("color", color)
        --ac.debug("meshNames", meshName)
        --ac.debug("texture", texture)


        ui.offsetCursorY(12)

  ui.beginGroup(200)
        
    ui.setNextItemWidth((ui.availableSpaceX() - 12) / 2)

  ui.text(tostring(controller.label))

  ui.sameLine(0, 12)

    ui.setNextItemWidth(ui.availableSpaceX())
        
    if inputMeshName == nil then
            controller.meshNames = ""
        end
        --meshName = ui.inputText('Mesh:', meshName)

        
    local meshes = ac.findMeshes(controller.meshNames)
        if type(meshes) == "table" then
            for _, mesh in ipairs(meshes) do
                mesh:setMaterialTexture(controller.texture, controller.color)
            end
        elseif meshes then
        meshes:setMaterialTexture(controller.texture, controller.color)
        end

    if controller.meshNames ~= "" then
        ui.colorButton(controller.label, controller.color,
            pickerType + ui.ColorPickerFlags.NoAlpha + ui.ColorPickerFlags.NoSidePreview)

        
    end
  
    ui.endGroup()

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