ESX = exports["es_extended"]:getSharedObject()
local PlayerData                = {}

local display                   = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RequestIpl("facelobby")

RegisterNUICallback("exit", function(data)
    TriggerEvent('esx:showAdvancedNotification', "Lifeinvader", Config.Servername, Config.Message, Config.LifeinvaderLogo, 2)
    SetDisplay(false)
end)

RegisterNUICallback("main", function(data)
    TriggerServerEvent("dm_lifeinvader:sendtoall", data.text)
    SetDisplay(false)
end)

RegisterNUICallback("error", function(data)
    SetDisplay(false)
end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

RegisterCommand('testinvaderorsomething', function()
    SetDisplay(true)
end, true)

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(1)    
    --SetPedConfigFlag(PlayerPedId(), 438, true)

	local ped = PlayerPedId()
        if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.MarkerPoint.Pos.x, Config.MarkerPoint.Pos.y, Config.MarkerPoint.Pos.z, true) < 2 then
            ESX.ShowHelpNotification("~w~Drücke ~INPUT_CONTEXT~ um eine Werbung zu schalten")

            if IsControlJustReleased(1, 51) then
                SetDisplay(not display)
            end
        end
    end
 end)

Citizen.CreateThread(function()
    local hash = GetHashKey(Config.PED)

    if not HasModelLoaded(hash) then
        RequestModel(hash)
        Citizen.Wait(100)
    end

    while not HasModelLoaded(hash) do
        Citizen.Wait(0)
    end

    local npc = CreatePed(6, hash, Config.PedSpawnPoint.Pos.x, Config.PedSpawnPoint.Pos.y, Config.PedSpawnPoint.Pos.z, Config.PedSpawnPoint.Pos.alpha, false, false)

    SetEntityInvincible(npc, true)
    FreezeEntityPosition(npc, true)
    SetPedDiesWhenInjured(npc, false)
    SetPedCanRagdollFromPlayerImpact(npc, false)
    SetPedCanRagdoll(npc, false)
    SetEntityAsMissionEntity(npc, true, true)
    SetEntityDynamic(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)

    blip = AddBlipForCoord(Config.PedSpawnPoint.Pos.x, Config.PedSpawnPoint.Pos.y, Config.PedSpawnPoint.Pos.z)
    SetBlipSprite(blip, Config.Blip)
    SetBlipDisplay(blip, 3)
    SetBlipScale(blip, Config.BlipGroesse)
    SetBlipColour(blip, Config.BlipColor)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.BlipName)
    EndTextCommandSetBlipName(blip)
end)