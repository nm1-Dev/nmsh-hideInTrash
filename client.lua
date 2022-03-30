local InTrash = false
local CanHide = true
local dumpsters = {
    "prop_dumpster_01a",
    "prop_dumpster_02a",
    "prop_dumpster_02b",
    "prop_dumpster_4a",
    "prop_dumpster_4b"
}

RegisterNetEvent('nmsh-hideInTrash:client:Hide', function()
    if CanHide then
        local playerPed = GetPlayerPed(-1)
        local pos = GetEntityCoords(playerPed)
        local dumpsterFound = false

        for i = 1, #dumpsters do
            local dumpster = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.0, dumpsters[i], false, false, false)
            local dumpsterPos = GetEntityCoords(dumpster)
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, dumpsterPos.x, dumpsterPos.y, dumpsterPos.z, true)
            if distance < 2.5 then
                if not InTrash then
                    if DoesEntityExist(dumpster) then
                        if not IsEntityAttached(ped) or GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(PlayerPedId()), true) >= 5.0 then
                            AttachEntityToEntity(PlayerPedId(), dumpster, -1, 0.0, -0.3, 2.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)	
                            loadDict('timetable@floyd@cryingonbed@base')
                            TaskPlayAnim(PlayerPedId(), 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
                            Wait(50)
                            SetEntityVisible(PlayerPedId(), false, false)
                            InTrash = true
                        else
                            TriggerEvent('chat:addMessage', {
                                color = { 255, 0, 0},
                                multiline = true,
                                args = {"SYSTEM", "هناك شخص مختبئ هنا بالفعل"}
                            })
                        end
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if CanHide and not InTrash then
            exports['qb-target']:AddTargetModel(dumpsters, {
                options = {
                    {
                        type = "client",
                        event = "nmsh-hideInTrash:client:Hide",
                        icon = "fas fa-dumpster",
                        label = "اختباء",
                    },
                },
                distance = 2.5,
            })
        end
    end
end)



--[[ Threads ]]--

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if InTrash then
            local Player = PlayerPedId()
            local dumpster = GetEntityAttachedTo(Player)
            local GetDumpsterPos = GetEntityCoords(dumpster)
            if DoesEntityExist(dumpster) or not IsPedDeadOrDying(Player) or not IsPedFatallyInjured(Player) then
                SetEntityCollision(Player, false, false)
                DrawText3Ds(GetDumpsterPos.x, GetDumpsterPos.y, GetDumpsterPos.z + 1.1, 'ﺔﻣﺎﻤﻘﻟﺍ ﺔﻳﻭﺎﺣ ﻦﻣ ﺝﻭﺮﺨﻠﻟ [~f~E~w~] ﻂﻐﺿﺍ')
                if not IsEntityPlayingAnim(PlayerPedId(), 'timetable@floyd@cryingonbed@base', 3) then
                    loadDict('timetable@floyd@cryingonbed@base')
                    TaskPlayAnim(PlayerPedId(), 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
                end
                if IsControlJustReleased(0, 38) and InTrash then
                    SetEntityCollision(PlayerPedId(), true, true)
                    InTrash = false
                    DetachEntity(PlayerPedId(), true, true)
                    SetEntityVisible(PlayerPedId(), true, false)
                    ClearPedTasks(PlayerPedId())
                    SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -0.7, -0.75))
                    Wait(250)
                end
            else
                SetEntityCollision(PlayerPedId(), true, true)
                DetachEntity(PlayerPedId(), true, true)
                SetEntityVisible(PlayerPedId(), true, false)
                ClearPedTasks(PlayerPedId())
                SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -0.7, -0.75))
            end
        end
    end
end)

--[[ Functions ]]--

loadDict = function(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
end

function DrawText3Ds(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local factor = #text / 460
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	
	SetTextScale(0.3, 0.3)
    RegisterFontFile('space')
    NmshFont = RegisterFontId('space')
    SetTextFont(NmshFont)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 160)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	DrawRect(_x,_y + 0.0115, 0.02 + factor, 0.027, 28, 28, 28, 95)
end