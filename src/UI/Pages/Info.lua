local ThemeModule = require(script.Parent.Parent.Theme)
local Helpers = require(script.Parent.Parent.Helpers)
local UI = require(script.Parent.Parent.Components)

local function build(page)
    local section = UI.createAutoSection(page, 1)
    UI.createSectionHeader(section, "Sessão e personagem", 1)

    local values = {}
    values.entryTime = UI.createInfoRow(section, "Entrada", 2)
    values.sessionTime = UI.createInfoRow(section, "Tempo de sessão", 3)
    values.currentTime = UI.createInfoRow(section, "Horário atual", 4)

    local posSection = UI.createAutoSection(page, 2)
    UI.createSectionHeader(posSection, "Personagem", 1)
    values.position = UI.createInfoRow(posSection, "Posição (X, Y, Z)", 2)
    values.state = UI.createInfoRow(posSection, "Estado", 3)

    return values
end

return build
