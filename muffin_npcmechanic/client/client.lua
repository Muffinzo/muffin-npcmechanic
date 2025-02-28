local QBCore = exports['qb-core']:GetCoreObject()

local function SpawnRepairPed()
    local pedData = Config.Locations["PedInteractionPoint"]
    if not pedData or not pedData.PedModel or not pedData.coords then
        print("❌ Error: Invalid ped data in config.lua!")
        return
    end

    local x, y, z, h = table.unpack(pedData.coords)
    local Vec3 = vector3(x, y, z - 1.0)
    local model = pedData.PedModel

    RequestModel(model)
    local timeout = 5000 -- Wait up to 5 seconds for model to load
    while not HasModelLoaded(model) and timeout > 0 do 
        Wait(100)
        timeout = timeout - 100
    end

    if not HasModelLoaded(model) then
        print("❌ Error: Ped model failed to load:", model)
        return
    end

    local ped = CreatePed(4, model, x, y, z - 1.0, h, false, false)
    SetEntityAsMissionEntity(ped, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)

    exports["qb-target"]:AddBoxZone("PedInteractionPoint", Vec3, 2, 2,
    { name = "PedInteractionPoint", heading = h, debugPoly = false, minZ = z - 1.0, maxZ = z + 1.0 },
    { options = Config.Options, distance = 5.0 })

    print("✅ Ped spawned successfully at:", x, y, z)
end

-- Ensure ped is spawned when player loads in
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    SpawnRepairPed()
end)

-- Ensure ped is spawned when resource starts
CreateThread(function()
    Wait(1000) -- Delay to ensure everything loads properly
    SpawnRepairPed()
end)

RegisterNetEvent("muffin:client:fixnime")
AddEventHandler("muffin:client:fixnime", function(vehicleNetId)
    print("🔧 Repair event received. NetID:", vehicleNetId)

    if vehicleNetId and vehicleNetId ~= 0 then
        local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)

        if DoesEntityExist(vehicle) then
            print("✅ Vehicle found! Repairing...")

            SetVehicleFixed(vehicle)
            SetVehicleDeformationFixed(vehicle)
            SetVehicleUndriveable(vehicle, false)
            SetVehicleEngineOn(vehicle, true, true)

            QBCore.Functions.Notify("🚗 Car Fixed!", "success", 5000)
        else
            print("❌ Vehicle not found with NetID:", vehicleNetId)
        end
    else
        print("❌ Invalid vehicleNetId received!")
    end
end)

RegisterNetEvent("muffin:client:startRepair")
AddEventHandler("muffin:client:startRepair", function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle and vehicle ~= 0 then
        local vehicleNetId = VehToNet(vehicle)
        
        if NetworkDoesNetworkIdExist(vehicleNetId) then
            print("🔧 Sending repair request for NetID:", vehicleNetId)
            TriggerServerEvent("muffin:server:payup", vehicleNetId)
        else
            QBCore.Functions.Notify("❌ Error: Vehicle NetID doesn´t exist!", "error")
        end
    else
        QBCore.Functions.Notify("❌ You´re not in a vehicle", "error")
    end
end)


