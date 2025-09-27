local TextLabel = {}
TextLabel.__index = TextLabel

function TextLabel:new(text, pos, size, parent, theme)
    local self = setmetatable({}, TextLabel)
    
    self.theme = theme
    
    local label = Instance.new("TextLabel")
    label.Name = "TextLabel"
    label.Size = size
    label.Position = pos
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = theme.colors.text
    label.TextScaled = true
    label.Font = theme.font
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 5)
    padding.PaddingRight = UDim.new(0, 5)
    padding.Parent = label
    
    self.label = label
    return self
end

function TextLabel:setText(text)
    self.label.Text = text
end

function TextLabel:setColor(color)
    self.label.TextColor3 = color
end

return TextLabel
