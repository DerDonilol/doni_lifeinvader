ESX = exports["es_extended"]:getSharedObject()

local cooldown = false

function sendToDiscord(source, text)
    PerformHttpRequest(Config.Webhookurl, function(err, text, headers)

        end, 'POST', json.encode({
            embeds = {
                {
                    ["description"] = "Autor: **" .. source .."**\nWerbetext: ``"..text.."``",
                    ["color"] = 16711680,
                    ["author"] = {
                        ["name"] = "Lifeinvader",
                        ["icon_url"] = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4HDOiZl3FSuqh8e28OwEUyHp-tO-cEopGv8wmQoG5xvD8MF2c1O-Y139jfQ0clelZQkg"
                    },
                    ["footer"] = {
                        ["text"] = "Made by CLASSIC5",
                    },
                    ["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%S')
                }
            }
        }), {
            ['Content-Type'] = 'application/json'
        }
    )
end

RegisterServerEvent('dm_lifeinvader:sendtoall')
AddEventHandler('dm_lifeinvader:sendtoall', function(datatext)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local account = xPlayer.getMoney()

    local werbungspreis = Config.Werbungspreis

    if not cooldown then
        if xPlayer ~= nil then
            if not string.find(datatext, "<") and not string.find(datatext, ">") and not string.find(datatext, "@") and not string.find(datatext, "<!@") and not string.find(datatext, "<#") then
                if account > werbungspreis then
                    xPlayer.removeMoney(werbungspreis)
                    sendToDiscord(xPlayer.getName(), datatext)
                    if Config.GibtEsSperre == true then 
                        TriggerClientEvent('esx:showAdvancedNotification', -1, "Lifeinvader", "Warnung", Config.Sperre, Config.LifeinvaderLogo, 2) 
                    end
                    TriggerClientEvent('esx:showAdvancedNotification', -1, "Lifeinvader", "Werbung", "Neue Werbung: " .. datatext, Config.LifeinvaderLogo, 2)
                    if Config.GibtEsSperre == true then
                        cooldown = true
                        Citizen.Wait(Config.SperreZeit)
                        cooldown = false
                        TriggerClientEvent('esx:showAdvancedNotification', -1, "Lifeinvader", "Warnung", Config.SperreWeg, Config.LifeinvaderLogo, 2)
                    end
                else
                    TriggerClientEvent('esx:showAdvancedNotification', source, "Lifeinvader", "Warnung", Config.KeinGeld, Config.LifeinvaderLogo, 2)
                end
            else
                TriggerClientEvent('esx:showAdvancedNotification', source, "Lifeinvader", "Warnung", "Bitte vermeide es Personen oder Text-Kanäle in der Discord App zu pingen.", Config.LifeinvaderLogo, 2)
            end
        end
    else
        TriggerClientEvent('esx:showAdvancedNotification', source, "Lifeinvader", "Warnung", "Es wurde bereits eine Werbung geschaltet! Bitte versuche es bald erneut.", Config.LifeinvaderLogo, 2)
    end
end)