--- teleport car to location
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
end



function FetchLocations()

        local file = io.scanDir(STEEL_STUDIO_FOLDER_PATH, LOCATIONS_FILE_NAME)
        ac.debug("Location File", file)


        if file then
            FOUND_LOCATIONS_FILE = true
        else
            FOUND_LOCATIONS_FILE = false
        end

        ac.debug("Found Locations File", FOUND_LOCATIONS_FILE)
        

    local records = DecodeJSON(STEEL_STUDIO_FOLDER_PATH .. '\\' .. file[1])
        if records ~= nil then
            LOCATIONS = records
        else
            ac.console("Locations: can't decode json!")
        end


    ac.debug("Fetched Locations", FETCHED_LOCATIONS)
end
