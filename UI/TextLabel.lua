local TextLabel = {}
TextLabel.__index = TextLabel

function TextLabel:new(text, pos, size, parent, theme)
    local self = setmetatable({}, TextLabel)
    
    self.theme = theme
    
    local labelFrame = Instance.new("Frame")
    labelFrame.Name = "TextLabel"
    labelFrame.Size = UDim2.new(1, -20, 0, 40)
    labelFrame.Position = UDim2.new(0, 10, 25, pos and pos.Y.Offset or 0)
    labelFrame.BackgroundColor3 = theme.colors.secondary
    labelFrame.BorderSizePixel = 0
    labelFrame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = labelFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.colors.border
    stroke.Thickness = 1
    stroke.Parent = labelFrame
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -24, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = theme.colors.text
    label.TextSize = 14
    label.Font = theme.font
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = labelFrame
    
    self.label = label
    self.labelFrame = labelFrame
    return self
end

function TextLabel:setText(text)
    self.label.Text = text
end

function TextLabel:setTextColor(color)
    self.label.TextColor3 = color
end

function TextLabel:setBackgroundColor(color)
    self.labelFrame.BackgroundColor3 = color
end

return TextLabel
