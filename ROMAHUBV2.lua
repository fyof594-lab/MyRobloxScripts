local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera

local camlock = false
local target = nil
local key = Enum.KeyCode.Q

UIS.InputBegan:Connect(function(input)
    if input.KeyCode == key then
        camlock = not camlock
        if camlock then
            -- يجيب اقرب لاعب
            for _,plr in pairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    target = plr
                end
            end
        else
            target = nil
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if camlock and target and target.Character then
        Cam.CFrame = CFrame.new(Cam.CFrame.Position, target.Character.HumanoidRootPart.Position)
    end
end)
