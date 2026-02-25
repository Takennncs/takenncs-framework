CreateThread(function()
	local playerPed = PlayerPedId()

	while true do
		DisablePlayerVehicleRewards(playerPed)
		Wait(50)
	end
end)