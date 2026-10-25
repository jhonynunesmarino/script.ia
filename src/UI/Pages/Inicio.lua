local ThemeModule = require(script.Parent.Parent.Parent.Theme)
local Helpers = require(script.Parent.Parent.Parent.Helpers)
local UI = require(script.Parent.Parent.Components)

local Theme = ThemeModule.Theme

local function build(page)
    local section = UI.createAutoSection(page, 1)
    UI.createSectionHeader(section, "Bem-vindo ao Hub", 1)

    local welcomeText = Helpers.new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text = "Bem-vindo ao sistema BeyRivals-inspired. Aqui você controle de atributos, status e painel de combate em um visual moderno e organizado.",
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextColor3 = Theme.TextDim,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        LayoutOrder = 2,
        Parent = section,
    })
    ThemeModule.bindTheme(welcomeText, "TextColor3", "TextDim")

    local statusSection = UI.createAutoSection(page, 2)
    UI.createSectionHeader(statusSection, "Status rápido", 1)

    local powerRow = UI.createInfoRow(statusSection, "Poder", 2)
    local speedRow = UI.createInfoRow(statusSection, "Velocidade", 3)
    local comboRow = UI.createInfoRow(statusSection, "Combo", 4)

    powerRow.Text = "98"
    speedRow.Text = "87"
    comboRow.Text = "12x"

    return {
        power = powerRow,
        speed = speedRow,
        combo = comboRow,
    }
end

return build
