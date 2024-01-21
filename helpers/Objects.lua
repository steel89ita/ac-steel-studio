--[[ --- teleport car to location
--- @param position number position coordinates
--- @param direction number look coordinates
--- @return nil
function teleportCar(position, direction)
    local customCarPosition = vec3(position)
    local customCarDirection = -vec3(direction)
    TeleportTimer = setInterval(function()
        physics.setCarPosition(0, customCarPosition, customCarDirection)
        clearInterval(TeleportTimer)
    end)
end ]]



function FetchObjects()
    local file = io.open(OBJECTS_FILE_PATH, "r")
    ac.debug("Objects File", file)


    if file then
        FOUND_OBJECTS_FILE = true
        local records = DecodeJSON(OBJECTS_FILE_PATH)
        if records ~= nil then

            OBJECTS = records
        else
            ac.console("Objects: can't decode json!")
        end
    else
        FOUND_OBJECTS_FILE = false
    end

    ac.debug("Found Objects File", FOUND_OBJECTS_FILE)





    ac.debug("Fetched Objects", FETCHED_OBJECTS)
end
