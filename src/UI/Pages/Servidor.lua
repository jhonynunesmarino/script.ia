local ThemeModule = require(script.Parent.Parent.Parent.Theme)
local Helpers = require(script.Parent.Parent.Parent.Helpers)
local UI = require(script.Parent.Parent.Components)

local function build(page)
    local section = UI.createAutoSection(page, 1)
    UI.createSectionHeader(section, "Status da arena", 1)

    local values = {}
    values.experience = UI.createInfoRow(section, "Experiência", 2)
    values.placeId = UI.createInfoRow(section, "PlaceId", 3)
    values.jobId = UI.createInfoRow(section, "JobId", 4)
    values.playerCount = UI.createInfoRow(section, "Jogadores", 5)

    return values
end

return build
