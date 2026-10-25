local ThemeModule = require(script.Parent.Parent.Parent.Theme)
local Helpers = require(script.Parent.Parent.Parent.Helpers)
local UI = require(script.Parent.Parent.Components)

local function build(page)
    local section = UI.createAutoSection(page, 1)
    UI.createSectionHeader(section, "Modo de combate", 1)

    local combatInfo = {}
    combatInfo.mode = UI.createInfoRow(section, "Modo", 2)
    combatInfo.enemies = UI.createInfoRow(section, "Inimigos", 3)
    combatInfo.round = UI.createInfoRow(section, "Rodada", 4)
    combatInfo.ability = UI.createInfoRow(section, "Habilidade ativa", 5)

    combatInfo.mode.Text = "Arena"
    combatInfo.enemies.Text = "3"
    combatInfo.round.Text = "7"
    combatInfo.ability.Text = "Bey Rush"

    return combatInfo
end

return build
