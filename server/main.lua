local QBCore = exports['qb-core']:GetCoreObject()

local function constructGradesTable(data)
    local retval = {}
    for k, v in pairs(data) do
        local gradeIndex = QBCore.Shared.SplitStr(k, '_')

        if not retval[tostring(gradeIndex[1])] then retval[tostring(gradeIndex[1])] = {} end
        if gradeIndex[2] == 'name' then
            retval[tostring(gradeIndex[1])].name = v
        elseif gradeIndex[2] == 'payment' then
            retval[tostring(gradeIndex[1])].payment = v
        end
    end
    return retval
end

local function saveJobToConfig(dataTable, gradesTable)
    local path = GetResourcePath(GetCurrentResourceName()):gsub('//', '/') .. '/server/config.lua'
    local file = io.open(path, 'a+')

    file:write(
        "\nConfig.CreatedJobs['" .. dataTable.name .. "'] = {",
        "label = '" .. dataTable.label .. "',",
        "defaultDuty = " .. dataTable.defaultduty .. ",",
        "offdutypay = " .. dataTable.offdutypay .. ","
    )

    for k,v in pairs(gradesTable) do
        if k == '0' then
            file:write("grades = {")
        end
        file:write("['" .. k .. "'] = { name = '" .. v.name .. "', payment = " .. v.payment .. "},")
    end
    file:write("}")

    if dataTable.isleo then file:write(",type = 'leo'") end
    file:write("}")
    file:close()
end

RegisterNetEvent('boppe-jobcreator:server:completeSetup', function(dataTable)
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

local function loadExistingJobs()
    for k, v in pairs(Config.CreatedJobs) do
        local jobTable = {
            label = v.label,
            defaultDuty = v.defaultDuty,
            offDutyPay = v.offdutypay,
            grades = v.grades
        }
        if v.isleo then jobTable.type = 'leo' end
        exports['qb-core']:AddJob(k, jobTable)
    end
end

loadExistingJobs()

QBCore.Functions.CreateCallback('boppe-jobcreator:server:hasPermission', function(source, cb)
    cb(QBCore.Functions.HasPermission(source, Config.PermissionLevel))
end)
