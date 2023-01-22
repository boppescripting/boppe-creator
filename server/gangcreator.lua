local QBCore = exports['qb-core']:GetCoreObject()

local function constructGradesTable(data)
    local retval = {}
    for k, v in pairs(data) do
        if k ~= 'bossgrade' then
            local gradeIndex = QBCore.Shared.SplitStr(k, '_')

            if not retval[tostring(gradeIndex[1])] then retval[tostring(gradeIndex[1])] = {} end
            retval[tostring(gradeIndex[1])].name = v
        end
    end
    return retval
end

local function saveGangToConfig(dataTable, gradesTable)
    local path = GetResourcePath('qb-core'):gsub('//', '/') .. '/shared/gangs.lua'
    local file = io.open(path, 'a+')

    file:write(
        "\nQBShared.Gangs['" .. dataTable.name .. "'] = {",
        "label = '" .. dataTable.label .. "',"
    )

    file:write("grades = {")
    for k, v in pairs(gradesTable) do
        if string.lower(dataTable.grades.bossgrade) == string.lower(v.name) then
            file:write("['" .. k .. "'] = { name = '" .. v.name .. "', isboss = true},")
        else
            file:write("['" .. k .. "'] = { name = '" .. v.name .. "'},")
        end
    end
    file:write("}}")
    file:close()
end

RegisterNetEvent('boppe-creator:server:gang:completeSetup', function(dataTable)
    local src = source
    local gradesTable = constructGradesTable(dataTable.grades)
    QBCore.Functions.AddGang(dataTable.name, {
        label = dataTable.label,
        grades = gradesTable
    })
    saveGangToConfig(dataTable, gradesTable)
    TriggerClientEvent('QBCore:Notify', src, 'Gang ' .. dataTable.name .. ' created!', 'info')
end)
