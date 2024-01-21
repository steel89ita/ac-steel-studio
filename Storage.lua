require('constants')

-- Storage data - not relative to track customizations
Storage = ac.storage {
    defaultColor = rgb(0.6, 0.9, 1),
    hideCrew = false,
  hideDrivers = false,
    disableAudio = false,
    colorPickerType = ui.ColorPickerFlags.PickerHueBar
}



function SetStorageSettings()
    ac.console("Steel Studio: Applying Saved Storage Settings")

    if Storage.hideCrew then crew:setVisible(false) end
  if Storage.hideDrivers then drivers:setVisible(false) end
    
    if Storage.disableAudio then
        for i, channel in pairs(AUDIO_VOLUME) do
            AUDIO_VOLUME[i] = 0
        end
    else
        AUDIO_VOLUME = deepcopy(INITIAL_AUDIO_VOLUME)
    end
end
