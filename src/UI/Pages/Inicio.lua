local ThemeModule = require(script.Parent.Parent.Theme)
local Helpers = require(script.Parent.Parent.Helpers)
local UI = require(script.Parent.Parent.Components)

local Theme = ThemeModule.Theme

local function build(page)
    local section = UI.createAutoSection(page, 1)
    UI.createSectionHeader(section, "Bem-vindo!", 1)

    local welcomeText = Helpers.new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text = "Este menu mostra informações do jogador, servidor e configurações visuais em um estilo moderno e responsivo.",
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

    return {
        welcomeText = welcomeText,
    }
end

return build
