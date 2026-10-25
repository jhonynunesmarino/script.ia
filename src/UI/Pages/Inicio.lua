local ThemeModule = require(script.Parent.Parent.Parent.Theme)
local Helpers = require(script.Parent.Parent.Parent.Helpers)
local UI = require(script.Parent.Parent.Components)

local Theme = ThemeModule.Theme

local function build(page)
    local section = UI.createAutoSection(page, 1)
    UI.createSectionHeader(section, "Bem-vindo!", 1)

    local welcomeText = Helpers.new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text = "Este é um sistema de interface moderno e personalizável. Navegue pelas páginas do menu lateral para visualizar informações do jogador, servidor, sessão e personalizar a aparência.",
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

    local tipsSection = UI.createAutoSection(page, 2)
    UI.createSectionHeader(tipsSection, "Dicas rápidas", 1)

    local tipsText = Helpers.new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text = "• Arraste a barra de título para mover o menu.\n• Use − para minimizar, □ para maximizar e × para fechar.\n• Pressione F2 para reabrir o menu a qualquer momento.\n• Personalize a paleta de cores na página de aparência.",
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextColor3 = Theme.TextDim,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        LayoutOrder = 2,
        Parent = tipsSection,
    })
    ThemeModule.bindTheme(tipsText, "TextColor3", "TextDim")

    return {
        welcomeText = welcomeText,
        tipsText = tipsText,
    }
end

return build
