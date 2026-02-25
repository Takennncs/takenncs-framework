-- -- takenncs-framework
-- local isCrouch = false

-- Citizen.CreateThread(function()
-- 	while true do
-- 		loadAnimSet()
-- 		doAnim(isCrouch)
-- 		Citizen.Wait(500)
-- 	end
-- end)

-- function loadAnimSet()
-- 	RequestAnimSet("move_ped_crouched")
-- 	while not HasAnimSetLoaded("move_ped_crouched") do 
-- 		Citizen.Wait(50)
-- 	end 
-- end

-- function doAnim(toggle)
-- 	local ped = GetPlayerPed(-1)
-- 	if toggle then
-- 		SetPedMovementClipset(ped, "move_ped_crouched", 0.25)
-- 		isCrouch = true
-- 	else
-- 		ResetPedMovementClipset(ped, 0)
-- 		isCrouch = false
-- 	end
-- end

-- RegisterCommand('crouch', function()
-- 	doAnim(not isCrouch)
-- end)

-- RegisterKeyMapping('crouch', 'Crouch', 'keyboard', 'Z')