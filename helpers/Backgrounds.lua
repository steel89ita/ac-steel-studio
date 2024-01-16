require('helpers/ValueHelpers')

--- new background table
--- @param meshNames table mesh names list
--- @param color rgbm color
--- @param texture string texture slot
--- @param label string background label for selection
--- @return table background table
function newBackground(meshNames, color, texture, label)
    local background = {
        meshNames = { "Plane.001" },
        color = rgbm(0, 0.9, 0.1, 1.0),
        texture = 'txDiffuse',
        label = label
    }
    return background
end



--- change material texture with solid color
--- @param meshes string mesh names list
--- @param texture string texture slot
--- @param color string | rgbm color
--- @return nil
function changeMaterialTexture(meshes, texture, color)
  local foundMeshes = ac.findMeshes(meshes)
    

    if type(color) == "string" then
        ac.console("color is string: " .. color)
        local col = stringToRgbm(color)
        ac.console("converted" .. tostring(rgbm(col.r, col.g, col.b, col.mult)))
        color = col
    end

    ac.console("Change Material texture begin")
    ac.console("meshes: " .. tostring(foundMeshes))
    if type(foundMeshes) == "table" then
        for _, mesh in ipairs(foundMeshes) do
            mesh:setMaterialTexture(texture, color)
        end
    elseif foundMeshes then
        foundMeshes:setMaterialTexture(texture, color)
    end
end

--- create new color controller picker
--- @param inputId string id of color picker controller
--- @param inputLabel string label for picker controller
--- @param inputColor string | rgbm color
--- @param inputMeshName string mesh name
--- @param inputTexture string texture slot to override
--- @param colorPickerType string color picker type
--- @return table controller values
function addColorController(inputId, inputLabel, inputColor, inputMeshName, inputTexture, colorPickerType)
    local controller = {
        id = inputId,
        label = inputLabel,
        color = inputColor,
        meshName = inputMeshName,
        texture = inputTexture
    }


  if type(controller.color) == "string" then
    ac.console("color is string: " .. controller.color)
        local col = stringToRgbm(controller.color)
        ac.console("converted" .. tostring(rgbm(col.r, col.g, col.b, col.mult)))
        controller.color = col
  end
    

    local pickerType = colorPickerType or ui.ColorPickerFlags.PickerHueBar
    --ac.debug("id", id)
    --ac.debug("label", label)
    --ac.debug("color", color)
    --ac.debug("meshName", meshName)
    --ac.debug("texture", texture)


    ui.offsetCursorY(12)

    ui.beginGroup(200)

    ui.setNextItemWidth((ui.availableSpaceX() - 12) / 2)

    ui.text(tostring(controller.label))

    ui.sameLine(0, 12)

    ui.setNextItemWidth(ui.availableSpaceX())

    if inputMeshName == nil then
        controller.meshName = ""
    end
    --meshName = ui.inputText('Mesh:', meshName)


    local meshes = ac.findMeshes(controller.meshName)
    if type(meshes) == "table" then
        for _, mesh in ipairs(meshes) do
            mesh:setMaterialTexture(controller.texture, controller.color)
        end
    elseif meshes then
        meshes:setMaterialTexture(controller.texture, controller.color)
    end

    if controller.meshName ~= "" then
        ui.colorButton(controller.label, controller.color,
            pickerType + ui.ColorPickerFlags.NoSidePreview)
    end

    ui.endGroup()

    return controller
end

--- transform backgrounds table with rgbm color
--- @param data table backgrounds table
--- @return table
local function transformBackgroundTable(data)
    local result = {}
    for i, bkg in ipairs(data) do
        --ac.console(i)
        local r, g, b, m = string.match(bkg.color, '([%d.]+), ([%d.]+), ([%d.]+), ([%d.]+)')

        local content = {
            meshNames = bkg.meshNames,
            color = rgbm(tonumber(r), tonumber(g), tonumber(b), tonumber(m)),
            texture = bkg.texture,
            label = bkg.label
        }

        table.insert(result, content)
    end
    return result
end
