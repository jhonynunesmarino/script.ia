local Theme = {
    Primary = Color3.fromRGB(45, 125, 210),
    Background = Color3.fromRGB(28, 28, 34),
    Surface = Color3.fromRGB(38, 38, 46),
    Button = Color3.fromRGB(52, 52, 62),
    Border = Color3.fromRGB(72, 72, 84),
    Text = Color3.fromRGB(240, 240, 245),
    TextDim = Color3.fromRGB(158, 158, 170),
}

local themeBindings = {}
local themeCallbacks = {}

local function bindTheme(instance, property, themeKey)
    if not instance then
        return
    end

    themeBindings[instance] = themeBindings[instance] or {}
    themeBindings[instance][property] = themeKey
    instance[property] = Theme[themeKey]
end

local function onThemeChanged(fn)
    table.insert(themeCallbacks, fn)
end

local function applyTheme()
    for instance, props in pairs(themeBindings) do
        if instance and instance.Parent then
            for property, themeKey in pairs(props) do
                pcall(function()
                    instance[property] = Theme[themeKey]
                end)
            end
        else
            themeBindings[instance] = nil
        end
    end

    for _, fn in ipairs(themeCallbacks) do
        pcall(fn)
    end
end

return {
    Theme = Theme,
    bindTheme = bindTheme,
    onThemeChanged = onThemeChanged,
    applyTheme = applyTheme,
}
