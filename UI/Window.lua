local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Tabs = loadstring(game:HttpGet("https://raw.githubusercontent.com/AuXDeVs/Roblox-Liblary-/refs/heads/main/UI/Tabs.lua"))()

local Window = {}
Window.__index = Window

function Window:new(title, size, theme)
    local self = setmetatable({}, Window)
    
    self.theme = theme
    self.title = title or "Window"
    
    local isMobile = GuiService:IsTenFootInterface() or game:GetService("UserInputService").TouchEnabled
    
    if size then
        self.size = size
    elseif isMobile then
        
        self.size = UDim2.new(0.95, 0, 0.8, 0) 
    else
        
        self.size = UDim2.new(0, 600, 0, 400)
    end
    
    self.minimized = false
    self.originalSize = self.size
    
    self:create()
    return self
end

function Window:corner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or self.theme.cornerRadius
    corner.Parent = parent
    return corner
end

function Window:stroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or self.theme.colors.border
    stroke.Thickness = thickness or self.theme.borderSize
    stroke.Parent = parent
    return stroke
end

function Window:tween(obj, props, time)
    local info = TweenInfo.new(
        time or self.theme.animTime,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

function Window:create()
    local gui = PlayerGui:FindFirstChild("ModernUI")
    if not gui then
        gui = Instance.new("ScreenGui")
        gui.Name = "ModernUI"
        gui.Parent = PlayerGui
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    end
    
    local frame = Instance.new("Frame")
    frame.Name = "Window"
    frame.Size = self.size
    
    if self.size.X.Scale > 0 then
        
        frame.Position = UDim2.new(0.5, 0, 0.5, 0)
        frame.AnchorPoint = Vector2.new(0.5, 0.5)
    else
        
        frame.Position = UDim2.new(0.5, -self.size.X.Offset/2, 0.5, -self.size.Y.Offset/2)
    end
    frame.BackgroundColor3 = self.theme.colors.primary
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui
    
    self:corner(frame)
    self:stroke(frame, self.theme.colors.border, 2)

    local titlebarHeight = game:GetService("UserInputService").TouchEnabled and 40 or 35
    
    local titlebar = Instance.new("Frame")
    titlebar.Name = "Titlebar"
    titlebar.Size = UDim2.new(1, 0, 0, titlebarHeight)
    titlebar.Position = UDim2.new(0, 0, 0, 0)
    titlebar.BackgroundColor3 = self.theme.colors.secondary
    titlebar.BorderSizePixel = 0
    titlebar.Parent = frame
    
    self:corner(titlebar)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -80, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = self.title
    titleLabel.TextColor3 = self.theme.colors.text
    titleLabel.TextScaled = true
    titleLabel.Font = self.theme.font
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titlebar
    
    local buttonSize = game:GetService("UserInputService").TouchEnabled and 30 or 25
    
    local minimize = Instance.new("TextButton")
    minimize.Name = "Minimize"
    minimize.Size = UDim2.new(0, buttonSize, 0, buttonSize)
    minimize.Position = UDim2.new(1, -(buttonSize * 2 + 10), 0, (titlebarHeight - buttonSize) / 2)
    minimize.BackgroundColor3 = self.theme.colors.warning
    minimize.Text = "−"
    minimize.TextColor3 = self.theme.colors.text
    minimize.TextScaled = true
    minimize.Font = self.theme.font
    minimize.BorderSizePixel = 0
    minimize.Parent = titlebar
    
    self:corner(minimize, UDim.new(0, 3))
    
    local close = Instance.new("TextButton")
    close.Name = "Close"
    close.Size = UDim2.new(0, buttonSize, 0, buttonSize)
    close.Position = UDim2.new(1, -(buttonSize + 5), 0, (titlebarHeight - buttonSize) / 2)
    close.BackgroundColor3 = self.theme.colors.accent
    close.Text = "×"
    close.TextColor3 = self.theme.colors.text
    close.TextScaled = true
    close.Font = self.theme.font
    close.BorderSizePixel = 0
    close.Parent = titlebar
    
    self:corner(close, UDim.new(0, 3))
    
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -20, 1, -(titlebarHeight + 10))
    content.Position = UDim2.new(0, 10, 0, titlebarHeight + 5)
    content.BackgroundTransparency = 1
    content.Parent = frame
    
    local tabs = Tabs:new(content, self.theme)
    
    self.frame = frame
    self.content = content
    self.titleLabel = titleLabel
    self.close = close
    self.minimize = minimize
    self.tabs = tabs
    self.titlebarHeight = titlebarHeight
    
    self:events()
end

function Window:events()
    self.minimize.MouseButton1Click:Connect(function()
        if not self.minimized then
            local minSize = self.size.X.Scale > 0 and UDim2.new(self.originalSize.X.Scale, 0, 0, self.titlebarHeight) or UDim2.new(0, self.originalSize.X.Offset, 0, self.titlebarHeight)
            self:tween(self.frame, {Size = minSize})
            self.content.Visible = false
            self.minimize.Text = "□"
            self.minimized = true
        else
            self:tween(self.frame, {Size = self.originalSize})
            self.content.Visible = true
            self.minimize.Text = "−"
            self.minimized = false
        end
    end)
    
    self.close.MouseButton1Click:Connect(function()
        self:destroy()
    end)
    
    self.close.MouseEnter:Connect(function()
        self:tween(self.close, {BackgroundColor3 = self.theme.colors.accentHover})
    end)
    
    self.close.MouseLeave:Connect(function()
        self:tween(self.close, {BackgroundColor3 = self.theme.colors.accent})
    end)
    
    self.minimize.MouseEnter:Connect(function()
        self:tween(self.minimize, {BackgroundColor3 = Color3.fromRGB(255, 200, 0)})
    end)
    
    self.minimize.MouseLeave:Connect(function()
        self:tween(self.minimize, {BackgroundColor3 = self.theme.colors.warning})
    end)
end

function Window:addTab(name)
    return self.tabs:addTab(name)
end

function Window:selectTab(name)
    self.tabs:selectTab(name)
end

function Window:setTitle(text)
    self.title = text
    self.titleLabel.Text = text
end

function Window:destroy()
    if self.frame then
        self.frame:Destroy()
    end
end

function Window:hide()
    if self.frame then
        self.frame.Visible = false
    end
end

function Window:show()
    if self.frame then
        self.frame.Visible = true
    end
end

return Window
