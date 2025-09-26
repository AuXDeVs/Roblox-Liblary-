local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Window = {}
Window.__index = Window

function Window:new(title, size, theme)
    local self = setmetatable({}, Window)
    
    self.theme = theme
    self.title = title or "Window"
    self.size = size or UDim2.new(0, 500, 0, 400)
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
    frame.Position = UDim2.new(0.5, -self.size.X.Offset/2, 0.5, -self.size.Y.Offset/2)
    frame.BackgroundColor3 = self.theme.colors.primary
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui
    
    self:corner(frame)
    self:stroke(frame, self.theme.colors.border, 2)
    
    local titlebar = Instance.new("Frame")
    titlebar.Name = "Titlebar"
    titlebar.Size = UDim2.new(1, 0, 0, 35)
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
    
    local minimize = Instance.new("TextButton")
    minimize.Name = "Minimize"
    minimize.Size = UDim2.new(0, 25, 0, 25)
    minimize.Position = UDim2.new(1, -60, 0, 5)
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
    close.Size = UDim2.new(0, 25, 0, 25)
    close.Position = UDim2.new(1, -30, 0, 5)
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
    content.Size = UDim2.new(1, -20, 1, -45)
    content.Position = UDim2.new(0, 10, 0, 40)
    content.BackgroundTransparency = 1
    content.Parent = frame
    
    self.frame = frame
    self.content = content
    self.titleLabel = titleLabel
    self.close = close
    self.minimize = minimize
    
    self:events()
end

function Window:events()
    self.minimize.MouseButton1Click:Connect(function()
        if not self.minimized then
            self:tween(self.frame, {Size = UDim2.new(0, self.originalSize.X.Offset, 0, 35)})
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
