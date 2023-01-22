local QBCore = exports['qb-core']:GetCoreObject()

local function constructGradesTable(data)
    local retval = {}
    for k, v in pairs(data) do
        if k ~= 'bossgrade' then
            local gradeIndex = QBCore.Shared.SplitStr(k, '_')

            if not retval[tostring(gradeIndex[1])] then retval[tostring(gradeIndex[1])] = {} end
            if gradeIndex[2] == 'name' then
                retval[tostring(gradeIndex[1])].name = v
            elseif gradeIndex[2] == 'payment' then
                retval[tostring(gradeIndex[1])].payment = v
            end
        end
    end
    return retval
end

local function saveJobToConfig(dataTable, gradesTable)
    local path = GetResourcePath('qb-core'):gsub('//', '/') .. '/shared/jobs.lua'
    local file = io.open(path, 'a+')

    file:write(
        "\nQBShared.Jobs['" .. dataTable.name .. "'] = {",
        "label = '" .. dataTable.label .. "',",
        "defaultDuty = " .. dataTable.defaultduty .. ",",
        "offDutyPay = " .. dataTable.offdutypay .. ","
    )

    file:write("grades = {")
    for k, v in pairs(gradesTable) do
        if string.lower(dataTable.grades.bossgrade) == string.lower(v.name) then
            file:write("['" .. k .. "'] = { name = '" .. v.name .. "', payment = " .. v.payment .. ", isboss = true},")
        else
            file:write("['" .. k .. "'] = { name = '" .. v.name .. "', payment = " .. v.payment .. "},")
        end
    end
    file:write("}")

    if dataTable.isleo then file:write(",type = 'leo'") end
    file:write("}")
    file:close()
end

RegisterNetEvent('boppe-creator:server:job:completeSetup', function(dataTable)
    local src = source
    local gradesTable = constructGradesTable(dataTable.grades)
    local newJobTable = {
        label = dataTable.label,
        defaultDuty = dataTable.defaultduty,
        offDutyPay = dataTable.offdutypay,
        grades = gradesTable
    }
    if dataTable.isleo then newJobTable.type = 'leo' end
    exports['qb-core']:AddJob(dataTable.name, newJobTable)
    saveJobToConfig(dataTable, gradesTable)
    TriggerClientEvent('QBCore:Notify', src, 'Job ' .. dataTable.name .. ' created!', 'info')
end)
