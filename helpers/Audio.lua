require('constants')


--- set audio volume
--- @return nil
function SetGameVolume()
  for k, v in pairs(AUDIO_VOLUME) do
    ac.setAudioVolume(k, v)
  end
end

--- initialize audio_volume and intial_audio_volume variables
--- @return nil
function InitializeAudio()
    for i, channel in pairs(GAME_AUDIO_CHANNELS) do
      AUDIO_VOLUME[channel] = ac.getAudioVolume(channel)
    end
    INITIAL_AUDIO_VOLUME = deepcopy(AUDIO_VOLUME)
end
