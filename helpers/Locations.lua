--- teleport car to location
--- @param position number position coordinates
--- @param direction number look coordinates
--- @param carIndex number car index
--- @return nil
function teleportCar(position, direction, --[[optional]]carIndex)
    local customCarPosition = vec3(position)
  local customCarDirection = -vec3(direction)
    local carIdx = carIndex or 0
  TeleportTimer = setInterval(function()
        physics.setCarPosition(carIdx, customCarPosition, customCarDirection)
        clearInterval(TeleportTimer)
    end)
end



function FetchLocations()

    local file = io.open(STEEL_STUDIO_FOLDER_PATH .. '\\' .. LOCATIONS_FILE_NAME, "r")
        ac.debug("Location File", file)


        if file then
        FOUND_LOCATIONS_FILE = true
        local records = DecodeJSON(STEEL_STUDIO_FOLDER_PATH .. '\\' .. LOCATIONS_FILE_NAME)
        if records ~= nil then
            LOCATIONS = records
        else
            ac.console("Locations: can't decode json!")
        end
        else
            FOUND_LOCATIONS_FILE = false
        end

        ac.debug("Found Locations File", FOUND_LOCATIONS_FILE)
        

    


    ac.debug("Fetched Locations", FETCHED_LOCATIONS)
end
