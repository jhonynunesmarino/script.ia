local ThemeModule = require(script.Parent.Parent.Parent.Theme)
local Helpers = require(script.Parent.Parent.Parent.Helpers)
local UI = require(script.Parent.Parent.Components)

local function build(page)
    local section = UI.createAutoSection(page, 1)
    UI.createSectionHeader(section, "Inventário", 1)

    local inventory = {
        { name = "Beyblade A", rarity = "Rare" },
        { name = "Beyblade B", rarity = "Epic" },
        { name = "Boost Core", rarity = "Legendary" },
    }

    for index, item in ipairs(inventory) do
        local row = UI.createInfoRow(section, item.name, index + 1)
        row.Text = item.rarity
    end

    return inventory
end

return build
