local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Config = require(script.Parent.Config)
local ThemeModule = require(script.Parent.Theme)
local Helpers = require(script.Parent.Helpers)
local UI = require(script.Parent.UI.Components)

local Theme = ThemeModule.Theme
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Helpers.new("ScreenGui", {
    Name = "ModernBeyStyleGui",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = playerGui,
})

local windowRoot = Helpers.new("Frame", {
    Name = "WindowRoot",
    Size = UDim2.fromOffset(820, 560),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundTransparency = 1,
    Parent = screenGui,
})

local shadow = Helpers.new("Frame", {
    Name = "Shadow",
    Size = UDim2.fromScale(1, 1),
    Position = UDim2.fromOffset(0, 8),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0.42,
    BorderSizePixel = 0,
    ZIndex = 1,
    Parent = windowRoot,
})
Helpers.new("UICorner", { CornerRadius = UDim.new(0, 14), Parent = shadow })

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
Helpers.new("UICorner", { CornerRadius = UDim.new(0, 14), Parent = mainFrame })
Helpers.new("UIStroke", { Color = Theme.Border, Thickness = 1, Parent = mainFrame })

local titleBar = Helpers.new("Frame", {
    Name = "TitleBar",
    Size = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = Theme.Primary,
    BorderSizePixel = 0,
    Parent = mainFrame,
})
ThemeModule.bindTheme(titleBar, "BackgroundColor3", "Primary")

local dragHandle = Helpers.new("Frame", {
    Name = "DragHandle",
    Size = UDim2.new(1, -140, 1, 0),
    BackgroundTransparency = 1,
    Parent = titleBar,
})

local titleLabel = Helpers.new("TextLabel", {
    Size = UDim2.new(1, -20, 1, 0),
    Position = UDim2.fromOffset(16, 0),
    BackgroundTransparency = 1,
    Text = "BeyStyle Menu",
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.Text,
    Parent = dragHandle,
})
ThemeModule.bindTheme(titleLabel, "TextColor3", "Text")

local controlsBar = Helpers.new("Frame", {
    Name = "Controls",
    Size = UDim2.fromOffset(120, 32),
    Position = UDim2.new(1, -10, 0.5, 0),
    AnchorPoint = Vector2.new(1, 0.5),
    BackgroundTransparency = 1,
    Parent = titleBar,
})
Helpers.new("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Padding = UDim.new(0, 4),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = controlsBar,
})

local contentRoot = Helpers.new("Frame", {
    Name = "ContentRoot",
    Size = UDim2.new(1, 0, 1, -48),
    Position = UDim2.new(0, 0, 0, 48),
    BackgroundTransparency = 1,
    Parent = mainFrame,
})

local sidebar = Helpers.new("Frame", {
    Name = "Sidebar",
    Size = UDim2.new(0, 190, 1, 0),
    BackgroundColor3 = Theme.Surface,
    BorderSizePixel = 0,
    Parent = contentRoot,
})
ThemeModule.bindTheme(sidebar, "BackgroundColor3", "Surface")

Helpers.new("UIPadding", {
    PaddingLeft = UDim.new(0, 10),
    PaddingRight = UDim.new(0, 10),
    PaddingTop = UDim.new(0, 10),
    PaddingBottom = UDim.new(0, 10),
    Parent = sidebar,
})

local pagesArea = Helpers.new("Frame", {
    Name = "PagesArea",
    Size = UDim2.new(1, -190, 1, 0),
    Position = UDim2.new(0, 190, 0, 0),
    BackgroundTransparency = 1,
    Parent = contentRoot,
})

local pages = {}
local navButtons = {}
local activePageId = "inicio"

local function createPage(id, title)
    local page = Helpers.new("ScrollingFrame", {
        Name = "Page_" .. id,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 5,
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
        Size = UDim2.new(1, 0, 0, 30),
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

local function refreshNav()
    for id, button in pairs(navButtons) do
        button.BackgroundColor3 = (id == activePageId) and Theme.Primary or Theme.Button
    end
end
ThemeModule.onThemeChanged(refreshNav)

local function showPage(id)
    activePageId = id
    for pageId, page in pairs(pages) do
        page.Visible = (pageId == id)
    end
    refreshNav()
end

local function createNavButton(id, title)
    local button = Helpers.new("TextButton", {
        Name = "Nav_" .. id,
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = Theme.Button,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = sidebar,
    })
    Helpers.new("UICorner", { CornerRadius = UDim.new(0, 10), Parent = button })

    local label = Helpers.new("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.fromOffset(12, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = button,
    })
    ThemeModule.bindTheme(label, "TextColor3", "Text")

    button.Activated:Connect(function()
        showPage(id)
    end)

    navButtons[id] = button
    return button
end

Helpers.new("UIListLayout", {
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = sidebar,
})

local pageDefinitions = {
    { id = "inicio", title = "Início", builder = require(script.Parent.UI.Pages.Inicio) },
    { id = "jogador", title = "Jogador", builder = require(script.Parent.UI.Pages.Jogador) },
    { id = "servidor", title = "Servidor", builder = require(script.Parent.UI.Pages.Servidor) },
    { id = "info", title = "Info", builder = require(script.Parent.UI.Pages.Info) },
    { id = "aparencia", title = "Aparência", builder = require(script.Parent.UI.Pages.Aparencia) },
}

for _, data in ipairs(pageDefinitions) do
    local page = createPage(data.id, data.title)
    data.builder(page)
    createNavButton(data.id, data.title)
end

local function updateInfo()
    local jogadorState = require(script.Parent.UI.Pages.Jogador).__state
    local servidorState = require(script.Parent.UI.Pages.Servidor).__state
    local infoState = require(script.Parent.UI.Pages.Info).__state

    if jogadorState then
        jogadorState.name.Text = player.Name
        jogadorState.displayName.Text = player.DisplayName
        jogadorState.userId.Text = tostring(player.UserId)
        jogadorState.state.Text = "Online"
    end

    if servidorState then
        servidorState.placeId.Text = tostring(game.PlaceId)
        servidorState.jobId.Text = tostring(game.JobId)
        servidorState.playerCount.Text = tostring(#Players:GetPlayers())
    end

    if infoState then
        infoState.entryTime.Text = DateTime.now():FormatLocalTime("DD/MM/YYYY", "pt-BR")
        infoState.currentTime.Text = DateTime.now():FormatLocalTime("HH:mm:ss", "pt-BR")
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos = player.Character.HumanoidRootPart.Position
            infoState.position.Text = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
        else
            infoState.position.Text = "0, 0, 0"
        end
    end
end

for _, data in ipairs(pageDefinitions) do
    local built = data.builder(pages[data.id])
    if built then
        data.builder.__state = built
    end
end

updateInfo()
showPage("inicio")

local function createWindowButton(text, order, hoverColor, callback)
    local button = Helpers.new("TextButton", {
        Size = UDim2.fromOffset(28, 28),
        BackgroundColor3 = Theme.Primary,
        BackgroundTransparency = 0.2,
        Text = text,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.Text,
        AutoButtonColor = false,
        LayoutOrder = order,
        Parent = controlsBar,
    })
    Helpers.new("UICorner", { CornerRadius = UDim.new(0, 8), Parent = button })

    button.MouseEnter:Connect(function()
        Helpers.tween(button, { BackgroundTransparency = 0.02, BackgroundColor3 = hoverColor or Theme.Primary }, 0.12)
    end)
    button.MouseLeave:Connect(function()
        Helpers.tween(button, { BackgroundTransparency = 0.2, BackgroundColor3 = Theme.Primary }, 0.12)
    end)
    button.Activated:Connect(callback)

    return button
end

local windowState = "normal"
local restoreSize = windowRoot.Size
local restorePos = windowRoot.Position
local dragging = false
local dragStartPos = Vector2.zero
local dragStartInput = Vector2.zero

local minimizeWindow = function()
    if windowState == "minimized" then
        windowRoot.Size = restoreSize
        windowRoot.Position = restorePos
        contentRoot.Visible = true
        shadow.Visible = true
        windowState = "normal"
    else
        restoreSize = windowRoot.Size
        restorePos = windowRoot.Position
        local w = windowRoot.AbsoluteSize.X
        windowRoot.Size = UDim2.new(0, w, 0, 48)
        contentRoot.Visible = false
        shadow.Visible = false
        windowState = "minimized"
    end
end

local toggleMaximize = function()
    if windowState == "maximized" then
        windowRoot.Size = restoreSize
        windowRoot.Position = restorePos
        contentRoot.Visible = true
        shadow.Visible = true
        windowState = "normal"
    else
        restoreSize = windowRoot.Size
        restorePos = windowRoot.Position
        windowRoot.Size = UDim2.new(1, -20, 1, -20)
        windowRoot.Position = UDim2.new(0.5, 0, 0.5, 0)
        contentRoot.Visible = true
        shadow.Visible = false
        windowState = "maximized"
    end
end

local closeMenu = function()
    windowRoot.Visible = false
    toggleButton.Visible = true
end

local openMenu = function()
    toggleButton.Visible = false
    windowRoot.Visible = true
end

createWindowButton("−", 1, Theme.Primary, minimizeWindow)
createWindowButton("□", 2, Theme.Primary, toggleMaximize)
createWindowButton("×", 3, Color3.fromRGB(220, 60, 60), closeMenu)

dragHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStartPos = windowRoot.Position
        dragStartInput = input.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartInput
        windowRoot.Position = UDim2.new(dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X, dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local toggleButton = Helpers.new("TextButton", {
    Name = "ToggleButton",
    Size = UDim2.fromOffset(50, 50),
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

toggleButton.Activated:Connect(function()
    if windowRoot.Visible then
        closeMenu()
    else
        openMenu()
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Config.ToggleKey then
        if windowRoot.Visible then
            closeMenu()
        else
            openMenu()
        end
    end
end)

Players.PlayerAdded:Connect(updateInfo)
Players.PlayerRemoving:Connect(updateInfo)

print("[script.ia] Modern menu loaded.")
return screenGui
