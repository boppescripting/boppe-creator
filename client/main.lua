local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('boppe-jobcreator:client:finishSetup', function(oldDialog)
    local amountOfGrades = tonumber(oldDialog.amtofgrades) - 1
    local menu = {
        header = "Setup continued...",
        submitText = "Complete Setup",
        inputs = {}
    }

    for i = 0, amountOfGrades, 1 do
        menu.inputs[#menu.inputs+1] = {
            text = "Grade (" .. i .. ") Name",
            name = i .. "_name",
            type = "text",
            isRequired = true,
        }

        menu.inputs[#menu.inputs+1] = {
            text = "Grade (" .. i .. ") Payment",
            name = i .. "_payment",
            type = "number",
            isRequired = true,
        }
    end

    local dialog = exports['qb-input']:ShowInput(menu)
    print(dialog)
    if dialog ~= nil then
        for k,v in pairs(dialog) do
            print(k .. " : " .. v)
        end

        local mergedTable = {}
        for k,v in pairs(oldDialog) do mergedTable[k] = v end
        mergedTable.grades = {}
        for k,v in pairs(dialog) do mergedTable.grades[k] = v end
        TriggerServerEvent('boppe-jobcreator:server:completeSetup', mergedTable)
    end
end)

RegisterCommand('createjob', function()
    local p = promise.new()
    QBCore.Functions.TriggerCallback('boppe-jobcreator:server:hasPermission', function(result) p:resolve(result) end)
    local hasPerm = Citizen.Await(p)
    if not hasPerm then QBCore.Function.Notify('test', 'error') return end

    local dialog = exports['qb-input']:ShowInput({
        header = "New Job",
        submitText = "Continue setup...",
        inputs = {
            {
                text = "Name",
                name = "name",
                type = "text",
                isRequired = true,
            },
            {
                text = "Label",
                name = "label",
                type = "text",
                isRequired = true,
            },
            {
                text = "Is LEO?",
                name = "isleo",
                type = "radio",
                options = {
                    { value = "true", text = "True" },
                    { value = "false", text = "False" },
                },
                default = "false",
            },
            {
                text = "Default Duty",
                name = "defaultduty",
                type = "radio",
                options = {
                    { value = "true", text = "True" },
                    { value = "false", text = "False" },
                },
                default = "true",
            },
            {
                text = "Off-Duty Pay",
                name = "offdutypay",
                type = "radio",
                options = {
                    { value = "true", text = "True" },
                    { value = "false", text = "False" },
                },
                default = "false",
            },
            {
                text = "Amount of Grades",
                name = "amtofgrades",
                type = "number",
                isRequired = false,
                default = 3,
            }
        },
    })

    if dialog then
        -- Check if job already exists
        if QBCore.Shared.Jobs[dialog.name] then QBCore.Functions.Notify('That job already exists.', 'error') return end
        TriggerEvent('boppe-jobcreator:client:finishSetup', dialog)
    end
end, false)