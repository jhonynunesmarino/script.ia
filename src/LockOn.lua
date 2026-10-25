local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local LockOn = {}
LockOn.__index = LockOn

local function clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

local function getHumanoid(model)
    if not model or typeof(model) ~= "Instance" then
        return nil
    end

    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Health > 0 then
        return humanoid
    end

    return nil
end

local function getRoot(model)
    if not model then
        return nil
    end

    return model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model:FindFirstChild("UpperTorso")
end

local function isFriendly(model, teamCheck, localTeam)
    if not teamCheck then
        return false
    end

    local player = Players:GetPlayerFromCharacter(model)
    if player and player ~= LocalPlayer then
        return player.Team == localTeam
    end

    return false
end

local function getCharacterName(model)
    local player = Players:GetPlayerFromCharacter(model)
    if player then
        return player.DisplayName or player.Name
    end

    local humanoid = getHumanoid(model)
    if humanoid then
        return humanoid.DisplayName or model.Name
    end

    return model.Name
end

function LockOn.new(config)
    config = config or {}

    local self = setmetatable({}, LockOn)

    self.enabled = config.enabled or false
    self.maxDistance = config.maxDistance or 40
    self.maxAngle = config.maxAngle or 120
    self.yOffset = config.yOffset or 1.5
    self.lockKey = config.lockKey or Enum.KeyCode.T
    self.ignorePlayers = config.ignorePlayers == true
    self.ignoreNPCs = config.ignoreNPCs == true
    self.teamCheck = config.teamCheck or false
    self.target = nil
    self.targetHud = nil
    self.onTargetChanged = config.onTargetChanged or function() end
    self.showHealthBar = config.showHealthBar ~= false

    self.screenGui = Instance.new("ScreenGui")
    self.screenGui.Name = "LockOnHud"
    self.screenGui.ResetOnSpawn = false
    self.screenGui.IgnoreGuiInset = true
    self.screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    self.reticle = Instance.new("TextLabel")
    self.reticle.Name = "Reticle"
    self.reticle.Size = UDim2.fromOffset(30, 30)
    self.reticle.Position = UDim2.new(0.5, -15, 0.5, -15)
    self.reticle.BackgroundTransparency = 1
    self.reticle.Text = "◎"
    self.reticle.TextColor3 = config.reticleColor or Color3.fromRGB(255, 255, 255)
    self.reticle.TextSize = 20
    self.reticle.Font = Enum.Font.GothamBold
    self.reticle.Parent = self.screenGui

    self.targetLabel = Instance.new("TextLabel")
    self.targetLabel.Name = "TargetName"
    self.targetLabel.Size = UDim2.new(0, 180, 0, 28)
    self.targetLabel.Position = UDim2.new(0.5, -90, 0.2, 0)
    self.targetLabel.BackgroundTransparency = 1
    self.targetLabel.Text = ""
    self.targetLabel.TextColor3 = config.targetTextColor or Color3.fromRGB(255, 255, 255)
    self.targetLabel.TextSize = 14
    self.targetLabel.Font = Enum.Font.GothamSemibold
    self.targetLabel.TextXAlignment = Enum.TextXAlignment.Center
    self.targetLabel.Visible = false
    self.targetLabel.Parent = self.screenGui

    local function clearTargetHud()
        if self.targetHud and self.targetHud.Parent then
            self.targetHud:Destroy()
        end
        self.targetHud = nil
    end

    local function createTargetHud(targetModel)
        clearTargetHud()

        local root = getRoot(targetModel)
        if not root then
            return
        end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "TargetHud"
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.fromOffset(140, 56)
        billboard.StudsOffset = Vector3.new(0, 4.2, 0)
        billboard.Adornee = root
        billboard.Parent = targetModel

        local panel = Instance.new("Frame")
        panel.Name = "Panel"
        panel.Size = UDim2.fromScale(1, 1)
        panel.BackgroundColor3 = Color3.fromRGB(18, 20, 24)
        panel.BackgroundTransparency = 0.2
        panel.Parent = billboard

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = panel

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "TargetName"
        nameLabel.Size = UDim2.new(1, -18, 0, 20)
        nameLabel.Position = UDim2.new(0, 9, 0, 4)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = getCharacterName(targetModel)
        nameLabel.TextColor3 = config.targetTextColor or Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 12
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = panel

        local barBg = Instance.new("Frame")
        barBg.Name = "HealthBg"
        barBg.Size = UDim2.new(1, -18, 0, 10)
        barBg.Position = UDim2.new(0, 9, 0, 24)
        barBg.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
        barBg.Parent = panel

        local barCorner = Instance.new("UICorner")
        barCorner.CornerRadius = UDim.new(1, 0)
        barCorner.Parent = barBg

        local barFill = Instance.new("Frame")
        barFill.Name = "HealthFill"
        barFill.Size = UDim2.new(1, 0, 1, 0)
        barFill.BackgroundColor3 = config.healthBarColor or Color3.fromRGB(97, 215, 143)
        barFill.Parent = barBg

        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(1, 0)
        fillCorner.Parent = barFill

        local hpText = Instance.new("TextLabel")
        hpText.Name = "HealthText"
        hpText.Size = UDim2.new(1, -18, 0, 18)
        hpText.Position = UDim2.new(0, 9, 0, 32)
        hpText.BackgroundTransparency = 1
        hpText.Text = "100%"
        hpText.TextColor3 = Color3.fromRGB(255, 255, 255)
        hpText.TextSize = 10
        hpText.Font = Enum.Font.GothamSemibold
        hpText.TextXAlignment = Enum.TextXAlignment.Right
        hpText.Parent = panel

        billboard:SetAttribute("NameLabel", nameLabel)
        billboard:SetAttribute("HealthFill", barFill)
        billboard:SetAttribute("HealthText", hpText)

        self.targetHud = billboard
    end

    local function updateTargetHud()
        if not self.target or not self.targetHud or not self.showHealthBar then
            return
        end

        local root = getRoot(self.target)
        if not root then
            return
        end

        local nameLabel = self.targetHud:FindFirstChild("Panel", true):FindFirstChild("TargetName", true)
        local fill = self.targetHud:FindFirstChild("Panel", true):FindFirstChild("HealthBg", true):FindFirstChild("HealthFill", true)
        local healthText = self.targetHud:FindFirstChild("Panel", true):FindFirstChild("HealthText", true)

        if nameLabel then
            nameLabel.Text = getCharacterName(self.target)
        end

        local humanoid = getHumanoid(self.target)
        if humanoid and fill and healthText then
            local ratio = clamp(humanoid.Health / math.max(humanoid.MaxHealth, 1), 0, 1)
            fill.Size = UDim2.new(ratio, 0, 1, 0)
            healthText.Text = string.format("%d%%", math.floor(ratio * 100))
        end
    end

    function self:ClearTarget()
        self.target = nil
        self.targetLabel.Visible = false
        self.targetLabel.Text = ""

        if self.targetHud then
            self.targetHud:Destroy()
            self.targetHud = nil
        end

        if self.reticle then
            self.reticle.TextStrokeTransparency = 1
        end
    end

    function self:GetTarget()
        return self.target
    end

    function self:SetEnabled(value)
        self.enabled = value
        if not self.enabled then
            self:ClearTarget()
        end
    end

    function self:Toggle()
        self.enabled = not self.enabled
        if not self.enabled then
            self:ClearTarget()
        end
    end

    local function isValidTarget(model)
        if not model or model == LocalPlayer.Character then
            return false
        end

        local root = getRoot(model)
        if not root then
            return false
        end

        if not getHumanoid(model) then
            return false
        end

        if isFriendly(model, self.teamCheck, LocalPlayer.Team) then
            return false
        end

        return true
    end

    local function getCandidates()
        local list = {}

        if not self.ignorePlayers then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and isValidTarget(player.Character) then
                    table.insert(list, player.Character)
                end
            end
        end

        if not self.ignoreNPCs then
            for _, descendant in ipairs(workspace:GetDescendants()) do
                if descendant:IsA("Model") and descendant ~= LocalPlayer.Character and isValidTarget(descendant) then
                    table.insert(list, descendant)
                end
            end
        end

        return list
    end

    local function getClosestTarget()
        local localCharacter = LocalPlayer.Character
        if not localCharacter then
            return nil
        end

        local localRoot = getRoot(localCharacter)
        if not localRoot then
            return nil
        end

        local cameraPosition = Camera.CFrame.Position
        local cameraForward = Camera.CFrame.LookVector
        local bestModel = nil
        local bestDistance = math.huge
        local bestDot = -math.huge

        for _, model in ipairs(getCandidates()) do
            local root = getRoot(model)
            if root then
                local offset = root.Position - cameraPosition
                local distance = offset.Magnitude

                if distance <= self.maxDistance then
                    local direction = offset.Unit
                    local dot = direction:Dot(cameraForward)
                    local angle = math.deg(math.acos(clamp(dot, -1, 1)))

                    if angle <= self.maxAngle then
                        if distance < bestDistance or (distance == bestDistance and dot > bestDot) then
                            bestDistance = distance
                            bestDot = dot
                            bestModel = model
                        end
                    end
                end
            end
        end

        return bestModel
    end

    function self:UpdateTarget()
        if not self.enabled then
            return
        end

        local targetModel = getClosestTarget()
        if targetModel then
            if self.target ~= targetModel then
                self.target = targetModel
                self.onTargetChanged(targetModel)
                createTargetHud(targetModel)
                self.targetLabel.Text = getCharacterName(targetModel)
                self.targetLabel.Visible = true
            end

            updateTargetHud()

            local root = getRoot(targetModel)
            if root then
                local targetPosition = root.Position + Vector3.new(0, self.yOffset, 0)
                local lookAt = CFrame.new(Camera.CFrame.Position, targetPosition)
                Camera.CFrame = Camera.CFrame:Lerp(lookAt, 0.2)
            end
        else
            self:ClearTarget()
        end
    end

    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then
            return
        end

        if input.KeyCode == self.lockKey then
            self:Toggle()
        end
    end)

    self._renderConnection = RunService.RenderStepped:Connect(function()
        if self.enabled then
            self:UpdateTarget()
        end
    end)

    return self
end

function LockOn:Destroy()
    if self._renderConnection then
        self._renderConnection:Disconnect()
    end

    if self.targetHud then
        self.targetHud:Destroy()
    end

    if self.screenGui then
        self.screenGui:Destroy()
    end

    self.target = nil
end

return LockOn
