-- Script Floppa Hub Premium --
if not LPH_OBFUSCATED then
    LPH_JIT_MAX = function(...) return(...) end;
    LPH_NO_VIRTUALIZE = function(...) return(...) end;
end
LPH_NO_VIRTUALIZE(function()
    repeat task.wait(); until game:IsLoaded();
    repeat task.wait(); until game.Players
    repeat task.wait(); until game.Players.LocalPlayer
    repeat task.wait(); until game.Players.LocalPlayer.Character
    repeat task.wait(); until game.Players.LocalPlayer:FindFirstChild('Loaded')
end)()

repeat
    wait()
until game:IsLoaded()
wait()

for _, v in pairs(getgc(true)) do
    if pcall(function() return rawget(v, "indexInstance") end) and type(rawget(v, "indexInstance")) == "table" and (rawget(v, "indexInstance"))[1] == "kick" then
        v.tvk = { "kick", function() return game.Workspace:WaitForChild("") end }
    end
end

for _, v in next, getgc() do
    if typeof(v) == "function" and islclosure(v) and not isexecutorclosure(v) then
        local Constants = debug.getconstants(v)
        if table.find(Constants, "Detected") and table.find(Constants, "crash") then
            setthreadidentity(2)
            hookfunction(v, function()
                return task.wait(9e9)
            end)
            setthreadidentity(7)
        end
    end
end
local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/UnknowsitoTheBerst/unknow/main/libraryFloppa.lua'))()
local httpService = game:GetService('HttpService')
local Window = Library:CreateWindow({
    Title = 'Floppa Hub | Table AutoDrop Item ',
    Center = true,
    AutoShow = true,
})


local Tabs = {
    Dupe = Window:AddTab('Dupe/Rollback'),
    
}

task.spawn(LPH_JIT_MAX(function()
    while task.wait() do
        if Toggles.DupeRollback.Value then
            ReplicatedStorage.Remotes.Data.UpdateHotbar:FireServer({[1] = "\255"})
        end
    end
end))
print("hello")

local Dupees = Tabs.Dupe:AddLeftGroupbox('Rollback')
local Rejoins = Tabs.Dupe:AddRightGroupbox('Rejoin')
Rejoins:AddButton('      Rejoin Server       ', function()
    game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId)
end)

Dupees:AddToggle('DupeRollback', {Text = 'Stop Saving Data',Default = false, Tooltip = "Stop saving data (meaning your data wont be saved when this is toggled)" })
Dupees:AddLabel('Guide on how to dupe:\n\n1.) Turn on "Stop Saving Data"\n\n2.) Drop your items to someone\n(you have a short time window to do this or else the rollback may not work..)\n\n3.) Have the account pick it up\n\n4.) Click rejoin server\n\nWait a bit after toggling off to save data.', true)

    local function GetUniqueToolNames()
    local uniqueToolNames = {}
    
    local toolsFolder = Player.Backpack:FindFirstChild("Tools")

    for _, tool in ipairs(toolsFolder:GetChildren()) do
        if not table.find(uniqueToolNames, tool.Name) then
            table.insert(uniqueToolNames, tool.Name)
        end
    end

    return uniqueToolNames
end

local Drop = Tabs.Dupe:AddRightGroupbox('Auto Drop')
Drop:AddToggle('AutoDrop', {Text = 'Auto Drop Item', Default = false, Tooltip = "Automatically drops selected item from your inventory."})

local dropdd = Drop:AddDropdown('DropItem', {Values = GetUniqueToolNames(), Multi = false, AllowNull = true, Text = 'Select Item to Drop'})

Drop:AddButton('Refresh Item List', function()
    dropdd:SetValues(GetUniqueToolNames())
end)
task.spawn(LPH_JIT_MAX(function()
    while task.wait() do
        if Toggles.AutoDrop.Value then
            ReplicatedStorage.Remotes.Information.InventoryManage:FireServer("Drop", Options.DropItem.Value)
        end
    end
end))
