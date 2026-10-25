local TweenService = game:GetService("TweenService")

local Helpers = {}

function Helpers.new(className, props, children)
    local instance = Instance.new(className)
    local parent = nil

    if props then
        for key, value in pairs(props) do
            if key == "Parent" then
                parent = value
            else
                instance[key] = value
            end
        end
    end

    if children then
        for _, child in ipairs(children) do
            child.Parent = instance
        end
    end

    if parent then
        instance.Parent = parent
    end

    return instance
end

function Helpers.tween(instance, props, duration, style, dir)
    if not instance then
        return nil
    end

    local tweenInfo = TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, tweenInfo, props)
    tween:Play()
    return tween
end

function Helpers.lighten(color, amount)
    return Color3.new(
        math.clamp(color.R + amount, 0, 1),
        math.clamp(color.G + amount, 0, 1),
        math.clamp(color.B + amount, 0, 1)
    )
end

function Helpers.formatDuration(seconds)
    seconds = math.max(0, math.floor(seconds))
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60
    return string.format("%02d:%02d:%02d", h, m, s)
end

return Helpers
