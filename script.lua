-- ============================================
-- FEATURES MODULE - Pickaxe Simulator
-- Untuk diintegrasikan dengan SynceScriptHub
-- ============================================

local Features = {}

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerStatsFolder = nil
local settingsFolder = nil

-- Initialize
task.spawn(function()
    local stats = ReplicatedStorage:WaitForChild("Stats", 10)
    if not stats then return end
    playerStatsFolder = stats:WaitForChild(player.Name, 10)
    if not playerStatsFolder then return end
    settingsFolder = playerStatsFolder:WaitForChild("Settings", 10)
end)

-- ============================================
-- MINING SPEED
-- ============================================
function Features.SetMiningSpeed(value)
    if value < 1 or value > 9 then return false, "Value must be 1-9" end
    local boost = ReplicatedStorage.Stats:FindFirstChild(player.Name)
    if boost then
        boost = boost:FindFirstChild("MiningSpeedBoost")
        if boost and boost:IsA("NumberValue") then
            boost.Value = value
            return true, "Mining Speed set to " .. value .. "x"
        end
    end
    return false, "Failed to set mining speed"
end

-- ============================================
-- AUTO REBIRTH
-- ============================================
function Features.SetAutoRebirth(enabled)
    if settingsFolder then
        local setting = settingsFolder:FindFirstChild("AutoRebirth")
        if setting and setting:IsA("BoolValue") then
            setting.Value = enabled
            return true
        end
    end
    return false
end

-- ============================================
-- AUTO TRAIN
-- ============================================
function Features.SetAutoTrain(enabled)
    if settingsFolder then
        local setting = settingsFolder:FindFirstChild("AutoTrain")
        if setting and setting:IsA("BoolValue") then
            setting.Value = enabled
            return true
        end
    end
    return false
end

-- ============================================
-- EGG HATCH SPEED
-- ============================================
function Features.SetEggHatchSpeed(enabled)
    local eggStats = ReplicatedStorage.Stats:FindFirstChild(player.Name)
    if eggStats then
        eggStats = eggStats:FindFirstChild("EggStats")
        if eggStats then
            local stat = eggStats:FindFirstChild("HatchSpeed")
            if stat and stat:IsA("NumberValue") then
                stat.Value = enabled and 7 or 1
                return true
            end
        end
    end
    return false
end

-- ============================================
-- PREMIUM
-- ============================================
function Features.SetPremium(enabled)
    task.spawn(function()
        local analytics = ReplicatedStorage.Stats:WaitForChild(player.Name):WaitForChild("Analytics")
        local isPremium = analytics:WaitForChild("IsPremium")
        if isPremium and isPremium:IsA("BoolValue") then
            isPremium.Value = enabled
        end
    end)
    return true
end

-- ============================================
-- IN GROUP (Claim Group Chest)
-- ============================================
function Features.SetInGroup(enabled)
    task.spawn(function()
        local analytics = ReplicatedStorage.Stats:WaitForChild(player.Name):WaitForChild("Analytics")
        local isInGroup = analytics:WaitForChild("IsInGroup")
        if isInGroup and isInGroup:IsA("BoolValue") then
            isInGroup.Value = enabled
        end
    end)
    return true
end

-- ============================================
-- AUTO REWARD EGG
-- ============================================
local autoRewardEnabled = false
local autoRewardLoop = nil

function Features.SetAutoRewardEgg(enabled)
    autoRewardEnabled = enabled
    if enabled and not autoRewardLoop then
        autoRewardLoop = task.spawn(function()
            while autoRewardEnabled do
                task.wait(0.25)
                local menus = player.PlayerGui:FindFirstChild("Menus")
                if menus then
                    local rewardUI = menus:FindFirstChild("Reward")
                    if rewardUI then
                        local main = rewardUI.Frame.Main
                        local available = main.Claim.Main:FindFirstChild("Available")
                        if available and available.Visible == true then
                            pcall(function() main.Claim:Activate() end)
                        end
                    end
                end
            end
            autoRewardLoop = nil
        end)
    end
    return true
end

-- ============================================
-- INFINITE JUMP
-- ============================================
local infiniteJumpEnabled = false
local jumpConnection = nil

function Features.SetInfiniteJump(enabled)
    infiniteJumpEnabled = enabled
    if enabled then
        if not jumpConnection then
            jumpConnection = UserInputService.JumpRequest:Connect(function()
                if infiniteJumpEnabled then
                    local char = player.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
                    end
                end
            end)
        end
    else
        if jumpConnection then
            jumpConnection:Disconnect()
            jumpConnection = nil
        end
    end
    return true
end

-- ============================================
-- WALKSPEED
-- ============================================
function Features.SetWalkSpeed(value)
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = value
            return true
        end
    end
    return false
end

-- ============================================
-- JUMP POWER
-- ============================================
function Features.SetJumpPower(value)
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.JumpPower = value
            return true
        end
    end
    return false
end

return Features
