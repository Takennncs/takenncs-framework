print('[takenncs-fw] Factions module loading...')

local FactionAccounts = {}

CreateThread(function()
    Wait(1000)
    MySQL.query('SELECT name, money FROM jobs WHERE type IN ("illegal", "normal")', {}, function(result)
        if result and #result > 0 then
            for i = 1, #result do
                FactionAccounts[result[i].name] = result[i].money or 0
            end
            if Config.Debug then
                print('[takenncs-fw] Faction accounts loaded: ' .. json.encode(FactionAccounts))
            end
        end
    end)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for faction, money in pairs(FactionAccounts) do
            MySQL.update('UPDATE jobs SET money = ? WHERE name = ?', {tonumber(money), faction}, function(affected)
                if Config.Debug then
                    print(('[takenncs-fw] Saved faction %s money: %d'):format(faction, tonumber(money)))
                end
            end)
        end
    end
end)

function TakennCS.GetFactionMoney(faction)
    return FactionAccounts[faction] or 0
end

function TakennCS.AddFactionMoney(faction, amount)
    if not FactionAccounts[faction] then
        FactionAccounts[faction] = 0
    end
    FactionAccounts[faction] = FactionAccounts[faction] + amount
end

function TakennCS.RemoveFactionMoney(faction, amount)
    if not FactionAccounts[faction] then
        return false
    end
    if FactionAccounts[faction] < amount then
        return false
    end
    FactionAccounts[faction] = FactionAccounts[faction] - amount
    return true
end

function TakennCS.GetFactionOnlineCount(faction)
    local count = 0
    local allPlayers = TakennCS.GetPlayers()
    for source, player in pairs(allPlayers) do
        if player.character and player.character.job == faction then
            count = count + 1
        end
    end
    return count
end

exports('GetFactionMoney', TakennCS.GetFactionMoney)
exports('AddFactionMoney', TakennCS.AddFactionMoney)
exports('RemoveFactionMoney', TakennCS.RemoveFactionMoney)
exports('GetFactionOnlineCount', TakennCS.GetFactionOnlineCount)

print('[takenncs-fw] Factions module loaded')
