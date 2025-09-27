local TextLabel = {}
TextLabel.__index = TextLabel

function TextLabel:new(text, pos, size, parent, theme)
    local self = setmetatable({}, TextLabel)
    
    self.theme = theme
    
    local labelFrame = Instance.new("Frame")
    labelFrame.Name = "TextLabel"
    labelFrame.Size = UDim2.new(1, -20, 0, 40)
    labelFrame.Position = UDim2.new(0, 0, 0, pos and pos.Y.Offset or 0)
    labelFrame.BackgroundColor3 = theme.colors.secondary
    labelFrame.BorderSizePixel = 0
    labelFrame.Parent = parent
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.colors.border
    stroke.Thickness = 1
    stroke.Parent = labelFrame
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -30, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = theme.colors.text
    label.TextSize = 16
    label.Font = theme.font
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = labelFrame
    
    self.label = label
    self.labelFrame = labelFrame
    return self
end

function TextLabel:setText(text)
    self.label.Text = text
end

return TextLabel
