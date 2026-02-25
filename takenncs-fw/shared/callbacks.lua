TakennCS = TakennCS or {}
TakennCS.Callbacks = TakennCS.Callbacks or {}

function TakennCS.RegisterCallback(name, cb)
    TakennCS.Callbacks[name] = cb
    if Config and Config.Debug then
        print(('[takenncs-fw] Callback registered: %s'):format(name))
    end
end

print('[takenncs-fw] Shared callbacks loaded')