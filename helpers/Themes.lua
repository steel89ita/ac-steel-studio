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

        local themeFiles = io.scanDir(STEEL_STUDIO_FOLDER_PATH, "theme_*.json")

        for i, file in pairs(themeFiles) do
            local records = DecodeJSON(STEEL_STUDIO_FOLDER_PATH .. '\\' .. file)
      if records ~= nil then
                



        --convert colors to rgbm, required for color picker
        if records.backgrounds ~= nil then
                ac.debug("Records backgrounds", records.backgrounds)
                for i, item in pairs(records.backgrounds) do
                        if type(item.color) == "string" then
                            local col = stringToRgbm(item.color)
                            item.color = col
                        end
                    --item.color = rgbm(0.5, 0.2, 1, 1.0)
                end
            end

                table.insert(LOADED_THEMES, deepcopy(records))
            else
                ac.console("Records not found!")
            end
        end
        ac.debug("Found Theme Files", themeFiles)
        ac.debug("LOADED THEMES", LOADED_THEMES)


        CURRENT_THEME = deepcopy(LOADED_THEMES[1])
        
        



    

    ac.debug("Fetched Themes", FETCHED_THEMES)
    
end



