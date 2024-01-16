require('constants')
require('helpers/Files')
require('helpers/ValueHelpers')

function changeConstant()
    TEST_VALUE = 48784784874
    ac.console("VALUE CONTANT FROM THEMES: " .. TEST_VALUE)
end

function logTheme(theme)
    ac.console("theme")
end

function FetchThemes()
    if not FETCHED_THEMES then
        local themeFiles = io.scanDir(STEEL_STUDIO_FOLDER_PATH, "theme_*.json")

        for i, file in pairs(themeFiles) do
            local records = DecodeJSON(STEEL_STUDIO_FOLDER_PATH .. '\\' .. file)
            if records ~= nil then
                table.insert(THEMES, records)
            else
                ac.console("Records not found!")
            end
        end
        ac.debug("Found Theme Files", themeFiles)
        ac.debug("CONST THEMES", THEMES)

    CURRENT_THEME = deepcopy(THEMES[1])
        
        ac.debug("CONST CURR THEME", CURRENT_THEME)
        
        FETCHED_THEMES = true
    end


    

    ac.debug("Fetched Themes", FETCHED_THEMES)
    
end



