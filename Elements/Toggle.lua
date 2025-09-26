local TweenService = game:GetService("TweenService")

local Toggle = {}
Toggle.__index = Toggle

function Toggle:new(pos, size, parent, theme, state)
    local self = setmetatable({}, Toggle)
    
    self.theme = theme
    self.pos = pos or UDim2.new(0, 10, 0, 10)
    self.size = size or UDim2.new(0, 60, 0, 30)
    self.parent = parent
    self.state = state or false
    self.callback = nil
    self.enabled = true
    
    self:create()
    return self
end

function Toggle:corner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or UDim.new(0, 15)
    corner.Parent = parent
    return corner
end

function Toggle:stroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or self.theme.colors.border
    stroke.Thickness = thickness or self.theme.borderSize
    stroke.Parent = parent
    return stroke
end

function Toggle:tween(obj, props, time)
    local info = TweenInfo.new(
        time or self.theme.animTime,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

function Toggle:create()
    local bg = Instance.new("TextButton")
    bg.Name = "ToggleBG"
    bg.Size = self.size
    bg.Position = self.pos
    bg.BackgroundColor3 = self.state and self.theme.colors.accent or self.theme.colors.border
    bg.Text = ""
    bg.BorderSizePixel = 0
    bg.AutoButtonColor = false
    bg.Parent = self.parent
    
    self:corner(bg, UDim.new(0, self.size.Y.Offset / 2))
    
    local switchSize = self.size.Y.Offset - 6
    local switch = Instance.new("Frame")
    switch.Name = "Switch"
    switch.Size = UDim2.new(0, switchSize, 0, switchSize)
    switch.Position = self.state and 
        UDim2.new(0, self.size.X.Offset - switchSize - 3, 0, 3) or 
        UDim2.new(0, 3, 0, 3)
    switch.BackgroundColor3 = self.theme.colors.text
    switch.BorderSizePixel = 0
    switch.Parent = bg
    
    self:corner(switch, UDim.new(0, switchSize / 2))
    
    local glow = Instance.new("Frame")
    glow.Name = "Glow"
    glow.Size = UDim2.new(0, switchSize - 4, 0, switchSize - 4)
    glow.Position = UDim2.new(0, 2, 0, 2)
    glow.BackgroundColor3 = self.state and self.theme.colors.accentHover or self.theme.colors.textSecondary
    glow.BackgroundTransparency = 0.7
    glow.BorderSizePixel = 0
    glow.Parent = switch
    
    self:corner(glow, UDim.new(0, (switchSize - 4) / 2))
    
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 4, 1, 4)
    shadow.Position = UDim2.new(0, -2, 0, -2)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.8
    shadow.ZIndex = bg.ZIndex - 1
    shadow.BorderSizePixel = 0
    shadow.Parent = bg
    
    self:corner(shadow, UDim.new(0, self.size.Y.Offset / 2))
    
    self.bg = bg
    self.switch = switch
    self.glow = glow
    self.shadow = shadow
    
    self:events()
end

function Toggle:events()
    self.bg.MouseButton1Click:Connect(function()
        if self.enabled then
            self:setState(not self.state)
            
            if self.callback then
                self.callback(self.state)
            end
        end
    end)
    
    self.bg.MouseEnter:Connect(function()
        if self.enabled then
            self:tween(self.switch, {
                Size = UDim2.new(0, self.size.Y.Offset - 4, 0, self.size.Y.Offset - 4)
            }, 0.1)
            self:tween(self.shadow, {BackgroundTransparency = 0.6})
        end
    end)
    
    self.bg.MouseLeave:Connect(function()
        if self.enabled then
            local switchSize = self.size.Y.Offset - 6
            self:tween(self.switch, {
                Size = UDim2.new(0, switchSize, 0, switchSize)
            }, 0.1)
            self:tween(self.shadow, {BackgroundTransparency = 0.8})
        end
    end)
end

function Toggle:setState(state, anim)
    self.state = state
    local switchSize = self.size.Y.Offset - 6
    
    if anim ~= false then
        self:tween(self.bg, {
            BackgroundColor3 = self.state and self.theme.colors.accent or self.theme.colors.border
        })
        
        self:tween(self.switch, {
            Position = self.state and 
                UDim2.new(0, self.size.X.Offset - switchSize - 3, 0, 3) or 
                UDim2.new(0, 3, 0, 3)
        })
        
        self:tween(self.glow, {
            BackgroundColor3 = self.state and self.theme.colors.accentHover or self.theme.colors.textSecondary
        })
    else
        self.bg.BackgroundColor3 = self.state and self.theme.colors.accent or self.theme.colors.border
        self.switch.Position = self.state and 
            UDim2.new(0, self.size.X.Offset - switchSize - 3, 0, 3) or 
            UDim2.new(0, 3, 0, 3)
        self.glow.BackgroundColor3 = self.state and self.theme.colors.accentHover or self.theme.colors.textSecondary
    end
end

function Toggle:setCallback(func)
    self.callback = func
end

function Toggle:setEnabled(enabled)
    self.enabled = enabled
    if enabled then
        self.bg.BackgroundTransparency = 0
        self.switch.BackgroundTransparency = 0
    else
        self.bg.BackgroundTransparency = 0.5
        self.switch.BackgroundTransparency = 0.5
    end
end

function Toggle:getState()
    return self.state
end

function Toggle:show()
    self.bg.Visible = true
end

function Toggle:hide()
    self.bg.Visible = false
end

function Toggle:destroy()
    if self.bg then
        self.bg:Destroy()
    end
end

return Toggle
