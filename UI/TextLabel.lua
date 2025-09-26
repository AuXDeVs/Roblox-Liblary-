local TweenService = game:GetService("TweenService")

local TextLabel = {}
TextLabel.__index = TextLabel

function TextLabel:new(text, pos, size, parent, theme)
    local self = setmetatable({}, TextLabel)
    
    self.theme = theme
    self.text = text or "Label"
    self.pos = pos or UDim2.new(0, 10, 0, 10)
    self.size = size or UDim2.new(0, 200, 0, 30)
    self.parent = parent
    
    self:create()
    return self
end

function TextLabel:corner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or self.theme.cornerRadius
    corner.Parent = parent
    return corner
end

function TextLabel:stroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or self.theme.colors.border
    stroke.Thickness = thickness or self.theme.borderSize
    stroke.Parent = parent
    return stroke
end

function TextLabel:tween(obj, props, time)
    local info = TweenInfo.new(
        time or self.theme.animTime,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

function TextLabel:create()
    local frame = Instance.new("Frame")
    frame.Name = "LabelFrame"
    frame.Size = self.size
    frame.Position = self.pos
    frame.BackgroundColor3 = self.theme.colors.secondary
    frame.BorderSizePixel = 0
    frame.Parent = self.parent
    
    self:corner(frame)
    self:stroke(frame, self.theme.colors.border, 1)
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -10, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = self.text
    label.TextColor3 = self.theme.colors.text
    label.TextScaled = true
    label.Font = self.theme.font
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = frame
    
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 4, 1, 4)
    shadow.Position = UDim2.new(0, -2, 0, -2)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.8
    shadow.ZIndex = frame.ZIndex - 1
    shadow.Parent = frame
    
    self:corner(shadow)
    
    self.frame = frame
    self.label = label
end

function TextLabel:setText(text, anim)
    if anim then
        self:tween(self.label, {TextTransparency = 1})
        wait(self.theme.animTime)
        self.text = text
        self.label.Text = text
        self:tween(self.label, {TextTransparency = 0})
    else
        self.text = text
        self.label.Text = text
    end
end

function TextLabel:setColor(color)
    self.label.TextColor3 = color
end

function TextLabel:setBackground(color)
    self.frame.BackgroundColor3 = color
end

function TextLabel:highlight(color)
    local col = color or self.theme.colors.accent
    local original = self.frame.BackgroundColor3
    
    self:tween(self.frame, {BackgroundColor3 = col})
    
    spawn(function()
        wait(0.5)
        self:tween(self.frame, {BackgroundColor3 = original})
    end)
end

function TextLabel:pulse()
    local original = self.frame.Size
    self:tween(self.frame, {Size = UDim2.new(original.X.Scale, original.X.Offset + 10, original.Y.Scale, original.Y.Offset + 5)})
    
    spawn(function()
        wait(self.theme.animTime)
        self:tween(self.frame, {Size = original})
    end)
end

function TextLabel:show()
    self.frame.Visible = true
end

function TextLabel:hide()
    self.frame.Visible = false
end

function TextLabel:destroy()
    if self.frame then
        self.frame:Destroy()
    end
end

return TextLabel
