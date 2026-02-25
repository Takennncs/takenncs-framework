Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		local playerPed = PlayerPedId()
		local playerId  = PlayerId()

        SetEveryoneIgnorePlayer(playerPed, true)

		SetPoliceIgnorePlayer(playerPed, true)

		if GetPlayerWantedLevel(playerId) ~= 0 then
			SetPlayerWantedLevel(playerId, 0, false)
			SetPlayerWantedLevelNow(playerId, false)
		end
	end
end)
