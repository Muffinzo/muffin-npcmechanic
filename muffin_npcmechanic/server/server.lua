local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("muffin:server:payup")
AddEventHandler("muffin:server:payup", function(vehicleNetId)
    local src = source
    if not QBCore then
        print("❌ QBCore is not loaded yet!")
        return
    end

    local Player = QBCore.Functions.GetPlayer(src)

    if not vehicleNetId or vehicleNetId == 0 then
        print("❌ Invalid vehicleNetId received from player:", src)
        return
    end

    if Player and Player.PlayerData.money.cash >= Config.fee then
        Player.Functions.RemoveMoney("cash", Config.fee, "Mechanic")
        QBCore.Functions.Notify(src, "You´ve paid the mechanic", "success", 5000)

        print("✅ Sending repair event to client:", src, "Vehicle NetID:", vehicleNetId)
        TriggerClientEvent("muffin:client:fixnime", src, vehicleNetId)
    else 
        QBCore.Functions.Notify(src, "❌ You don´t have enough money! ", "error")
    end
end)
