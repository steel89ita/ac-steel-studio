
-------------------------------- UI Methods --------------------------------
function scale(value)
    return LBS * value
end

-- deepcopy to copy tables and remove references
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
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


function stringToVec3(coordString)
  ac.debug("input position", coordString)
  local x, y, z = string.match(coordString, "([%d.-]+),%s*([%d.-]+),%s*([%d.-]+)")
  return { x = tonumber(x), y = tonumber(y), z = tonumber(z) }
end

function stringToRgbm(colorString)
    local r, g, b, m = string.match(colorString, '([%d.]+), ([%d.]+), ([%d.]+), ([%d.]+)')
    return rgbm(tonumber(r), tonumber(g), tonumber(b), tonumber(m))
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
