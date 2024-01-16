-- Storage data - not relative to track customizations
Storage = ac.storage {
    defaultColor = rgb(0.6, 0.9, 1),
    hideCrew = false,
    hideDrivers = false,
    colorPickerType = ui.ColorPickerFlags.PickerHueBar
}



function SetStorageSettings()
    ac.console("Steel Studio: Applying Saved Storage Settings")

    if Storage.hideCrew then crew:setVisible(false) end
    if Storage.hideDrivers then drivers:setVisible(false) end
end
