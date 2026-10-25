local ThemeModule = require(script.Parent.Parent.Parent.Theme)
local Helpers = require(script.Parent.Parent.Parent.Helpers)
local UI = require(script.Parent.Parent.Components)

local Theme = ThemeModule.Theme

local function build(page)
    local section = UI.createAutoSection(page, 1)
    UI.createSectionHeader(section, "Perfil do jogador", 1)

    local values = {}
    values.name = UI.createInfoRow(section, "Nome", 2)
    values.displayName = UI.createInfoRow(section, "DisplayName", 3)
    values.userId = UI.createInfoRow(section, "UserId", 4)
    values.state = UI.createInfoRow(section, "Estado", 5)
    values.state.Text = "Online"

    return values
end

return build
