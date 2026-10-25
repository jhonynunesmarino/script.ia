local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local LockOn = {}
LockOn.__index = LockOn

function LockOn.new(config)
    config = config or {}

    local self = setmetatable({}, LockOn)

    self.enabled = config.enabled or false
    self.maxDistance = config.maxDistance or 40
    self.maxAngle = config.maxAngle or 120
    self.yOffset = config.yOffset or 1.5
    self.refreshRate = config.refreshRate or 0.05
    self.target = nil
    self.lockKey = config.lockKey or Enum.KeyCode.T
    self.ignorePlayers = config.ignorePlayers == true
    self.ignoreNPCs = config.ignoreNPCs == true
    self.teamCheck = config.teamCheck or false
    self.onTargetChanged = config.onTargetChanged or function() end

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

    local function isFriendly(model)
        if not self.teamCheck then
            return false
        end

        local modelPlayer = Players:GetPlayerFromCharacter(model)
        if modelPlayer and modelPlayer ~= LocalPlayer then
            return modelPlayer.Team == LocalPlayer.Team
        end

        return false
    end

    local function isValidTarget(model)
        if not model or model == LocalPlayer.Character then
            return false
        end

        if not getRoot(model) then
            return false
        end

        if not getHumanoid(model) then
            return false
        end

        if isFriendly(model) then
            return false
        end

        return true
    end

    local function getTargetCandidates()
        local candidates = {}

        if not self.ignorePlayers then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and isValidTarget(player.Character) then
                    table.insert(candidates, player.Character)
                end
            end
        end

        if not self.ignoreNPCs then
            for _, descendant in ipairs(workspace:GetDescendants()) do
                if descendant:IsA("Model") and descendant ~= LocalPlayer.Character then
                    local model = descendant
                    if isValidTarget(model) then
                        table.insert(candidates, model)
                    end
                end
            end
        end

        return candidates
    end

    local function getClosestTarget()
        local bestModel = nil
        local bestDistance = math.huge
        local bestDot = -math.huge

        local cameraPosition = Camera.CFrame.Position
        local cameraForward = Camera.CFrame.LookVector

        for _, model in ipairs(getTargetCandidates()) do
            local root = getRoot(model)
            local distance = (root.Position - cameraPosition).Magnitude
            if distance <= self.maxDistance then
                local direction = (root.Position - cameraPosition).Unit
                local dot = direction:Dot(cameraForward)
                local angle = math.deg(math.acos(math.clamp(dot, -1, 1)))

                if angle <= self.maxAngle then
                    if distance < bestDistance or (distance == bestDistance and dot > bestDot) then
                        bestDistance = distance
                        bestDot = dot
                        bestModel = model
                    end
                end
            end
        end

        return bestModel
    end

    local function updateLock()
        if not self.enabled then
            self.target = nil
            return
        end

        local targetModel = getClosestTarget()
        if targetModel and targetModel ~= self.target then
            self.target = targetModel
            self.onTargetChanged(targetModel)
        elseif not targetModel then
            self.target = nil
        end

        if self.target then
            local root = getRoot(self.target)
            if root then
                local targetPosition = root.Position + Vector3.new(0, self.yOffset, 0)
                local cameraPosition = Camera.CFrame.Position
                local lookAtCFrame = CFrame.new(cameraPosition, targetPosition)
                Camera.CFrame = lookAtCFrame
            end
        end
    end

    local function bindInput()
        UserInputService.InputBegan:Connect(function(input, processed)
            if processed then
                return
            end

            if input.KeyCode == self.lockKey then
                self.enabled = not self.enabled
                if not self.enabled then
                    self.target = nil
                end
            end
        end)
    end

    function self:SetEnabled(value)
        self.enabled = value
        if not self.enabled then
            self.target = nil
        end
    end

    function self:Toggle()
        self.enabled = not self.enabled
        if not self.enabled then
            self.target = nil
        end
    end

    function self:GetTarget()
        return self.target
    end

    function self:Update()
        updateLock()
    end

    self._connection = RunService.RenderStepped:Connect(function()
        if self.enabled then
            updateLock()
        end
    end)

    bindInput()
    return self
end

return LockOn
