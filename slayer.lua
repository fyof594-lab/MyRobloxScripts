-- ============================================
-- 🐉 DRAGON SERVER SCRIPT 🐉
-- ضع هذا في ServerScriptService
-- ============================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local RemoteEvent = ReplicatedStorage:FindFirstChild("DragonServerCommand")

if not RemoteEvent then
    RemoteEvent = Instance.new("RemoteEvent")
    RemoteEvent.Name = "DragonServerCommand"
    RemoteEvent.Parent = ReplicatedStorage
end

RemoteEvent.OnServerEvent:Connect(function(player, command)
    print("📥 Received command:", command, "from", player.Name)
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local char = plr.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                local humanoid = char:FindFirstChild("Humanoid")
                
                if command == "FreezeAll" then
                    if humanoid then
                        humanoid.WalkSpeed = 0
                        humanoid.JumpPower = 0
                        humanoid.PlatformStand = true
                    end
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Anchored = true
                        end
                    end
                    
                elseif command == "UnfreezeAll" then
                    if humanoid then
                        humanoid.WalkSpeed = 16
                        humanoid.JumpPower = 50
                        humanoid.PlatformStand = false
                    end
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Anchored = false
                        end
                    end
                    
                elseif command == "SinkAll" then
                    if root then
                        root.CFrame = root.CFrame + Vector3.new(0, -50, 0)
                    end
                    
                elseif command == "FlyAll" then
                    if root then
                        local bv = Instance.new("BodyVelocity")
                        bv.Velocity = Vector3.new(0, 150, 0)
                        bv.MaxForce = Vector3.new(0, 5000, 0)
                        bv.Parent = root
                        game:GetService("Debris"):AddItem(bv, 3)
                    end
                    
                elseif command == "ExplodeAll" then
                    if root then
                        local exp = Instance.new("Explosion")
                        exp.Position = root.Position
                        exp.BlastRadius = 15
                        exp.BlastPressure = 500
                        exp.Parent = workspace
                    end
                    
                elseif command == "PullAll" then
                    local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if myRoot and root then
                        root.CFrame = myRoot.CFrame + Vector3.new(math.random(-5, 5), 3, math.random(-5, 5))
                    end
                    
                elseif command == "NoobAll" then
                    if humanoid then
                        humanoid.WalkSpeed = 2
                        humanoid.JumpPower = 0
                        humanoid.PlatformStand = true
                    end
                    
                elseif command == "UnnoobAll" then
                    if humanoid then
                        humanoid.WalkSpeed = 16
                        humanoid.JumpPower = 50
                        humanoid.PlatformStand = false
                    end
                    
                elseif command == "KillAll" then
                    if humanoid then
                        humanoid.Health = 0
                    end
                end
            end
        end
    end
end)

print("🐉 Dragon Server Script Loaded!")
