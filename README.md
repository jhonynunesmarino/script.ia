--[[
    ═══════════════════════════════════════════════════════════════════
    SISTEMA DE INTERFACE GUI MODERNO - ROBLOX STUDIO
    ═══════════════════════════════════════════════════════════════════
    LocalScript — Coloque em: StarterPlayer > StarterPlayerScripts
    ═══════════════════════════════════════════════════════════════════
]]

-- ═══════════════════════════════════════════════════════════════════
-- CONFIGURAÇÃO DO CRIADOR (EDITE AQUI)
-- ═══════════════════════════════════════════════════════════════════
local CONFIG = {
    CreatorName = "SeuNome",
    Version     = "1.0.0",
    Credits     = "Desenvolvido com Luau · Roblox Studio",
    Description = "Sistema de interface moderno, responsivo e totalmente personalizável. Navegue pelas páginas laterais para acessar informações do jogador, servidor, sessão e personalizar a aparência do menu.",
    ToggleKey   = Enum.KeyCode.F2,
}

-- ═══════════════════════════════════════════════════════════════════
-- SERVIÇOS
-- ═══════════════════════════════════════════════════════════════════
local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local TweenService       = game:GetService("TweenService")
local UserInputService   = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local Workspace          = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

-- ═══════════════════════════════════════════════════════════════════
-- TEMA
-- ═══════════════════════════════════════════════════════════════════
local Theme = {
    Primary    = Color3.fromRGB(45, 125, 210),
    Background = Color3.fromRGB(28, 28, 34),
    Surface    = Color3.fromRGB(38, 38, 46),
    Button     = Color3.fromRGB(52, 52, 62),
    Border     = Color3.fromRGB(72, 72, 84),
    Text       = Color3.fromRGB(240, 240, 245),
    TextDim    = Color3.fromRGB(158, 158, 170),
}

local Settings = {
    AnimationsEnabled = true,
    ShadowEnabled     = true,
}

-- ═══════════════════════════════════════════════════════════════════
-- SISTEMA DE TEMA
-- ═══════════════════════════════════════════════════════════════════
local themeBindings  = {}
local themeCallbacks = {}

local function bindTheme(instance, property, themeKey)
    themeBindings[instance] = themeBindings[instance] or {}
    themeBindings[instance][property] = themeKey
    instance[property] = Theme[themeKey]
end

local function onThemeChanged(fn)
    table.insert(themeCallbacks, fn)
end

local function applyTheme()
    for inst, props in pairs(themeBindings) do
        if inst and inst.Parent then
            for prop, key in pairs(props) do
                pcall(function() inst[prop] = Theme[key] end)
            end
        else
            themeBindings[inst] = nil
        end
    end
    for _, fn in ipairs(themeCallbacks) do
        pcall(fn)
    end
end

-- ═══════════════════════════════════════════════════════════════════
-- HELPERS
-- ═══════════════════════════════════════════════════════════════════
local function new(className, props, children)
    local inst = Instance.new(className)
    local parent = nil
    if props then
        for k, v in pairs(props) do
            if k == "Parent" then parent = v
            else inst[k] = v end
        end
    end
    if children then
        for _, c in ipairs(children) do c.Parent = inst end
    end
    if parent then inst.Parent = parent end
    return inst
end

local function tween(instance, props, duration, style, dir)
    if not Settings.AnimationsEnabled then duration = 0 end
    local info = TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
    local t = TweenService:Create(instance, info, props)
    t:Play()
    return t
end

local function lighten(color, amount)
    return Color3.new(
        math.clamp(color.R + amount, 0, 1),
        math.clamp(color.G + amount, 0, 1),
        math.clamp(color.B + amount, 0, 1)
    )
end

local function formatDuration(seconds)
    seconds = math.max(0, math.floor(seconds))
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60
    return string.format("%02d:%02d:%02d", h, m, s)
end

-- ═══════════════════════════════════════════════════════════════════
-- DADOS DE SESSÃO
-- ═══════════════════════════════════════════════════════════════════
local sessionStart = os.clock()
local entryTime    = DateTime.now()

-- ═══════════════════════════════════════════════════════════════════
-- SCREENGUI + JANELA
-- ═══════════════════════════════════════════════════════════════════
local screenGui = new("ScreenGui", {
    Name = "ModernMenuGui",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = PlayerGui,
})

local function getInitialSize()
    local vp = Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
    local w = math.min(780, vp.X - 40)
    local h = math.min(520, vp.Y - 40)
    return UDim2.fromOffset(w, h)
end

local DEFAULT_SIZE  = getInitialSize()
local TITLE_HEIGHT  = 44
local SIDEBAR_WIDTH = 180

local windowRoot = new("Frame", {
    Name = "WindowRoot",
    Size = DEFAULT_SIZE,
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundTransparency = 1,
    Parent = screenGui,
})

local shadow = new("Frame", {
    Name = "Shadow",
    Size = UDim2.fromScale(1, 1),
    Position = UDim2.fromOffset(0, 8),
    BackgroundColor3 = Color3.new(0, 0, 0),
    BackgroundTransparency = 0.55,
    BorderSizePixel = 0,
    ZIndex = 1,
    Parent = windowRoot,
})
new("UICorner", { CornerRadius = UDim.new(0, 12), Parent = shadow })

local mainFrame = new("Frame", {
    Name = "MainWindow",
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    ZIndex = 2,
    Parent = windowRoot,
})
bindTheme(mainFrame, "BackgroundColor3", "Background")
new("UICorner", { CornerRadius = UDim.new(0, 12), Parent = mainFrame })
local mainStroke = new("UIStroke", { Color = Theme.Border, Thickness = 1, Parent = mainFrame })
bindTheme(mainStroke, "Color", "Border")

-- ═══════════════════════════════════════════════════════════════════
-- BARRA DE TÍTULO
-- ═══════════════════════════════════════════════════════════════════
local titleBar = new("Frame", {
    Name = "TitleBar",
    Size = UDim2.new(1, 0, 0, TITLE_HEIGHT),
    BackgroundColor3 = Theme.Primary,
    BorderSizePixel = 0,
    Parent = mainFrame,
})
bindTheme(titleBar, "BackgroundColor3", "Primary")

local dragHandle = new("Frame", {
    Name = "DragHandle",
    Size = UDim2.new(1, -140, 1, 0),
    BackgroundTransparency = 1,
    Parent = titleBar,
})

new("TextLabel", {
    Size = UDim2.new(1, -20, 1, 0),
    Position = UDim2.fromOffset(16, 0),
    BackgroundTransparency = 1,
    Text = "Menu Principal",
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.Text,
    Parent = dragHandle,
})

local controlsBar = new("Frame", {
    Name = "Controls",
    Size = UDim2.fromOffset(124, 32),
    Position = UDim2.new(1, -10, 0.5, 0),
    AnchorPoint = Vector2.new(1, 0.5),
    BackgroundTransparency = 1,
    Parent = titleBar,
})
new("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Padding = UDim.new(0, 4),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = controlsBar,
})

local minimizeWindow, toggleMaximize, closeMenu, openMenu

local function createWindowButton(text, order, hoverColor, callback)
    local btn = new("TextButton", {
        Size = UDim2.fromOffset(32, 32),
        BackgroundColor3 = Theme.Primary,
        BackgroundTransparency = 0.35,
        Text = text,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.Text,
        AutoButtonColor = false,
        LayoutOrder = order,
        Parent = controlsBar,
    })
    new("UICorner", { CornerRadius = UDim.new(0, 8), Parent = btn })

    btn.MouseEnter:Connect(function()
        tween(btn, { BackgroundTransparency = 0.05, BackgroundColor3 = hoverColor or lighten(Theme.Primary, 0.15) }, 0.12)
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, { BackgroundTransparency = 0.35, BackgroundColor3 = Theme.Primary }, 0.12)
    end)
    btn.Activated:Connect(callback)
    onThemeChanged(function() btn.BackgroundColor3 = Theme.Primary end)

    return btn
end

local btnMin   = createWindowButton("−", 1, nil,                        function() minimizeWindow() end)
local btnMax   = createWindowButton("□", 2, nil,                        function() toggleMaximize() end)
local btnClose = createWindowButton("×", 3, Color3.fromRGB(220, 60, 60), function() closeMenu() end)

-- ═══════════════════════════════════════════════════════════════════
-- DRAG
-- ═══════════════════════════════════════════════════════════════════
local windowState = "normal"
local restoreSize = DEFAULT_SIZE
local restorePos  = UDim2.new(0.5, 0, 0.5, 0)

local dragging = false
local dragStartPos, dragStartInput

dragHandle.InputBegan:Connect(function(input)
    if windowState == "maximized" then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        local absPos  = windowRoot.AbsolutePosition
        local absSize = windowRoot.AbsoluteSize
        local cx = absPos.X + absSize.X / 2
        local cy = absPos.Y + absSize.Y / 2
        windowRoot.Position = UDim2.fromOffset(cx, cy)
        dragStartPos = Vector2.new(cx, cy)
        dragStartInput = input.Position
        dragging = true
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStartInput
        windowRoot.Position = UDim2.fromOffset(dragStartPos.X + delta.X, dragStartPos.Y + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- CONTEÚDO
-- ═══════════════════════════════════════════════════════════════════
local contentRoot = new("Frame", {
    Name = "ContentRoot",
    Size = UDim2.new(1, 0, 1, -TITLE_HEIGHT),
    Position = UDim2.new(0, 0, 0, TITLE_HEIGHT),
    BackgroundTransparency = 1,
    Parent = mainFrame,
})

local sidebar = new("Frame", {
    Name = "Sidebar",
    Size = UDim2.new(0, SIDEBAR_WIDTH, 1, 0),
    BackgroundColor3 = Theme.Surface,
    BorderSizePixel = 0,
    Parent = contentRoot,
})
bindTheme(sidebar, "BackgroundColor3", "Surface")
new("UIPadding", {
    PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8),
    PaddingTop  = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8),
    Parent = sidebar,
})
new("UIListLayout", {
    Padding = UDim.new(0, 4),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = sidebar,
})

local pagesArea = new("Frame", {
    Name = "PagesArea",
    Size = UDim2.new(1, -SIDEBAR_WIDTH, 1, 0),
    Position = UDim2.new(0, SIDEBAR_WIDTH, 0, 0),
    BackgroundTransparency = 1,
    Parent = contentRoot,
})

-- ═══════════════════════════════════════════════════════════════════
-- SISTEMA DE PÁGINAS
-- ═══════════════════════════════════════════════════════════════════
local pages       = {}
local navEntries  = {}
local activePageId = nil

local function createPage(id, title, order)
    local page = new("ScrollingFrame", {
        Name = "Page_" .. id,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = Theme.Border,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        LayoutOrder = order,
        Parent = pagesArea,
    })
    bindTheme(page, "ScrollBarImageColor3", "Border")

    new("UIPadding", {
        PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16),
        PaddingTop  = UDim.new(0, 16), PaddingBottom = UDim.new(0, 16),
        Parent = page,
    })
    new("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = page,
    })

    local titleLabel = new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundTransparency = 1,
        Text = title,
        TextSize = 22,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 0,
        Parent = page,
    })
    bindTheme(titleLabel, "TextColor3", "Text")

    pages[id] = page
    return page
end

local function createNavButton(id, icon, title, order)
    local btn = new("TextButton", {
        Name = "Nav_" .. id,
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Theme.Button,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = order,
        Parent = sidebar,
    })
    new("UICorner", { CornerRadius = UDim.new(0, 8), Parent = btn })

    new("TextLabel", {
        Size = UDim2.fromOffset(28, 28),
        Position = UDim2.new(0, 6, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        Text = icon,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.Text,
        Parent = btn,
    })

    new("TextLabel", {
        Size = UDim2.new(1, -46, 1, 0),
        Position = UDim2.new(0, 40, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = btn,
    })

    table.insert(navEntries, { id = id, btn = btn })
    return btn
end

local function refreshNavColors()
    for _, e in ipairs(navEntries) do
        e.btn.BackgroundColor3 = (e.id == activePageId) and Theme.Primary or Theme.Button
    end
end
onThemeChanged(refreshNavColors)

local function showPage(id)
    activePageId = id
    for pageId, page in pairs(pages) do
        page.Visible = (pageId == id)
    end
    refreshNavColors()
    local page = pages[id]
    if page then
        if Settings.AnimationsEnabled then
            page.GroupTransparency = 1
            TweenService:Create(page, TweenInfo.new(0.2), { GroupTransparency = 0 }):Play()
        else
            page.GroupTransparency = 0
        end
    end
end

local function addNav(id, icon, title, order)
    local btn = createNavButton(id, icon, title, order)
    btn.Activated:Connect(function() showPage(id) end)
    btn.MouseEnter:Connect(function()
        if activePageId ~= id then
            tween(btn, { BackgroundColor3 = lighten(Theme.Button, 0.08) }, 0.1)
        end
    end)
    btn.MouseLeave:Connect(function()
        if activePageId ~= id then
            tween(btn, { BackgroundColor3 = Theme.Button }, 0.1)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════
-- COMPONENTES
-- ═══════════════════════════════════════════════════════════════════
local function createAutoSection(parent, order)
    local section = new("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        LayoutOrder = order,
        Parent = parent,
    })
    bindTheme(section, "BackgroundColor3", "Surface")
    new("UICorner", { CornerRadius = UDim.new(0, 10), Parent = section })
    new("UIPadding", {
        PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14),
        PaddingTop  = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12),
        Parent = section,
    })
    new("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = section,
    })
    return section
end

local function createSectionHeader(parent, text, order)
    local lbl = new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        Text = text,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = order,
        Parent = parent,
    })
    bindTheme(lbl, "TextColor3", "Text")
    return lbl
end

local function createInfoRow(parent, label, order)
    local row = new("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Theme.Button,
        BorderSizePixel = 0,
        LayoutOrder = order,
        Parent = parent,
    })
    bindTheme(row, "BackgroundColor3", "Button")
    new("UICorner", { CornerRadius = UDim.new(0, 6), Parent = row })

    local lbl = new("TextLabel", {
        Size = UDim2.new(0.45, 0, 1, 0),
        Position = UDim2.fromOffset(12, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextColor3 = Theme.TextDim,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    })
    bindTheme(lbl, "TextColor3", "TextDim")

    local value = new("TextLabel", {
        Size = UDim2.new(0.55, -24, 1, 0),
        Position = UDim2.new(0.45, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = "—",
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = row,
    })
    bindTheme(value, "TextColor3", "Text")
    return value
end

local function createSlider(parent, label, order, callback)
    local value = 0
    local container = new("Frame", {
        Size = UDim2.new(1, 0, 0, 46),
        BackgroundTransparency = 1,
        LayoutOrder = order,
        Parent = parent,
    })
    local textLabel = new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1,
        Text = label .. ": 0",
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container,
    })
    bindTheme(textLabel, "TextColor3", "Text")

    local track = new("Frame", {
        Size = UDim2.new(1, -16, 0, 10),
        Position = UDim2.new(0, 8, 0, 26),
        BackgroundColor3 = Theme.Border,
        BorderSizePixel = 0,
        Parent = container,
    })
    bindTheme(track, "BackgroundColor3", "Border")
    new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = track })

    local fill = new("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Theme.Primary,
        BorderSizePixel = 0,
        Parent = track,
    })
    bindTheme(fill, "BackgroundColor3", "Primary")
    new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = fill })

    local knob = new("Frame", {
        Size = UDim2.fromOffset(16, 16),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = track,
    })
    new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = knob })

    local overlay = new("Frame", {
        Size = UDim2.new(1, 16, 0, 24),
        Position = UDim2.new(0, -8, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        ZIndex = 5,
        Parent = track,
    })

    local dragging = false
    local function updateVisual(v)
        local rel = math.clamp(v / 255, 0, 1)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        knob.Position = UDim2.new(rel, 0, 0.5, 0)
        textLabel.Text = label .. ": " .. math.floor(v + 0.5)
    end
    local function setValue(v, fire)
        value = math.clamp(v, 0, 255)
        updateVisual(value)
        if fire then callback(value) end
    end
    local function setFromX(x)
        local rel = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
        setValue(rel * 255, true)
    end

    overlay.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            setFromX(input.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            setFromX(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    updateVisual(0)
    return {
        set      = setValue,
        getValue = function() return math.floor(value + 0.5) end,
    }
end

local function createToggle(parent, label, initial, order, callback)
    local row = new("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Theme.Button,
        BorderSizePixel = 0,
        LayoutOrder = order,
        Parent = parent,
    })
    bindTheme(row, "BackgroundColor3", "Button")
    new("UICorner", { CornerRadius = UDim.new(0, 8), Parent = row })

    local textLabel = new("TextLabel", {
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.fromOffset(12, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    })
    bindTheme(textLabel, "TextColor3", "Text")

    local track = new("Frame", {
        Size = UDim2.fromOffset(44, 24),
        Position = UDim2.new(1, -56, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = initial and Theme.Primary or Theme.Border,
        BorderSizePixel = 0,
        Parent = row,
    })
    new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = track })

    local knob = new("Frame", {
        Size = UDim2.fromOffset(18, 18),
        Position = initial and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        Parent = track,
    })
    new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = knob })

    local state = initial
    local function setState(v)
        state = v
        tween(track, { BackgroundColor3 = state and Theme.Primary or Theme.Border }, 0.15)
        tween(knob, { Position = state and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0) }, 0.15)
        callback(state)
    end

    local clickArea = new("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        Parent = row,
    })
    clickArea.Activated:Connect(function() setState(not state) end)

    onThemeChanged(function()
        track.BackgroundColor3 = state and Theme.Primary or Theme.Border
    end)
end

-- ═══════════════════════════════════════════════════════════════════
-- CONTROLES DE JANELA
-- ═══════════════════════════════════════════════════════════════════
local function saveRestore()
    if windowState == "normal" then
        restoreSize = windowRoot.Size
        restorePos  = windowRoot.Position
    end
end

minimizeWindow = function()
    if windowState == "minimized" then
        tween(windowRoot, { Size = restoreSize, Position = windowRoot.Position }, 0.3, Enum.EasingStyle.Quart)
        contentRoot.Visible = true
        shadow.Visible = Settings.ShadowEnabled
        windowState = "normal"
    else
        saveRestore()
        local w = windowRoot.AbsoluteSize.X
        tween(windowRoot, { Size = UDim2.new(0, w, 0, TITLE_HEIGHT) }, 0.3, Enum.EasingStyle.Quart)
        contentRoot.Visible = false
        shadow.Visible = false
        windowState = "minimized"
    end
end

toggleMaximize = function()
    if windowState == "maximized" then
        tween(windowRoot, { Size = restoreSize, Position = restorePos }, 0.3, Enum.EasingStyle.Quart)
        contentRoot.Visible = true
        shadow.Visible = Settings.ShadowEnabled
        windowState = "normal"
    else
        saveRestore()
        contentRoot.Visible = true
        shadow.Visible = false
        tween(windowRoot, {
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0.5, 0, 0.5, 0),
        }, 0.3, Enum.EasingStyle.Quart)
        windowState = "maximized"
    end
end

local toggleButton = new("TextButton", {
    Name = "ToggleButton",
    Size = UDim2.fromOffset(48, 48),
    Position = UDim2.new(0, 16, 0, 16),
    BackgroundColor3 = Theme.Primary,
    Text = "≡",
    TextSize = 24,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.Text,
    Visible = false,
    AutoButtonColor = false,
    Parent = screenGui,
})
new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = toggleButton })
onThemeChanged(function() toggleButton.BackgroundColor3 = Theme.Primary end)

closeMenu = function()
    if Settings.AnimationsEnabled then
        tween(windowRoot, { GroupTransparency = 1 }, 0.2)
        task.delay(0.22, function()
            windowRoot.Visible = false
            toggleButton.Visible = true
        end)
    else
        windowRoot.Visible = false
        toggleButton.Visible = true
    end
end

openMenu = function()
    toggleButton.Visible = false
    windowRoot.Visible = true
    windowRoot.GroupTransparency = 1
    tween(windowRoot, { GroupTransparency = 0 }, 0.25)
end

toggleButton.Activated:Connect(function()
    if windowRoot.Visible then closeMenu() else openMenu() end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == CONFIG.ToggleKey then
        if windowRoot.Visible then closeMenu() else openMenu() end
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- PÁGINA: INÍCIO
-- ═══════════════════════════════════════════════════════════════════
local pageInicio = createPage("inicio", "Início", 1)

local welcomeSection = createAutoSection(pageInicio, 1)
local welcomeTitle = new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 24),
    BackgroundTransparency = 1,
    Text = "Bem-vindo!",
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.Text,
    TextXAlignment = Enum.TextXAlignment.Left,
    LayoutOrder = 1,
    Parent = welcomeSection,
})
bindTheme(welcomeTitle, "TextColor3", "Text")

local welcomeText = new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    Text = "Este é um sistema de interface moderno e personalizável. Navegue pelas páginas no menu lateral para visualizar informações do jogador, servidor, sessão, personalizar a aparência e ajustar as preferências.",
    TextSize = 14,
    Font = Enum.Font.Gotham,
    TextColor3 = Theme.TextDim,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = true,
    LayoutOrder = 2,
    Parent = welcomeSection,
})
bindTheme(welcomeText, "TextColor3", "TextDim")

local tipsSection = createAutoSection(pageInicio, 2)
createSectionHeader(tipsSection, "Dicas rápidas", 1)
local tipsText = new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    Text = "• Arraste a barra de título para mover o menu.\n• Use − para minimizar, □ para maximizar e × para fechar.\n• Pressione F2 para reabrir o menu a qualquer momento.\n• Personalize as cores na página Aparência.",
    TextSize = 13,
    Font = Enum.Font.Gotham,
    TextColor3 = Theme.TextDim,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = true,
    LayoutOrder = 2,
    Parent = tipsSection,
})
bindTheme(tipsText, "TextColor3", "TextDim")

-- ═══════════════════════════════════════════════════════════════════
-- PÁGINA: JOGADOR
-- ═══════════════════════════════════════════════════════════════════
local pageJogador = createPage("jogador", "Jogador", 2)
local jogSection = createAutoSection(pageJogador, 1)
createSectionHeader(jogSection, "Informações do Jogador", 1)
local playerLabels = {}
playerLabels.name        = createInfoRow(jogSection, "Nome",        2)
playerLabels.displayName = createInfoRow(jogSection, "DisplayName", 3)
playerLabels.userId      = createInfoRow(jogSection, "UserId",      4)
playerLabels.state       = createInfoRow(jogSection, "Estado",      5)

-- ═══════════════════════════════════════════════════════════════════
-- PÁGINA: SERVIDOR
-- ═══════════════════════════════════════════════════════════════════
local pageServidor = createPage("servidor", "Servidor", 3)
local srvSection = createAutoSection(pageServidor, 1)
createSectionHeader(srvSection, "Informações do Servidor", 1)
local serverLabels = {}
serverLabels.experience  = createInfoRow(srvSection, "Experiência", 2)
serverLabels.placeId     = createInfoRow(srvSection, "PlaceId",     3)
serverLabels.jobId       = createInfoRow(srvSection, "JobId",       4)
serverLabels.playerCount = createInfoRow(srvSection, "Jogadores",   5)

-- ═══════════════════════════════════════════════════════════════════
-- PÁGINA: INFORMAÇÕES
-- ═══════════════════════════════════════════════════════════════════
local pageInfo = createPage("info", "Informações", 4)
local infoSection = createAutoSection(pageInfo, 1)
createSectionHeader(infoSection, "Sessão", 1)
local sessionLabels = {}
sessionLabels.entryTime   = createInfoRow(infoSection, "Entrada",         2)
sessionLabels.sessionTime = createInfoRow(infoSection, "Tempo de sessão", 3)
sessionLabels.currentTime = createInfoRow(infoSection, "Horário atual",   4)

local posSection = createAutoSection(pageInfo, 2)
createSectionHeader(posSection, "Personagem", 1)
local posLabels = {}
posLabels.position = createInfoRow(posSection, "Posição (X, Y, Z)", 2)
posLabels.state    = createInfoRow(posSection, "Estado",            3)

-- ═══════════════════════════════════════════════════════════════════
-- PÁGINA: APARÊNCIA
-- ═══════════════════════════════════════════════════════════════════
local pageAparencia = createPage("aparencia", "Aparência", 5)

local presetsSection = createAutoSection(pageAparencia, 1)
createSectionHeader(presetsSection, "Paletas predefinidas", 1)

local presetRow = new("Frame", {
    Size = UDim2.new(1, 0, 0, 36),
    BackgroundTransparency = 1,
    LayoutOrder = 2,
    Parent = presetsSection,
})
new("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Parent = presetRow,
})

local presetPalettes = {
    { name = "Azul",     colors = { Primary = Color3.fromRGB(45,125,210),  Background = Color3.fromRGB(28,28,34),  Surface = Color3.fromRGB(38,38,46),  Button = Color3.fromRGB(52,52,62),  Border = Color3.fromRGB(72,72,84)   } },
    { name = "Vermelho", colors = { Primary = Color3.fromRGB(200,50,50),   Background = Color3.fromRGB(34,22,22),  Surface = Color3.fromRGB(46,32,32),  Button = Color3.fromRGB(62,44,44),  Border = Color3.fromRGB(84,60,60)   } },
    { name = "Roxo",     colors = { Primary = Color3.fromRGB(140,70,200),  Background = Color3.fromRGB(28,22,38),  Surface = Color3.fromRGB(38,32,50),  Button = Color3.fromRGB(54,46,68),  Border = Color3.fromRGB(78,66,94)   } },
    { name = "Verde",    colors = { Primary = Color3.fromRGB(50,170,100),  Background = Color3.fromRGB(20,30,24),  Surface = Color3.fromRGB(30,42,34),  Button = Color3.fromRGB(42,58,48),  Border = Color3.fromRGB(60,82,68)   } },
    { name = "Preto",    colors = { Primary = Color3.fromRGB(20,20,20),    Background = Color3.fromRGB(14,14,14),  Surface = Color3.fromRGB(22,22,22),  Button = Color3.fromRGB(32,32,32),  Border = Color3.fromRGB(48,48,48)   } },
    { name = "Branco",   colors = { Primary = Color3.fromRGB(200,200,210), Background = Color3.fromRGB(240,240,245), Surface = Color3.fromRGB(230,230,235), Button = Color3.fromRGB(215,215,222), Border = Color3.fromRGB(180,180,190) } },
}

local updateColorEditorSliders

for i, preset in ipairs(presetPalettes) do
    local btn = new("TextButton", {
        Size = UDim2.fromOffset(36, 36),
        BackgroundColor3 = preset.colors.Primary,
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = i,
        Parent = presetRow,
    })
    new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = btn })
    new("UIStroke", { Color = Theme.Border, Thickness = 2, Parent = btn })

    btn.Activated:Connect(function()
        for k, v in pairs(preset.colors) do Theme[k] = v end
        applyTheme()
        if updateColorEditorSliders then updateColorEditorSliders() end
    end)
end

local editorSection = createAutoSection(pageAparencia, 2)
createSectionHeader(editorSection, "Cor personalizada", 1)

local targetRow = new("Frame", {
    Size = UDim2.new(1, 0, 0, 34),
    BackgroundTransparency = 1,
    LayoutOrder = 2,
    Parent = editorSection,
})
new("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = targetRow,
})

local colorTargets = {
    { key = "Primary",    name = "Destaque" },
    { key = "Background", name = "Fundo"    },
    { key = "Button",     name = "Botões"   },
    { key = "Border",     name = "Bordas"   },
}
local selectedTarget = "Primary"
local targetButtons   = {}

local function updateTargetButtons()
    for key, btn in pairs(targetButtons) do
        btn.BackgroundColor3 = (key == selectedTarget) and Theme.Primary or Theme.Button
    end
end
onThemeChanged(updateTargetButtons)

for i, t in ipairs(colorTargets) do
    local btn = new("TextButton", {
        Size = UDim2.fromOffset(86, 30),
        BackgroundColor3 = Theme.Button,
        Text = t.name,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.Text,
        AutoButtonColor = false,
        LayoutOrder = i,
        Parent = targetRow,
    })
    new("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
    bindTheme(btn, "TextColor3", "Text")
    targetButtons[t.key] = btn

    btn.Activated:Connect(function()
        selectedTarget = t.key
        updateTargetButtons()
        if updateColorEditorSliders then updateColorEditorSliders() end
    end)
end

local previewRow = new("Frame", {
    Size = UDim2.new(1, 0, 0, 28),
    BackgroundTransparency = 1,
    LayoutOrder = 3,
    Parent = editorSection,
})
local previewLabel = new("TextLabel", {
    Size = UDim2.new(1, -80, 1, 0),
    BackgroundTransparency = 1,
    Text = "Prévia:",
    TextSize = 13,
    Font = Enum.Font.GothamMedium,
    TextColor3 = Theme.TextDim,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = previewRow,
})
bindTheme(previewLabel, "TextColor3", "TextDim")
local previewSwatch = new("Frame", {
    Size = UDim2.fromOffset(64, 22),
    Position = UDim2.new(1, -64, 0.5, 0),
    AnchorPoint = Vector2.new(0, 0.5),
    BackgroundColor3 = Theme[selectedTarget],
    BorderSizePixel = 0,
    Parent = previewRow,
})
new("UICorner", { CornerRadius = UDim.new(0, 5), Parent = previewSwatch })
new("UIStroke", { Color = Theme.Border, Thickness = 1, Parent = previewSwatch })

local colorSliders = {}

local function applyCustomColor()
    local c = Color3.fromRGB(
        colorSliders.R.getValue(),
        colorSliders.G.getValue(),
        colorSliders.B.getValue()
    )
    Theme[selectedTarget] = c
    previewSwatch.BackgroundColor3 = c
    applyTheme()
end

colorSliders.R = createSlider(editorSection, "R", 4, applyCustomColor)
colorSliders.G = createSlider(editorSection, "G", 5, applyCustomColor)
colorSliders.B = createSlider(editorSection, "B", 6, applyCustomColor)

updateColorEditorSliders = function()
    local c = Theme[selectedTarget]
    local r = math.floor(c.R * 255 + 0.5)
    local g = math.floor(c.G * 255 + 0.5)
    local b = math.floor(c.B * 255 + 0.5)
    colorSliders.R.set(r, false)
    colorSliders.G.set(g, false)
    colorSliders.B.set(b, false)
    previewSwatch.BackgroundColor3 = c
end
updateColorEditorSliders()

-- ═══════════════════════════════════════════════════════════════════
-- PÁGINA: CRIADOR
-- ═══════════════════════════════════════════════════════════════════
local pageCriador = createPage("criador", "Criador", 6)
local creatorSection = createAutoSection(pageCriador, 1)
createSectionHeader(creatorSection, "Sobre o Criador", 1)
local creatorLabels = {}
creatorLabels.name    = createInfoRow(creatorSection, "Criador",  2)
creatorLabels.version = createInfoRow(creatorSection, "Versão",   3)
creatorLabels.credits = createInfoRow(creatorSection, "Créditos", 4)

creatorLabels.name.Text    = CONFIG.CreatorName
creatorLabels.version.Text = "v" .. CONFIG.Version
creatorLabels.credits.Text = CONFIG.Credits

local descSection = createAutoSection(pageCriador, 2)
createSectionHeader(descSection, "Descrição", 1)
local descLabel = new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    Text = CONFIG.Description,
    TextSize = 13,
    Font = Enum.Font.Gotham,
    TextColor3 = Theme.TextDim,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = true,
    LayoutOrder = 2,
    Parent = descSection,
})
bindTheme(descLabel, "TextColor3", "TextDim")

-- ═══════════════════════════════════════════════════════════════════
-- PÁGINA: CONFIGURAÇÕES
-- ═══════════════════════════════════════════════════════════════════
local pageConfig = createPage("config", "Configurações", 7)
local cfgSection = createAutoSection(pageConfig, 1)
createSectionHeader(cfgSection, "Interface", 1)

createToggle(cfgSection, "Animações", Settings.AnimationsEnabled, 2, function(v)
    Settings.AnimationsEnabled = v
end)

createToggle(cfgSection, "Sombra da janela", Settings.ShadowEnabled, 3, function(v)
    Settings.ShadowEnabled = v
    if windowState ~= "maximized" and windowState ~= "minimized" then
        shadow.Visible = v
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- NAVEGAÇÃO
-- ═══════════════════════════════════════════════════════════════════
addNav("inicio",    "⌂", "Início",        1)
addNav("jogador",   "☺", "Jogador",       2)
addNav("servidor",  "▣", "Servidor",      3)
addNav("info",      "⏱", "Informações",   4)
addNav("aparencia", "✦", "Aparência",     5)
addNav("criador",   "★", "Criador",       6)
addNav("config",    "⚙", "Configurações", 7)

showPage("inicio")

-- ═══════════════════════════════════════════════════════════════════
-- ATUALIZAÇÃO DE DADOS
-- ═══════════════════════════════════════════════════════════════════
local experienceName = game.Name
task.spawn(function()
    local ok, info = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    if ok and info and info.Name then
        experienceName = info.Name
        if serverLabels.experience then
            serverLabels.experience.Text = experienceName
        end
    end
end)

local function getCharacterInfo()
    local char = LocalPlayer.Character
    if not char then return nil, "Sem personagem" end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local pos = hrp and hrp.Position or nil
    local hum = char:FindFirstChildOfClass("Humanoid")
    local state = "—"
    if hum then
        local ok, s = pcall(function() return hum:GetState() end)
        if ok and s then
            state = tostring(s):gsub("Enum.HumanoidStateType.", "")
        end
    end
    return pos, state
end

playerLabels.name.Text        = LocalPlayer.Name
playerLabels.displayName.Text = LocalPlayer.DisplayName
playerLabels.userId.Text      = tostring(LocalPlayer.UserId)
serverLabels.experience.Text  = experienceName
serverLabels.placeId.Text     = tostring(game.PlaceId)
serverLabels.jobId.Text       = game.JobId ~= "" and game.JobId or "(Studio)"

local function updateAllInfo()
    playerLabels.name.Text        = LocalPlayer.Name
    playerLabels.displayName.Text = LocalPlayer.DisplayName
    playerLabels.userId.Text      = tostring(LocalPlayer.UserId)

    local pos, charState = getCharacterInfo()
    playerLabels.state.Text = charState
    posLabels.state.Text    = charState
    if pos then
        posLabels.position.Text = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
    else
        posLabels.position.Text = "—"
    end

    serverLabels.experience.Text  = experienceName
    serverLabels.placeId.Text     = tostring(game.PlaceId)
    serverLabels.jobId.Text       = game.JobId ~= "" and game.JobId or "(Studio)"
    serverLabels.playerCount.Text = tostring(#Players:GetPlayers())

    sessionLabels.entryTime.Text   = entryTime:FormatLocalTime("HH:mm:ss", "en-us") .. " (local)"
    sessionLabels.sessionTime.Text = formatDuration(os.clock() - sessionStart)

    local now = DateTime.now()
    sessionLabels.currentTime.Text = string.format("%s (Local) · %s (UTC)",
        now:FormatLocalTime("HH:mm:ss", "en-us"),
        now:FormatUniversalTime("HH:mm:ss", "en-us"))
end

updateAllInfo()

local updateAccumulator = 0
RunService.Heartbeat:Connect(function(dt)
    if not windowRoot.Visible then return end
    updateAccumulator = updateAccumulator + dt
    if updateAccumulator < 0.25 then return end
    updateAccumulator = 0
    pcall(updateAllInfo)
end)

-- ═══════════════════════════════════════════════════════════════════
-- RESPONSIVIDADE
-- ═══════════════════════════════════════════════════════════════════
local function clampWindowToViewport()
    if not Workspace.CurrentCamera then return end
    local vp = Workspace.CurrentCamera.ViewportSize
    local maxW = math.max(380, vp.X - 40)
    local maxH = math.max(260, vp.Y - 40)
    local sz = windowRoot.AbsoluteSize
    if sz.X > maxW or sz.Y > maxH then
        windowRoot.Size = UDim2.fromOffset(math.min(sz.X, maxW), math.min(sz.Y, maxH))
    end
end

if Workspace.CurrentCamera then
    Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(clampWindowToViewport)
end

-- ═══════════════════════════════════════════════════════════════════
-- ANIMAÇÃO DE ABERTURA
-- ═══════════════════════════════════════════════════════════════════
do
    local targetSize = windowRoot.Size
    if Settings.AnimationsEnabled then
        windowRoot.Size = UDim2.new(
            targetSize.X.Scale * 0.85, targetSize.X.Offset * 0.85,
            targetSize.Y.Scale * 0.85, targetSize.Y.Offset * 0.85
        )
        windowRoot.GroupTransparency = 1
        TweenService:Create(windowRoot, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = targetSize,
            GroupTransparency = 0,
        }):Play()
    end
end
