local TextLabel = {}
TextLabel.__index = TextLabel

function TextLabel:new(text, pos, size, parent, theme)
    local self = setmetatable({}, TextLabel)
    
    self.theme = theme
    
    local labelFrame = Instance.new("Frame")
    labelFrame.Name = "TextLabel"
    -- FIXED: Consistent 40px height like other elements
    labelFrame.Size = UDim2.new(1, -20, 0, 40)
    labelFrame.Position = UDim2.new(0, 10, 0, pos and pos.Y.Offset or 0)
    labelFrame.BackgroundColor3 = theme.colors.secondary
    labelFrame.BorderSizePixel = 0
    labelFrame.Parent = parent
    
    local corner = Instance.new("UICorner")
    -- FIXED: Smaller corner radius for consistency with other elements
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = labelFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.colors.border
    stroke.Thickness = 1
    stroke.Parent = labelFrame
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    -- FIXED: Better padding and positioning
    label.Size = UDim2.new(1, -24, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = theme.colors.text
    -- FIXED: Consistent text size with other elements
    label.TextSize = 14
    label.Font = theme.font
    label.TextXAlignment = Enum.TextXAlignment.Left
    -- FIXED: Added vertical center alignment
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = labelFrame
    
    self.label = label
    self.labelFrame = labelFrame
    return self
end

function TextLabel:setText(text)
    self.label.Text = text
end

-- FIXED: Added method to change text color if needed
function TextLabel:setTextColor(color)
    self.label.TextColor3 = color
end

-- FIXED: Added method to change background color if needed
function TextLabel:setBackgroundColor(color)
    self.labelFrame.BackgroundColor3 = color
end

return TextLabel
