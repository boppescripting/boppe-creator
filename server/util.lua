local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('boppe-creator:server:hasPermission', function(source, cb)
    cb(QBCore.Functions.HasPermission(source, Config.PermissionLevel))
end)