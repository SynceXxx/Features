local F={}
local P=game:GetService("Players").LocalPlayer
local RS=game:GetService("ReplicatedStorage")
local UIS=game:GetService("UserInputService")
local sF,stF=nil,nil
F.autoReward=false
F.infJump=false
F.jumpCon=nil

task.spawn(function()
    local s=RS:WaitForChild("Stats",10)
    if s then sF=s:WaitForChild(P.Name,10)
        if sF then stF=sF:WaitForChild("Settings",10)end
    end
end)

task.spawn(function()
    while true do task.wait(0.25)
        if F.autoReward then
            local m=P.PlayerGui:FindFirstChild("Menus")
            if m then local r=m:FindFirstChild("Reward")
                if r then local a=r.Frame.Main.Claim.Main:FindFirstChild("Available")
                    if a and a.Visible then pcall(function()r.Frame.Main.Claim:Activate()end)end
                end
            end
        end
    end
end)

function F.MiningSpeed(v)
    local b=RS.Stats:FindFirstChild(P.Name)
    if b then b=b:FindFirstChild("MiningSpeedBoost")
        if b and b:IsA("NumberValue")then b.Value=v end
    end
end

function F.AutoRebirth(v)
    if stF then local s=stF:FindFirstChild("AutoRebirth")
        if s and s:IsA("BoolValue")then s.Value=v end
    end
end

function F.AutoTrain(v)
    if stF then local s=stF:FindFirstChild("AutoTrain")
        if s and s:IsA("BoolValue")then s.Value=v end
    end
end

function F.EggHatch(v)
    local e=RS.Stats:FindFirstChild(P.Name)
    if e then e=e:FindFirstChild("EggStats")
        if e then local s=e:FindFirstChild("HatchSpeed")
            if s and s:IsA("NumberValue")then s.Value=v and 7 or 1 end
        end
    end
end

function F.Premium(v)
    task.spawn(function()
        local a=RS.Stats:WaitForChild(P.Name):WaitForChild("Analytics")
        local p=a:WaitForChild("IsPremium")
        if p and p:IsA("BoolValue")then p.Value=v end
    end)
end

function F.InGroup(v)
    task.spawn(function()
        local a=RS.Stats:WaitForChild(P.Name):WaitForChild("Analytics")
        local g=a:WaitForChild("IsInGroup")
        if g and g:IsA("BoolValue")then g.Value=v end
    end)
end

function F.AutoRewardEgg(v)F.autoReward=v end

function F.InfJump(v)
    F.infJump=v
    if v then
        if not F.jumpCon then
            F.jumpCon=UIS.JumpRequest:Connect(function()
                if F.infJump then
                    local c=P.Character
                    if c then local h=c:FindFirstChildOfClass("Humanoid")
                        if h then h:ChangeState(Enum.HumanoidStateType.Jumping)end
                    end
                end
            end)
        end
    else
        if F.jumpCon then F.jumpCon:Disconnect()F.jumpCon=nil end
    end
end

function F.WalkSpeed(v)
    local c=P.Character
    if c then local h=c:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed=v end
    end
end

function F.JumpPower(v)
    local c=P.Character
    if c then local h=c:FindFirstChildOfClass("Humanoid")
        if h then h.JumpPower=v end
    end
end

return F
