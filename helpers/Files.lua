local json = require('lib/json')


--- open and decode json
--- @param file string file path to open
--- @return table | nil
function DecodeJSON(file)
    local file = io.open(file, "r")
    if file == nil then
        ac.console("error: file not found!")
        return nil
    else
        local data = file:read("*all")
        file:close()
        local records = json.decode(data)
        return records
    end
end
