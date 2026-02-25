TakennCS.GetPlayer = function(source)
    return TakennCS.Players[source]
end

TakennCS.GetPlayers = function()
    return TakennCS.Players
end

function TakennCS.GetPlayerName(source)
    local player = TakennCS.GetPlayer(source)
    if player then
        return player.name or GetPlayerName(source)
    end
    return GetPlayerName(source)
end

exports('GetPlayer', TakennCS.GetPlayer)
exports('GetPlayers', TakennCS.GetPlayers)

TakennCS.GetPlayerFromIdentifier = function(identifier)
    for _, player in pairs(TakennCS.Players) do
        if player.identifier == identifier then
            return player
        end
    end
    return nil
end

print('[takenncs-fw] Players module loaded')