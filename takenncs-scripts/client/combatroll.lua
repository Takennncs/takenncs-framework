CreateThread(function()
  while true do 
    local wait_time = 1000 
    if IsPedArmed(PlayerPedId(), 4 or 2) and IsPlayerFreeAiming(PlayerId())  then 
      wait_time = 0 
      DisableControlAction(0, 22, true)
    end
    Wait(wait_time)
  end
end)