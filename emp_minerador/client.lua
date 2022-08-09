-- EMPREGO DE MINERADOR DESENVOLVIDO PELA DEV2UP, EM CASO DE PROBLEMA OU BUGS ENTRAR EM CONTATO CONOSCO PELO DISCORD: https://discord.gg/KWxsjNvJRK --
-- EMPREGO DE MINERADOR DESENVOLVIDO PELA DEV2UP, EM CASO DE PROBLEMA OU BUGS ENTRAR EM CONTATO CONOSCO PELO DISCORD: https://discord.gg/KWxsjNvJRK --
-- EMPREGO DE MINERADOR DESENVOLVIDO PELA DEV2UP, EM CASO DE PROBLEMA OU BUGS ENTRAR EM CONTATO CONOSCO PELO DISCORD: https://discord.gg/KWxsjNvJRK --
-- EMPREGO DE MINERADOR DESENVOLVIDO PELA DEV2UP, EM CASO DE PROBLEMA OU BUGS ENTRAR EM CONTATO CONOSCO PELO DISCORD: https://discord.gg/KWxsjNvJRK --
-- EMPREGO DE MINERADOR DESENVOLVIDO PELA DEV2UP, EM CASO DE PROBLEMA OU BUGS ENTRAR EM CONTATO CONOSCO PELO DISCORD: https://discord.gg/KWxsjNvJRK --




local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")


local inService = false
local withTool = false
local selected = nil
local positionc4 = false
local dropitem = false

CreateThread(function()
    FreezeEntityPosition(PlayerPedId(),false)
    TriggerEvent("cancelando",false)
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local pedcds = GetEntityCoords(ped)
        if not inService and not withTool then
            local distance = #(pedcds - coords)
            if distance <= 5 then
                sleep = 4
                DrawMarker(2, coords[1],coords[2],coords[3], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 41, 197, 1, 110, 0, 1, 0, 1)
                if IsControlJustPressed(0, 38) then
                    inService = true
                    TriggerEvent("Notify", "sucesso", "Você entrou em serviço.", 5000)
                end
            end
        elseif inService and not withTool then
            local distance = #(pedcds - tool)
            if distance <= 5 then
                sleep = 4
                DrawMarker(2, tool[1],tool[2],tool[3], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 41, 197, 1, 110, 0, 1, 0, 1)
                if IsControlJustPressed(0, 38) then
                    withTool = true
                    Citizen.Wait(10)
                    DoScreenFadeOut(1000)
                    SetPedComponentVariation(ped,5,44,0,0)
                    Citizen.Wait(2000)
                    DoScreenFadeIn(500)
                    selected = math.random(#mineirar)
                    SetNewWaypoint(-596.82, 2091.22)
                    TriggerEvent("Notify", "sucesso", "Você coletou a ferramenta de trabalho e o local foi marcado em seu GPS.", 5000)        
                end
            end
        elseif inService and withTool then
            local distance = #(pedcds - vector3(mineirar[selected]['coords'][1],mineirar[selected]['coords'][2],mineirar[selected]['coords'][3]))
            if distance <= 5 and not positionc4 and not dropitem then
                sleep = 4
                DrawMarker(2, mineirar[selected]['coords'][1],mineirar[selected]['coords'][2],mineirar[selected]['coords'][3], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 41, 197, 1, 110, 0, 1, 0, 1)
                drawTxt('PRESSIONE ~y~E~w~ PARA ~y~PLANTAR~w~ A C4',4,0.50,0.95,0.50,255,255,255,180)
                if IsControlJustPressed(0, 38) then 
                    TriggerEvent("cancelando",true)
                    SetEntityHeading(PlayerPedId(),mineirar[selected]['coords'][4])
                    vRP._playAnim(true,{{"missfbi_s4mop","plant_bomb_b"}},false)
                    vRP._CarregarObjeto("missfbi_s4mop","plant_bomb_b","prop_c4_final_green",50,28422)
                    FreezeEntityPosition(ped, true)
                    SetEntityCoords(PlayerPedId(),mineirar[selected]['coords'][1],mineirar[selected]['coords'][2],mineirar[selected]['coords'][3] - 1,1,0,0,0)
                    TriggerEvent("Progress",10000)
                    Citizen.Wait(5000)
                    vRP._DeletarObjeto()
                    vRP.removeObjects()
                    TriggerEvent("cancelando",false)
                    FreezeEntityPosition(ped, false)
                    ClearPedTasks(ped)

                    local mHash = GetHashKey("prop_c4_final_green")

                    RequestModel(mHash)
                    while not HasModelLoaded(mHash) do
                        RequestModel(mHash)
                        Citizen.Wait(10)
                    end

                    objectBomb = CreateObjectNoOffset(mHash,mineirar[selected]['coordsc4'][1],mineirar[selected]['coordsc4'][2],mineirar[selected]['coordsc4'][3]-0.23,true,false,false)
                    SetEntityAsMissionEntity(objectBomb,true,true)
                    FreezeEntityPosition(objectBomb,true)
                    SetEntityHeading(objectBomb,mineirar[selected]['coordsc4'][4])
                    SetModelAsNoLongerNeeded(mHash)   
                    positionc4 = true 
                end
            end
        end
        if positionc4 then
            sleep = 4
            local distance = #(GetEntityCoords(PlayerPedId()) - vector3(mineirar[selected]['coords'][1],mineirar[selected]['coords'][2],mineirar[selected]['coords'][3]))
            if distance > 5 then
                drawTxt('PRESSIONE ~y~E~w~ PARA ~y~DETONAR~w~ A C4',4,0.50,0.95,0.50,255,255,255,180)
                if IsControlJustPressed(0, 38) then
                    vRP._playAnim(true,{{"anim@mp_player_intmenu@key_fob@","fob_click"}},false)
                    ClearPedTasks(ped)
                    Wait(800)
                    AddExplosion(mineirar[selected]['coords'][1],mineirar[selected]['coords'][2],mineirar[selected]['coords'][3],2,100.0,true,false,true)
                    DeleteEntity(objectBomb)
                    positionc4 = false
                    dropitem = true
                end
            end
        end
        if dropitem then
            sleep = 4
            local distance = #(GetEntityCoords(PlayerPedId()) - vector3(mineirar[selected]['coords'][1],mineirar[selected]['coords'][2],mineirar[selected]['coords'][3]))
            DrawMarker(21, mineirar[selected]['coords'][1],mineirar[selected]['coords'][2],mineirar[selected]['coords'][3]-0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 0, 110, 0, 1, 0, 1)
            if IsControlJustPressed(0, 38) and distance <= 1.2 then
                TriggerServerEvent('giveitem')
                selected = math.random(#mineirar)
                dropitem = false
            end
        end
        if inService then
            sleep = 4
            if IsControlJustPressed(0, 168) then
                selected = nil
                dropitem = false
                positionc4 = false
                inService = false
                withTool = false
                SetPedComponentVariation(ped,5,0,0,0)
            end
        end
        Wait(sleep)
    end
end)

AddEventHandler('onClientResourceStart', function (resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
      return
    end
    TriggerEvent("minerador:blip")
end)

function drawTxt(text,font,x,y,scale,r,g,b,a)
    SetTextFont(font)
    SetTextScale(scale,scale)
    SetTextColour(r,g,b,a)
    SetTextOutline()
    SetTextCentre(1)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x,y)
end

---BLIPS-----------------------------------------------------------------------

RegisterNetEvent("minerador:blip")
AddEventHandler("minerador:blip", function()
    if not DoesBlipExist(blips) then
        AddBlip(coords[1],coords[2],coords[3])
    end
end)

function AddBlip(x,y,z)
    blips = AddBlipForCoord(x,y,z)
    SetBlipSprite(blips,618)
    SetBlipColour(blips,0)
    SetBlipScale(blips,0.6)
    SetBlipAsShortRange(blips,true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Emprego de Minerador")
    EndTextCommandSetBlipName(blips)
end