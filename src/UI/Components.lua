local ThemeModule = require(script.Parent.Parent.Theme)
local Helpers = require(script.Parent.Parent.Helpers)

local Theme = ThemeModule.Theme

local UI = {}

function UI.createAutoSection(parent, order)
    local section = Helpers.new("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        LayoutOrder = order,
        Parent = parent,
    })

    ThemeModule.bindTheme(section, "BackgroundColor3", "Surface")

    Helpers.new("UICorner", { CornerRadius = UDim.new(0, 10), Parent = section })
    Helpers.new("UIPadding", {
        PaddingLeft = UDim.new(0, 14),
        PaddingRight = UDim.new(0, 14),
        PaddingTop = UDim.new(0, 12),
        PaddingBottom = UDim.new(0, 12),
        Parent = section,
    })
    Helpers.new("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = section,
    })

    return section
end

function UI.createSectionHeader(parent, text, order)
    local label = Helpers.new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        Text = text,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = order,
        Parent = parent,
    })

    ThemeModule.bindTheme(label, "TextColor3", "Text")
    return label
end

function UI.createInfoRow(parent, labelText, order)
    local row = Helpers.new("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Theme.Button,
        BorderSizePixel = 0,
        LayoutOrder = order,
        Parent = parent,
    })

    ThemeModule.bindTheme(row, "BackgroundColor3", "Button")
    Helpers.new("UICorner", { CornerRadius = UDim.new(0, 6), Parent = row })

    local label = Helpers.new("TextLabel", {
        Size = UDim2.new(0.45, 0, 1, 0),
        Position = UDim2.fromOffset(12, 0),
        BackgroundTransparency = 1,
        Text = labelText,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextColor3 = Theme.TextDim,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    })

    ThemeModule.bindTheme(label, "TextColor3", "TextDim")

    local value = Helpers.new("TextLabel", {
        Size = UDim2.new(0.55, -24, 1, 0),
        Position = UDim2.new(0.45, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = "—",
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = row,
    })

    ThemeModule.bindTheme(value, "TextColor3", "Text")
    return value
end

function UI.createToggle(parent, labelText, initial, order, callback)
    local row = Helpers.new("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Theme.Button,
        BorderSizePixel = 0,
        LayoutOrder = order,
        Parent = parent,
    })

    ThemeModule.bindTheme(row, "BackgroundColor3", "Button")
    Helpers.new("UICorner", { CornerRadius = UDim.new(0, 8), Parent = row })

    local textLabel = Helpers.new("TextLabel", {
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.fromOffset(12, 0),
        BackgroundTransparency = 1,
        Text = labelText,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    })

    ThemeModule.bindTheme(textLabel, "TextColor3", "Text")

    local track = Helpers.new("Frame", {
        Size = UDim2.fromOffset(44, 24),
        Position = UDim2.new(1, -56, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = initial and Theme.Primary or Theme.Border,
        BorderSizePixel = 0,
        Parent = row,
    })
    Helpers.new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = track })

    local knob = Helpers.new("Frame", {
        Size = UDim2.fromOffset(18, 18),
        Position = initial and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        Parent = track,
    })
    Helpers.new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = knob })

    local state = initial
    local function setState(value)
        state = value
        Helpers.tween(track, { BackgroundColor3 = state and Theme.Primary or Theme.Border }, 0.15)
        Helpers.tween(knob, { Position = state and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0) }, 0.15)
        if callback then
            callback(state)
        end
    end

    local clickArea = Helpers.new("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        Parent = row,
    })

    clickArea.Activated:Connect(function()
        setState(not state)
    end)

    ThemeModule.onThemeChanged(function()
        track.BackgroundColor3 = state and Theme.Primary or Theme.Border
    end)

    return { set = setState, get = function() return state end }
end

return UI
