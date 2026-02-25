local Core = nil

CreateThread(function()
    local attempts = 0
    while not Core do
        Core = exports['takenncs-fw']:GetCoreObject()
        if not Core then
            Wait(100)
            attempts = attempts + 1
            if attempts > 50 then
             return
            end
        end
    end
    print('[takenncs-multicharacter] Framework connected')
end)

RegisterNetEvent('takenncs:logout')
AddEventHandler('takenncs:logout', function()
    local src = source
    
    if TakennCS and TakennCS.Players then
        TakennCS.Players[src] = nil
    end
end)

print('[takenncs-multicharacter] Server loaded')