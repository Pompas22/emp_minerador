-- EMPREGO DE MINERADOR DESENVOLVIDO PELA DEV2UP, EM CASO DE PROBLEMA OU BUGS ENTRAR EM CONTATO CONOSCO PELO DISCORD: https://discord.gg/KWxsjNvJRK --
-- EMPREGO DE MINERADOR DESENVOLVIDO PELA DEV2UP, EM CASO DE PROBLEMA OU BUGS ENTRAR EM CONTATO CONOSCO PELO DISCORD: https://discord.gg/KWxsjNvJRK --
-- EMPREGO DE MINERADOR DESENVOLVIDO PELA DEV2UP, EM CASO DE PROBLEMA OU BUGS ENTRAR EM CONTATO CONOSCO PELO DISCORD: https://discord.gg/KWxsjNvJRK --
-- EMPREGO DE MINERADOR DESENVOLVIDO PELA DEV2UP, EM CASO DE PROBLEMA OU BUGS ENTRAR EM CONTATO CONOSCO PELO DISCORD: https://discord.gg/KWxsjNvJRK --
-- EMPREGO DE MINERADOR DESENVOLVIDO PELA DEV2UP, EM CASO DE PROBLEMA OU BUGS ENTRAR EM CONTATO CONOSCO PELO DISCORD: https://discord.gg/KWxsjNvJRK --

local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPclient = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")

RegisterNetEvent('giveitem')
AddEventHandler('giveitem', function()
    local source = source
    local user_id = vRP.getUserId(source)
    local quantidade = math.random(5, 10)
    local item = math.random(#itens)
    if user_id then
        if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(itens[item])*quantidade <= vRP.getInventoryMaxWeight(user_id) then
            vRP.giveInventoryItem(user_id, itens[item], quantidade)
            vRPclient._playAnim(source,true,{{"pickup_object","pickup_low"}},false)
        end
    end
end)