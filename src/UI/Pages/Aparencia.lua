local ThemeModule = require(script.Parent.Parent.Parent.Theme)
local Helpers = require(script.Parent.Parent.Parent.Helpers)
local UI = require(script.Parent.Parent.Components)

local Theme = ThemeModule.Theme

local function build(page)
    local section = UI.createAutoSection(page, 1)
    UI.createSectionHeader(section, "Paletas de batalha", 1)

    local paletteRow = Helpers.new("Frame", {
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
        Parent = paletteRow,
    })

    local presets = {
        {
            name = "Azul Arena",
            colors = {
                Primary = Color3.fromRGB(34, 113, 255),
                Background = Color3.fromRGB(12, 18, 34),
                Surface = Color3.fromRGB(19, 29, 48),
                Button = Color3.fromRGB(31, 42, 64),
                Border = Color3.fromRGB(68, 92, 134),
                Text = Color3.fromRGB(240, 245, 255),
                TextDim = Color3.fromRGB(170, 182, 214),
            },
        },
        {
            name = "Vermelho Furia",
            colors = {
                Primary = Color3.fromRGB(255, 88, 88),
                Background = Color3.fromRGB(28, 12, 14),
                Surface = Color3.fromRGB(44, 20, 22),
                Button = Color3.fromRGB(62, 34, 34),
                Border = Color3.fromRGB(124, 64, 64),
                Text = Color3.fromRGB(255, 240, 240),
                TextDim = Color3.fromRGB(214, 166, 166),
            },
        },
        {
            name = "Laranja Turbo",
            colors = {
                Primary = Color3.fromRGB(255, 138, 54),
                Background = Color3.fromRGB(36, 20, 12),
                Surface = Color3.fromRGB(54, 31, 20),
                Button = Color3.fromRGB(74, 44, 30),
                Border = Color3.fromRGB(150, 86, 48),
                Text = Color3.fromRGB(255, 245, 238),
                TextDim = Color3.fromRGB(220, 184, 160),
            },
        },
    }

    for _, preset in ipairs(presets) do
        local button = Helpers.new("TextButton", {
            Size = UDim2.fromOffset(34, 34),
            BackgroundColor3 = preset.colors.Primary,
            Text = "",
            AutoButtonColor = false,
            Parent = paletteRow,
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

    local toggleSection = UI.createAutoSection(page, 2)
    UI.createSectionHeader(toggleSection, "Ajustes rápida", 1)
    local toggle = UI.createToggle(toggleSection, "Animações", true, 2, function(value)
        -- ajuste futuramente
    end)

    return { toggle = toggle }
end

return build
