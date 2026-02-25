local chatInputActive = false
local chatInputActivating = false
local chatHidden = true
local chatLoaded = false

RegisterNetEvent('chatMessage', function(title, type, text)
    local args = { text }

    if title ~= "" then
        table.insert(args, 1, title)
    end

    local icon

    if type == 'success' then
        icon = [[
            <div class="p-1 bg-green-900 rounded-lg flex-shrink-0">
                <svg class="h-6 w-6 text-green-400" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
            </div>
        ]]
    elseif type == 'error' then
        icon = [[
            <div class="p-1 bg-red-900 rounded-lg flex-shrink-0">
                <svg class="h-6 w-6 text-red-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" d="m9.75 9.75 4.5 4.5m0-4.5-4.5 4.5M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" />
                </svg>
            </div>
        ]]
    elseif type == 'info' then
        icon = [[
            <div class="p-1 bg-blue-900 rounded-lg flex-shrink-0">
                <svg class="h-6 w-6 text-blue-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" d="m11.25 11.25.041-.02a.75.75 0 0 1 1.063.852l-.708 2.836a.75.75 0 0 0 1.063.853l.041-.021M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Zm-9-3.75h.008v.008H12V8.25Z" />
                </svg>
            </div>
        ]]
    elseif type == 'warning' then
        icon = [[
            <div class="p-1 bg-yellow-900 rounded-lg flex-shrink-0">
                <svg class="h-6 w-6 text-yellow-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126ZM12 15.75h.007v.008H12v-.008Z" />
                </svg>
            </div>
        ]]
    elseif type == '311' then
        icon = [[
            <div class="p-1 bg-orange-900 rounded-lg flex-shrink-0">
<svg class="h-6 w-6 text-orange-400" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
  <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 5.464V3.099m0 2.365a5.338 5.338 0 0 1 5.133 5.368v1.8c0 2.386 1.867 2.982 1.867 4.175C19 17.4 19 18 18.462 18H5.538C5 18 5 17.4 5 16.807c0-1.193 1.867-1.789 1.867-4.175v-1.8A5.338 5.338 0 0 1 12 5.464ZM6 5 5 4M4 9H3m15-4 1-1m1 5h1M8.54 18a3.48 3.48 0 0 0 6.92 0H8.54Z"/>
</svg>
            </div>
        ]]
    elseif type == 'announce' then
        icon = [[
            <div class="p-1 bg-red-900 rounded-lg flex-shrink-0">
                <svg class="h-6 w-6 text-red-400" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
                    <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 9H5a1 1 0 0 0-1 1v4a1 1 0 0 0 1 1h6m0-6v6m0-6 5.419-3.87A1 1 0 0 1 18 5.942v12.114a1 1 0 0 1-1.581.814L11 15m7 0a3 3 0 0 0 0-6M6 15h3v5H6v-5Z"/>
                </svg>
            </div>
        ]]
    elseif type == 'ad' then
        icon = [[
            <div class="p-1 bg-rose-900 rounded-lg flex-shrink-0">
            <svg class="h-6 w-6 text-rose-400" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
  <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 9h5m3 0h2M7 12h2m3 0h5M5 5h14a1 1 0 0 1 1 1v9a1 1 0 0 1-1 1h-6.616a1 1 0 0 0-.67.257l-2.88 2.592A.5.5 0 0 1 8 18.477V17a1 1 0 0 0-1-1H5a1 1 0 0 1-1-1V6a1 1 0 0 1 1-1Z"/>
</svg>
            </div>
        ]]
    elseif type == 'admin' then
        icon = [[
            <div class="p-1 bg-stone-900 rounded-lg flex-shrink-0">
                <svg class="h-6 w-6 text-stone-400" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
                    <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m8 8-4 4 4 4m8 0 4-4-4-4m-2-3-4 14"/>
                </svg>
            </div>
        ]]
    elseif type == 'adminchat' then
        icon = [[
            <div class="p-1 bg-amber-900 rounded-lg flex-shrink-0">
            <svg class="h-6 w-6 text-amber-400" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17h6l3 3v-3h2V9h-2M4 4h11v8H9l-3 3v-3H4V4Z"/>
            </svg>
            </div>
        ]]
    else
        icon = [[
            <div class="p-1 bg-gray-900 rounded-lg flex-shrink-0">
                <svg class="h-6 w-6 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126ZM12 15.75h.007v.008H12v-.008Z" />
                </svg>
            </div>
        ]]
    end

    local template = [[
        <div class="chat-message inline-block w-2/3 rounded-lg flex items-start bg-slate-800/85 bg-opacity-100 p-2.5 shadow mb-1">
            <div class="mr-3 flex-shrink-0">]] .. icon .. [[</div>
            <div class="break-words">
                <strong class="text-sm font-medium text-gray-200">{0}</strong>
                <p class="mt-1 text-sm text-gray-400">{1}</p>
            </div>
        </div>
    ]]

    SendNUIMessage({
        type = 'ON_MESSAGE',
        message = {
            template = template,
            args = {title, text}
        }
    })
end)

RegisterNetEvent('__cfx_internal:serverPrint', function(msg)
    SendNUIMessage({
        type = 'ON_MESSAGE',
        message = {
            templateId = 'print',
            multiline = true,
            args = { msg }
        }
    })
end)

RegisterNetEvent('chat:addMessage', function(message)
    SendNUIMessage({
        type = 'ON_MESSAGE',
        message = message
    })
end)

RegisterNetEvent('chat:addSuggestion', function(name, help, params)
	SendNUIMessage({
		type = 'ON_SUGGESTION_ADD',
		suggestion = {
			name = name,
			help = help,
			params = params or nil
		}
	})
end)

RegisterNetEvent('chat:addSuggestions', function(suggestions)
	for _, suggestion in ipairs(suggestions) do
		SendNUIMessage({
			type = 'ON_SUGGESTION_ADD',
			suggestion = suggestion
		})
	end
end)

RegisterNetEvent('chat:removeSuggestion', function(name)
	SendNUIMessage({
		type = 'ON_SUGGESTION_REMOVE',
		name = name
	})
end)

RegisterNetEvent('chat:addTemplate', function(id, html)
    SendNUIMessage({
        type = 'ON_TEMPLATE_ADD',
        template = {
            id = id,
            html = html
        }
    })
end)

RegisterNetEvent('chat:clear', function(name)
    SendNUIMessage({
        type = 'ON_CLEAR'
    })
end)

RegisterNUICallback('chatResult', function(data, cb)
    chatInputActive = false
    SetNuiFocus(false, false)

    if not data.canceled then
        local id = PlayerId()

        local r, g, b = 0, 0x99, 255

        if data.message:sub(1, 1) == '/' then
            ExecuteCommand(data.message:sub(2))
        else
            TriggerServerEvent('_chat:messageEntered', GetPlayerName(id), { r, g, b }, data.message)
        end
    end

    cb('ok')
end)

local function refreshCommands()
    if GetRegisteredCommands then
        local registeredCommands = GetRegisteredCommands()

        local suggestions = {}

        for _, command in ipairs(registeredCommands) do
            if IsAceAllowed(('command.%s'):format(command.name)) then
                table.insert(suggestions, {
                    name = '/' .. command.name,
                    help = ''
                })
            end
        end

        TriggerEvent('chat:addSuggestions', suggestions)
    end
end

local function refreshThemes()
    local themes = {}

    for resIdx = 0, GetNumResources() - 1 do
        local resource = GetResourceByFindIndex(resIdx)

        if GetResourceState(resource) == 'started' then
            local numThemes = GetNumResourceMetadata(resource, 'chat_theme')

            if numThemes > 0 then
                local themeName = GetResourceMetadata(resource, 'chat_theme')
                local themeData = json.decode(GetResourceMetadata(resource, 'chat_theme_extra') or 'null')

                if themeName and themeData then
                    themeData.baseUrl = 'nui://' .. resource .. '/'
                    themes[themeName] = themeData
                end
            end
        end
    end

    SendNUIMessage({
        type = 'ON_UPDATE_THEMES',
        themes = themes
    })
end

AddEventHandler('onClientResourceStart', function(resName)
    Wait(500)

    refreshCommands()
    refreshThemes()
end)

AddEventHandler('onClientResourceStop', function(resName)
  Wait(500)

    refreshCommands()
    refreshThemes()
end)

RegisterNUICallback('loaded', function(data, cb)
    TriggerServerEvent('chat:init');

    refreshCommands()
    refreshThemes()

    chatLoaded = true

    cb('ok')
end)

Citizen.CreateThread(function()
    SetTextChatEnabled(false)
    SetNuiFocus(false, false)

    while true do
        Wait(3)

        if not chatInputActive then
            if IsControlPressed(0, 245) --[[ INPUT_MP_TEXT_CHAT_ALL ]] then
                chatInputActive = true
                chatInputActivating = true

                SendNUIMessage({
                    type = 'ON_OPEN'
                })
            end
        end

        if chatInputActivating then
            if not IsControlPressed(0, 245) then
                SetNuiFocus(true)

                chatInputActivating = false
            end
        end

        if chatLoaded then
            local shouldBeHidden = false

            if IsScreenFadedOut() or IsPauseMenuActive() then
                shouldBeHidden = true
            end

            if (shouldBeHidden and not chatHidden) or (not shouldBeHidden and chatHidden) then
                chatHidden = shouldBeHidden

                SendNUIMessage({
                    type = 'ON_SCREEN_STATE_CHANGE',
                    shouldHide = shouldBeHidden
                })
            end
        end
    end
end)

RegisterNetEvent('chatTypedMessage', function(title, type, text)
    local colorClass = "text-white"

    if type == "success" then
        colorClass = "text-green-400"
    elseif type == "error" then
        colorClass = "text-red-400"
    elseif type == "devmode" then
        colorClass = "text-purple-400"
    elseif type == "admin" then
        colorClass = "text-blue-400"
    end

    local template = [[
        <div class="w-full break-words mb-1 text-sm font-normal">
            <strong class="]]..colorClass..[[ uppercase">{0}:</strong> {1}
        </div>
    ]]

    SendNUIMessage({
        type = 'ON_MESSAGE',
        message = {
            template = template,
            args = {title, text}
        }
    })
end)

RegisterCommand('testsuccess', function()
    TriggerEvent('chatTypedMessage', 'SYSTEM', 'success', 'See on success tüüpi sõnum!')
end)

RegisterCommand('testerror', function()
    TriggerEvent('chatTypedMessage', 'SYSTEM', 'error', 'See on error tüüpi sõnum!')
end)

RegisterCommand('testdevmode', function()
    TriggerEvent('chatTypedMessage', 'SYSTEM', 'devmode', 'See on devmode tüüpi sõnum!')
end)

RegisterCommand('testadmin', function()
    TriggerEvent('chatTypedMessage', 'SYSTEM', 'admin', 'See on admin tüüpi sõnum!')
end)
