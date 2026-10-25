local ThemeModule = require(script.Parent.Parent.Parent.Theme)
local Helpers = require(script.Parent.Parent.Parent.Helpers)
local UI = require(script.Parent.Parent.Components)

local Theme = ThemeModule.Theme

local function build(page)
    local section = UI.createAutoSection(page, 1)
    UI.createSectionHeader(section, "Paletas predefinidas", 1)

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

    local presetPalettes = {
        { name = "Azul", colors = { Primary = Color3.fromRGB(45, 125, 210), Background = Color3.fromRGB(28, 28, 34), Surface = Color3.fromRGB(38, 38, 46), Button = Color3.fromRGB(52, 52, 62), Border = Color3.fromRGB(72, 72, 84), Text = Color3.fromRGB(240, 240, 245), TextDim = Color3.fromRGB(158, 158, 170) } },
        { name = "Vermelho", colors = { Primary = Color3.fromRGB(200, 50, 50), Background = Color3.fromRGB(34, 22, 22), Surface = Color3.fromRGB(46, 32, 32), Button = Color3.fromRGB(62, 44, 44), Border = Color3.fromRGB(74, 50, 50), Text = Color3.fromRGB(245, 240, 240), TextDim = Color3.fromRGB(180, 160, 160) } },
        { name = "Roxo", colors = { Primary = Color3.fromRGB(140, 70, 200), Background = Color3.fromRGB(28, 22, 38), Surface = Color3.fromRGB(38, 32, 50), Button = Color3.fromRGB(54, 46, 68), Border = Color3.fromRGB(78, 66, 90), Text = Color3.fromRGB(245, 240, 250), TextDim = Color3.fromRGB(186, 172, 204) } },
        { name = "Verde", colors = { Primary = Color3.fromRGB(50, 170, 100), Background = Color3.fromRGB(20, 30, 24), Surface = Color3.fromRGB(30, 42, 34), Button = Color3.fromRGB(42, 58, 48), Border = Color3.fromRGB(62, 78, 66), Text = Color3.fromRGB(240, 246, 240), TextDim = Color3.fromRGB(170, 190, 176) } },
    }

    for _, preset in ipairs(presetPalettes) do
        local btn = Helpers.new("TextButton", {
            Size = UDim2.fromOffset(36, 36),
            BackgroundColor3 = preset.colors.Primary,
            Text = "",
            AutoButtonColor = false,
            LayoutOrder = _,
            Parent = presetRow,
        })
        Helpers.new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = btn })
        Helpers.new("UIStroke", { Color = Theme.Border, Thickness = 2, Parent = btn })

        btn.Activated:Connect(function()
            for key, value in pairs(preset.colors) do
                Theme[key] = value
            end
            ThemeModule.applyTheme()
        end)
    end

    local editorSection = UI.createAutoSection(page, 2)
    UI.createSectionHeader(editorSection, "Cor personalizada", 1)
    local toggle = UI.createToggle(editorSection, "Animações", true, 2, function(value)
        -- callback de exemplo
    end)

    return {
        toggle = toggle,
        presets = presetPalettes,
    }
end

return build
