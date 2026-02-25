-- takenncs-fw
CreateThread(function()
    while true do
        Wait(0)
        HideHudComponentThisFrame(1) 
        HideHudComponentThisFrame(2) 
        HideHudComponentThisFrame(3) 
        HideHudComponentThisFrame(4) 
        HideHudComponentThisFrame(6) 
        HideHudComponentThisFrame(7) 
        HideHudComponentThisFrame(8)
        HideHudComponentThisFrame(9) 
        HideHudComponentThisFrame(20) 
        HideHudComponentThisFrame(21) 
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		HideHudComponentThisFrame( 7 )
		HideHudComponentThisFrame( 9 )
		HideHudComponentThisFrame( 3 )
		HideHudComponentThisFrame( 4 )
		HideHudComponentThisFrame( 13 )
	end
end)