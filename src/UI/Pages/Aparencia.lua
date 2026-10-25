local ThemeModule = require(script.Parent.Parent.Theme)
local Helpers = require(script.Parent.Parent.Helpers)
local UI = require(script.Parent.Parent.Components)

local Theme = ThemeModule.Theme

local function build(page)
    local section = UI.createAutoSection(page, 1)
    UI.createSectionHeader(section, "Paletas visuais", 1)

    local presetRow = Helpers.new("Frame", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        Parent = section,
    })

    Helpers.new("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Parent = presetRow,
    })

    local presets = {
        {
            name = "Azul",
            colors = {
                Primary = Color3.fromRGB(46, 134, 255),
                Background = Color3.fromRGB(17, 20, 26),
                Surface = Color3.fromRGB(24, 30, 40),
                Button = Color3.fromRGB(40, 48, 60),
                Border = Color3.fromRGB(77, 95, 120),
                Text = Color3.fromRGB(240, 245, 255),
                TextDim = Color3.fromRGB(170, 182, 214),
            },
        },
        {
            name = "Vermelho",
            colors = {
                Primary = Color3.fromRGB(255, 95, 95),
                Background = Color3.fromRGB(28, 14, 16),
                Surface = Color3.fromRGB(42, 22, 24),
                Button = Color3.fromRGB(67, 34, 34),
                Border = Color3.fromRGB(120, 60, 60),
                Text = Color3.fromRGB(255, 240, 240),
                TextDim = Color3.fromRGB(220, 172, 172),
            },
        },
        {
            name = "Laranja",
            colors = {
                Primary = Color3.fromRGB(255, 150, 72),
                Background = Color3.fromRGB(30, 22, 16),
                Surface = Color3.fromRGB(49, 36, 26),
                Button = Color3.fromRGB(70, 51, 38),
                Border = Color3.fromRGB(146, 104, 76),
                Text = Color3.fromRGB(255, 246, 236),
                TextDim = Color3.fromRGB(214, 176, 146),
            },
        },
    }

    for _, preset in ipairs(presets) do
        local button = Helpers.new("TextButton", {
            Size = UDim2.fromOffset(34, 34),
            BackgroundColor3 = preset.colors.Primary,
            Text = "",
            AutoButtonColor = false,
            Parent = presetRow,
        })
        Helpers.new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = button })
        Helpers.new("UIStroke", { Color = Theme.Border, Thickness = 2, Parent = button })

        button.Activated:Connect(function()
            for key, value in pairs(preset.colors) do
                Theme[key] = value
            end
            ThemeModule.applyTheme()
        end)
    end

    local editor = UI.createAutoSection(page, 2)
    UI.createSectionHeader(editor, "Ajustes rápidos", 1)
    local toggle = UI.createToggle(editor, "Animações", true, 2, function(value)
        -- futuro ajuste de animações
    end)

    return { toggle = toggle }
end

return build
