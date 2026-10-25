local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Config = require(script.Parent.Config)
local ThemeModule = require(script.Parent.Theme)
local Helpers = require(script.Parent.Helpers)
local UI = require(script.Parent.UI.Components)

local Theme = ThemeModule.Theme

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Helpers.new("ScreenGui", {
    Name = "ModernMenuGui",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = playerGui,
})

local windowRoot = Helpers.new("Frame", {
    Name = "WindowRoot",
    Size = UDim2.fromOffset(780, 520),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundTransparency = 1,
    Parent = screenGui,
})

local shadow = Helpers.new("Frame", {
    Name = "Shadow",
    Size = UDim2.fromScale(1, 1),
    Position = UDim2.fromOffset(0, 8),
    BackgroundColor3 = Color3.new(0, 0, 0),
    BackgroundTransparency = 0.55,
    BorderSizePixel = 0,
    ZIndex = 1,
    Parent = windowRoot,
})
Helpers.new("UICorner", { CornerRadius = UDim.new(0, 12), Parent = shadow })

local mainFrame = Helpers.new("Frame", {
    Name = "MainWindow",
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    ZIndex = 2,
    Parent = windowRoot,
})
ThemeModule.bindTheme(mainFrame, "BackgroundColor3", "Background")
Helpers.new("UICorner", { CornerRadius = UDim.new(0, 12), Parent = mainFrame })
Helpers.new("UIStroke", { Color = Theme.Border, Thickness = 1, Parent = mainFrame })

local titleBar = Helpers.new("Frame", {
    Name = "TitleBar",
    Size = UDim2.new(1, 0, 0, 44),
    BackgroundColor3 = Theme.Primary,
    BorderSizePixel = 0,
    Parent = mainFrame,
})
ThemeModule.bindTheme(titleBar, "BackgroundColor3", "Primary")

local titleLabel = Helpers.new("TextLabel", {
    Size = UDim2.new(1, -20, 1, 0),
    Position = UDim2.fromOffset(16, 0),
    BackgroundTransparency = 1,
    Text = "Menu Principal",
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.Text,
    Parent = titleBar,
})
ThemeModule.bindTheme(titleLabel, "TextColor3", "Text")

local contentRoot = Helpers.new("Frame", {
    Name = "ContentRoot",
    Size = UDim2.new(1, 0, 1, -44),
    Position = UDim2.new(0, 0, 0, 44),
    BackgroundTransparency = 1,
    Parent = mainFrame,
})

local sidebar = Helpers.new("Frame", {
    Name = "Sidebar",
    Size = UDim2.new(0, 180, 1, 0),
    BackgroundColor3 = Theme.Surface,
    BorderSizePixel = 0,
    Parent = contentRoot,
})
ThemeModule.bindTheme(sidebar, "BackgroundColor3", "Surface")

local pagesArea = Helpers.new("Frame", {
    Name = "PagesArea",
    Size = UDim2.new(1, -180, 1, 0),
    Position = UDim2.new(0, 180, 0, 0),
    BackgroundTransparency = 1,
    Parent = contentRoot,
})

local pages = {}
local navButtons = {}
local activePageId = "inicio"

local function addPage(id, title)
    local page = Helpers.new("ScrollingFrame", {
        Name = "Page_" .. id,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 6,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = pagesArea,
    })

    Helpers.new("UIPadding", {
        PaddingLeft = UDim.new(0, 16),
        PaddingRight = UDim.new(0, 16),
        PaddingTop = UDim.new(0, 16),
        PaddingBottom = UDim.new(0, 16),
        Parent = page,
    })

    Helpers.new("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = page,
    })

    local titleText = Helpers.new("TextLabel", {
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
    ThemeModule.bindTheme(titleText, "TextColor3", "Text")

    pages[id] = page
    return page
end

local function updateNavHighlight()
    for id, btn in pairs(navButtons) do
        btn.BackgroundColor3 = (id == activePageId) and Theme.Primary or Theme.Button
    end
end

ThemeModule.onThemeChanged(updateNavHighlight)

local function showPage(id)
    activePageId = id
    for pageId, page in pairs(pages) do
        page.Visible = (pageId == id)
    end
    updateNavHighlight()
end

local function createNavButton(id, title)
    local btn = Helpers.new("TextButton", {
        Name = "Nav_" .. id,
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Theme.Button,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = sidebar,
    })

    Helpers.new("UICorner", { CornerRadius = UDim.new(0, 8), Parent = btn })

    local label = Helpers.new("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.fromOffset(12, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = btn,
    })
    ThemeModule.bindTheme(label, "TextColor3", "Text")

    btn.Activated:Connect(function()
        showPage(id)
    end)

    navButtons[id] = btn
    return btn
end

Helpers.new("UIListLayout", {
    Padding = UDim.new(0, 4),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = sidebar,
})

local pageInicio = addPage("inicio", "Início")
local pageJogador = addPage("jogador", "Jogador")
local pageServidor = addPage("servidor", "Servidor")
local pageAparencia = addPage("aparencia", "Aparência")

local inicioSection = UI.createAutoSection(pageInicio, 1)
UI.createSectionHeader(inicioSection, "Bem-vindo!", 1)

local welcomeText = Helpers.new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    Text = "Este sistema foi organizado em módulos para facilitar leitura, manutenção e extensão.",
    TextSize = 14,
    Font = Enum.Font.Gotham,
    TextColor3 = Theme.TextDim,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = true,
    LayoutOrder = 2,
    Parent = inicioSection,
})
ThemeModule.bindTheme(welcomeText, "TextColor3", "TextDim")

local jogadorSection = UI.createAutoSection(pageJogador, 1)
UI.createSectionHeader(jogadorSection, "Informações do jogador", 1)
local jogadorNome = UI.createInfoRow(jogadorSection, "Nome", 2)
local jogadorDisplay = UI.createInfoRow(jogadorSection, "DisplayName", 3)
local jogadorId = UI.createInfoRow(jogadorSection, "UserId", 4)

local servidorSection = UI.createAutoSection(pageServidor, 1)
UI.createSectionHeader(servidorSection, "Informações do servidor", 1)
local placeId = UI.createInfoRow(servidorSection, "PlaceId", 2)
local jobId = UI.createInfoRow(servidorSection, "JobId", 3)
local playersCount = UI.createInfoRow(servidorSection, "Jogadores", 4)

local aparenciaSection = UI.createAutoSection(pageAparencia, 1)
UI.createSectionHeader(aparenciaSection, "Aparência", 1)
UI.createToggle(aparenciaSection, "Animações", true, 2, function(value)
    -- custom callback
end)

createNavButton("inicio", "Início")
createNavButton("jogador", "Jogador")
createNavButton("servidor", "Servidor")
createNavButton("aparencia", "Aparência")

local function updateInfo()
    local playerName = player.DisplayName
    local playerUserId = tostring(player.UserId)
    local serverPlaceId = tostring(game.PlaceId)
    local serverJobId = tostring(game.JobId)
    local count = tostring(#Players:GetPlayers())

    jogadorNome.Text = player.Name
    jogadorDisplay.Text = player.DisplayName
    jogadorId.Text = playerUserId
    placeId.Text = serverPlaceId
    jobId.Text = serverJobId
    playersCount.Text = count
end

updateInfo()
showPage("inicio")

Players.PlayerAdded:Connect(function()
    updateInfo()
end)

Players.PlayerRemoving:Connect(function()
    updateInfo()
end)

local toggleButton = Helpers.new("TextButton", {
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
Helpers.new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = toggleButton })
ThemeModule.bindTheme(toggleButton, "BackgroundColor3", "Primary")

local function closeMenu()
    windowRoot.Visible = false
    toggleButton.Visible = true
end

local function openMenu()
    toggleButton.Visible = false
    windowRoot.Visible = true
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then
        return
    end

    if input.KeyCode == Config.ToggleKey then
        if windowRoot.Visible then
            closeMenu()
        else
            openMenu()
        end
    end
end)

toggleButton.Activated:Connect(function()
    if windowRoot.Visible then
        closeMenu()
    else
        openMenu()
    end
end)

print("[script.ia] Interface inicializada.")

return screenGui
