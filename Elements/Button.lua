local TweenService = game:GetService("TweenService")

local Button = {}
Button.__index = Button

function Button:new(text, pos, size, parent, theme)
    local self = setmetatable({}, Button)
    
    self.theme = theme
    self.text = text or "Button"
    self.pos = pos or UDim2.new(0, 10, 0, 10)
    self.size = size or UDim2.new(0, 120, 0, 35)
    self.parent = parent
    self.enabled = true
    self.callback = nil
    
    self:create()
    return self
end

function Button:corner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or self.theme.cornerRadius
    corner.Parent = parent
    return corner
end

function Button:stroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or self.theme.colors.border
    stroke.Thickness = thickness or self.theme.borderSize
    stroke.Parent = parent
    return stroke
end

function Button:tween(obj, props, time)
    local info = TweenInfo.new(
        time or self.theme.animTime,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

function Button:create()
    local btn = Instance.new("TextButton")
    btn.Name = "Button"
    btn.Size = self.size
    btn.Position = self.pos
    btn.BackgroundColor3 = self.theme.colors.accent
    btn.Text = self.text
    btn.TextColor3 = self.theme.colors.text
    btn.TextScaled = true
    btn.Font = self.theme.font
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = self.parent
    
    self:corner(btn)
    self:stroke(btn, self.theme.colors.border, 1)
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
    }
    gradient.Rotation = 90
    gradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(1, 0.95)
    }
    gradient.Parent = btn
    
    local effect = Instance.new("Frame")
    effect.Name = "Effect"
    effect.Size = UDim2.new(1, 0, 1, 0)
    effect.Position = UDim2.new(0, 0, 0, 0)
    effect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    effect.BackgroundTransparency = 1
    effect.BorderSizePixel = 0
    effect.Parent = btn
    
    self:corner(effect)
    
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 6, 1, 6)
    shadow.Position = UDim2.new(0, -3, 0, -3)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.7
    shadow.ZIndex = btn.ZIndex - 1
    shadow.BorderSizePixel = 0
    shadow.Parent = btn
    
    self:corner(shadow)
    
    self.btn = btn
    self.effect = effect
    self.shadow = shadow
    
    self:events()
end

function Button:events()
    self.btn.MouseEnter:Connect(function()
        if self.enabled then
            self:tween(self.btn, {
                BackgroundColor3 = self.theme.colors.accentHover,
                Size = UDim2.new(self.size.X.Scale, self.size.X.Offset + 2, self.size.Y.Scale, self.size.Y.Offset + 1)
            })
            self:tween(self.shadow, {BackgroundTransparency = 0.5})
        end
    end)
    
    self.btn.MouseLeave:Connect(function()
        if self.enabled then
            self:tween(self.btn, {
                BackgroundColor3 = self.theme.colors.accent,
                Size = self.size
            })
            self:tween(self.shadow, {BackgroundTransparency = 0.7})
        end
    end)
    
    self.btn.MouseButton1Down:Connect(function()
        if self.enabled then
            self:tween(self.btn, {
                Size = UDim2.new(self.size.X.Scale, self.size.X.Offset - 2, self.size.Y.Scale, self.size.Y.Offset - 1)
            }, 0.1)
            self:tween(self.effect, {BackgroundTransparency = 0.8}, 0.1)
        end
    end)
    
    self.btn.MouseButton1Up:Connect(function()
        if self.enabled then
            self:tween(self.btn, {Size = self.size}, 0.1)
            self:tween(self.effect, {BackgroundTransparency = 1}, 0.2)
            
            if self.callback then
                self.callback()
            end
        end
    end)
end

function Button:setText(text)
    self.text = text
    self.btn.Text = text
end

function Button:setCallback(func)
    self.callback = func
end

function Button:setEnabled(enabled)
    self.enabled = enabled
    if enabled then
        self.btn.BackgroundColor3 = self.theme.colors.accent
        self.btn.TextColor3 = self.theme.colors.text
        self.btn.BackgroundTransparency = 0
    else
        self.btn.BackgroundColor3 = self.theme.colors.border
        self.btn.TextColor3 = self.theme.colors.textSecondary
        self.btn.BackgroundTransparency = 0.5
    end
end

function Button:setColor(color)
    self.btn.BackgroundColor3 = color
end

function Button:success()
    local original = self.btn.BackgroundColor3
    self:tween(self.btn, {BackgroundColor3 = self.theme.colors.success})
    
    spawn(function()
        wait(1)
        self:tween(self.btn, {BackgroundColor3 = original})
    end)
end

function Button:error()
    local original = self.btn.BackgroundColor3
    self:tween(self.btn, {BackgroundColor3 = Color3.fromRGB(220, 53, 69)})
    
    spawn(function()
        wait(1)
        self:tween(self.btn, {BackgroundColor3 = original})
    end)
end

function Button:loading(state)
    if state then
        self.btn.Text = "..."
        self:setEnabled(false)
    else
        self.btn.Text = self.text
        self:setEnabled(true)
    end
end

function Button:show()
    self.btn.Visible = true
end

function Button:hide()
    self.btn.Visible = false
end

function Button:destroy()
    if self.btn then
        self.btn:Destroy()
    end
end

return Button
