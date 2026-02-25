TriggerEvent('takenncs-dispatch:client:sendDispatch', 
    '10-71',                 -- kood
    'police',                -- töö
    'TULISTAMINE',           -- sõnum
    true,                    -- panic (true/false)
    source                   -- vastaja ID (valikuline)
)

-------------
RegisterNetEvent('takenncs-dispatch:client:showResponder')
AddEventHandler('takenncs-dispatch:client:showResponder', function(data)
    print(data.worker .. ' võttis vastu väljakutse ' .. data.id)
end)

-- Aktiivsed callsid
local calls = exports['takenncs-dispatch']:getCalls()
print(json.encode(calls))