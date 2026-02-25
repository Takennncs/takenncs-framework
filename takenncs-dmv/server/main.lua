local Core = exports['takenncs-fw']:GetCoreObject()

RegisterNetEvent('takenncs-dmv:server:startExam')
AddEventHandler('takenncs-dmv:server:startExam', function()
    local src = source
    local player = Core.GetPlayer(src)

    if player and player.character then
        MySQL.query('SELECT driver_license FROM characters WHERE citizenid = ?', 
            { player.character.citizenid }, 
            function(result)

                local hasLicense = false
                
                if result and result[1] then
                    local licenseValue = result[1].driver_license
                    
                    if licenseValue == 1 or licenseValue == "1" or licenseValue == true then
                        hasLicense = true
                    end
                end
                
                if hasLicense then
                    TriggerClientEvent('ox_lib:notify', src, {
                        title = 'Autokool',
                        description = 'Te juba omate juhiluba!',
                        type = 'error'
                    })
                    return
                end
                
                local cashAmount = exports.ox_inventory:Search(src, 'count', 'money')
                
                if cashAmount and cashAmount >= Config.Price then

                    MySQL.query('SELECT points FROM license_points WHERE citizenid = ? AND license = ?', 
                        { player.character.citizenid, 'dmv' }, 
                        function(result2)
                            
                            if result2 and result2[1] and result2[1].points > 0 then
                                TriggerClientEvent('ox_lib:notify', src, {
                                    title = 'Autokool',
                                    description = 'Te ei saa hetkel juhilube teha! (Teil on ' .. result2[1].points .. ' veapunkti)',
                                    type = 'error'
                                })
                            else
                                local removed = exports.ox_inventory:RemoveItem(src, 'money', Config.Price)
                                
                                if removed then
                                    TriggerClientEvent('takenncs-dmv:client:startExam', src)
                                    
                                    TriggerClientEvent('ox_lib:notify', src, {
                                        title = 'Autokool',
                                        description = "Eksamitasu " .. Config.Price .. "$ võeti sularahast. Edu eksamil!",
                                        type = 'success'
                                    })
                                else
                                    TriggerClientEvent('ox_lib:notify', src, {
                                        title = 'Autokool',
                                        description = 'Viga raha eemaldamisel!',
                                        type = 'error'
                                    })
                                end
                            end
                        end
                    )
                else
                    TriggerClientEvent('ox_lib:notify', src, {
                        title = 'Autokool',
                        description = 'Teil ei ole piisavalt sularaha! Vaja ' .. Config.Price .. '$',
                        type = 'error'
                    })
                end
            end
        )
    end
end)