local TweenService = game:GetService("TweenService")

local TextBox = {}
TextBox.__index = TextBox

function TextBox:new(placeholder, pos, size, parent, theme)
    local self = setmetatable({}, TextBox)
    
    self.theme = theme
    self.placeholder = placeholder or "Type here..."
    self.pos = pos or UDim2.new(0, 10, 0, 10)
    self.size = size or UDim2.new(0, 200, 0, 35)
    self.parent = parent
    self.text = ""
    self.focused = false
    self.enabled = true
    self.callback = nil
    
    self:create()
    return self
end

function TextBox:corner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or self.theme.cornerRadius
    corner.Parent = parent
    return corner
end

function TextBox:stroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or self.theme.colors.border
    stroke.Thickness = thickness or self.theme.borderSize
    stroke.Parent = parent
    return stroke
end

function TextBox:tween(obj, props, time)
    local info = TweenInfo.new(
        time or self.theme.animTime,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

function TextBox:create()
    local frame = Instance.new("Frame")
    frame.Name = "TextBoxFrame"
    frame.Size = self.size
    frame.Position = self.pos
    frame.BackgroundColor3 = self.theme.colors.secondary
    frame.BorderSizePixel = 0
    frame.Parent = self.parent
    
    self:corner(frame)
    local stroke = self:stroke(frame, self.theme.colors.border, 1)
    
    local textbox = Instance.new("TextBox")
    textbox.Name = "TextBox"
    textbox.Size = UDim2.new(1, -20, 1, 0)
    textbox.Position = UDim2.new(0, 10, 0, 0)
    textbox.BackgroundTransparency = 1
    textbox.Text = ""
    textbox.PlaceholderText = self.placeholder
    textbox.TextColor3 = self.theme.colors.text
    textbox.PlaceholderColor3 = self.theme.colors.textSecondary
    textbox.TextScaled = true
    textbox.Font = self.theme.font
    textbox.TextXAlignment = Enum.TextXAlignment.Left
    textbox.ClearTextOnFocus = false
    textbox.Parent = frame
    
    local indicator = Instance.new("Frame")
    indicator.Name = "FocusIndicator"
    indicator.Size = UDim2.new(0, 0, 0, 2)
    indicator.Position = UDim2.new(0, 0, 1, -2)
    indicator.BackgroundColor3 = self.theme.colors.accent
    indicator.BorderSizePixel = 0
    indicator.Parent = frame
    
    self:corner(indicator, UDim.new(0, 1))
    
    local dot = Instance.new("Frame")
    dot.Name = "TypingDot"
    dot.Size = UDim2.new(0, 4, 0, 4)
    dot.Position = UDim2.new(1, -10, 0.5, -2)
    dot.BackgroundColor3 = self.theme.colors.accent
    dot.BorderSizePixel = 0
    dot.BackgroundTransparency = 1
    dot.Parent = frame
    
    self:corner(dot, UDim.new(0, 2))
    
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 4, 1, 4)
    shadow.Position = UDim2.new(0, -2, 0, -2)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.9
    shadow.ZIndex = frame.ZIndex - 1
    shadow.BorderSizePixel = 0
    shadow.Parent = frame
    
    self:corner(shadow)
    
    self.frame = frame
    self.textbox = textbox
    self.indicator = indicator
    self.dot = dot
    self.shadow = shadow
    self.stroke = stroke
    
    self:events()
end

function TextBox:events()
    self.textbox.Focused:Connect(function()
        if self.enabled then
            self.focused = true
            
            self:tween(self.indicator, {Size = UDim2.new(1, 0, 0, 2)})
            self:tween(self.stroke, {Color = self.theme.colors.accent})
            self:tween(self.shadow, {BackgroundTransparency = 0.7})
            self:tween(self.dot, {BackgroundTransparency = 0})
            self:animate()
        end
    end)
    
    self.textbox.FocusLost:Connect(function(enter)
        self.focused = false
        self.text = self.textbox.Text
        
        self:tween(self.indicator, {Size = UDim2.new(0, 0, 0, 2)})
        self:tween(self.stroke, {Color = self.theme.colors.border})
        self:tween(self.shadow, {BackgroundTransparency = 0.9})
        self:tween(self.dot, {BackgroundTransparency = 1})
        
        if self.callback and enter then
            self.callback(self.text)
        end
    end)
    
    self.textbox:GetPropertyChangedSignal("Text"):Connect(function()
        self.text = self.textbox.Text
    end)
end

function TextBox:animate()
    spawn(function()
        while self.focused do
            self:tween(self.dot, {
                Size = UDim2.new(0, 6, 0, 6),
                Position = UDim2.new(1, -11, 0.5, -3)
            }, 0.3)
            wait(0.3)
            
            if self.focused then
                self:tween(self.dot, {
                    Size = UDim2.new(0, 4, 0, 4),
                    Position = UDim2.new(1, -10, 0.5, -2)
                }, 0.3)
                wait(0.3)
            end
        end
    end)
end

function TextBox:setPlaceholder(text)
    self.placeholder = text
    self.textbox.PlaceholderText = text
end

function TextBox:setText(text)
    self.text = text
    self.textbox.Text = text
end

function TextBox:getText()
    return self.text
end

function TextBox:setCallback(func)
    self.callback = func
end

function TextBox:setEnabled(enabled)
    self.enabled = enabled
    self.textbox.Editable = enabled
    
    if enabled then
        self.frame.BackgroundColor3 = self.theme.colors.secondary
        self.textbox.TextColor3 = self.theme.colors.text
        self.frame.BackgroundTransparency = 0
    else
        self.frame.BackgroundColor3 = self.theme.colors.border
        self.textbox.TextColor3 = self.theme.colors.textSecondary
        self.frame.BackgroundTransparency = 0.5
    end
end

function TextBox:clear()
    self.textbox.Text = ""
    self.text = ""
end

function TextBox:focus()
    self.textbox:CaptureFocus()
end

function TextBox:success()
    local original = self.stroke.Color
    self:tween(self.stroke, {Color = self.theme.colors.success})
    
    spawn(function()
        wait(1)
        self:tween(self.stroke, {Color = original})
    end)
end

function TextBox:error()
    local original = self.stroke.Color
    self:tween(self.stroke, {Color = Color3.fromRGB(220, 53, 69)})
    
    local originalPos = self.frame.Position
    for i = 1, 3 do
        self:tween(self.frame, {Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset + 5, originalPos.Y.Scale, originalPos.Y.Offset)}, 0.05)
        wait(0.05)
        self:tween(self.frame, {Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset - 5, originalPos.Y.Scale, originalPos.Y.Offset)}, 0.05)
        wait(0.05)
    end
    self:tween(self.frame, {Position = originalPos}, 0.05)
    
    spawn(function()
        wait(1)
        self:tween(self.stroke, {Color = original})
    end)
end

function TextBox:show()
    self.frame.Visible = true
end

function TextBox:hide()
    self.frame.Visible = false
end

function TextBox:destroy()
    if self.frame then
        self.frame:Destroy()
    end
end

return TextBox
