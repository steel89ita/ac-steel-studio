local _l_section = nil
local _l_key = nil
local _l_item = nil

function PureConfigInfoHandler(e)
    if e then
        _l_section = e.section
        _l_key = e.key
        _l_item = e
    end
end

local _l_color_parameter = rgbm(0.5, 0.7, 1, 1)

function showPureConfigInfo()

    if _l_section then

        ui.pushFont(ui.Font.Title)

        if _l_section == "AI_headlights" then

            ui.text("AI headlights control")
            ui.separator()
            ui.pushStyleColor(ui.StyleColor.Text, _l_color_parameter)
            ui.text("AI headlights.ambient_light")
            ui.popStyleColor(1)
            ui.text("Headlights will be switched on, if ambient light")
            ui.text("luminance is falls below this value.")
            ui.text("")
            ui.pushStyleColor(ui.StyleColor.Text, _l_color_parameter)
            ui.text("AI headlights.fog")
            ui.popStyleColor(1)
            ui.text("Headlights will be switched on, if fog dense")
            ui.text("exceeds this value.")

        elseif _l_section == "ppoff" then
            
            ui.pushStyleColor(ui.StyleColor.Text, _l_color_parameter)
            ui.text(_l_item.name)
            ui.popStyleColor(1)
            ui.text("If PostProcessing is deactivated, you can")
            ui.text("adjust the overall brightness here.")
        end

        ui.popFont()

    end
end