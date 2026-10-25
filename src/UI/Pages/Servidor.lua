local ThemeModule = require(script.Parent.Parent.Theme)
local Helpers = require(script.Parent.Parent.Helpers)
local UI = require(script.Parent.Parent.Components)

local function build(page)
    local section = UI.createAutoSection(page, 1)
    UI.createSectionHeader(section, "Informações do servidor", 1)

    local values = {}
    values.placeId = UI.createInfoRow(section, "PlaceId", 2)
    values.jobId = UI.createInfoRow(section, "JobId", 3)
    values.playerCount = UI.createInfoRow(section, "Jogadores", 4)

    return values
end

return build
