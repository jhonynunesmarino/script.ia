local Theme = {
    Primary = Color3.fromRGB(91, 109, 255),
    Secondary = Color3.fromRGB(72, 192, 255),
    Background = Color3.fromRGB(12, 16, 24),
    Surface = Color3.fromRGB(22, 27, 37),
    SurfaceAlt = Color3.fromRGB(31, 38, 52),
    Button = Color3.fromRGB(40, 48, 63),
    Border = Color3.fromRGB(78, 98, 130),
    Text = Color3.fromRGB(242, 246, 255),
    TextDim = Color3.fromRGB(168, 180, 204),
    Success = Color3.fromRGB(118, 210, 142),
    Warning = Color3.fromRGB(255, 167, 87),
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
