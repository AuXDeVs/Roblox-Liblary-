local TweenService = game:GetService("TweenService")

local TextBox = {}
TextBox.__index = TextBox

function TextBox:new(placeholder, pos, size, parent, theme)
    local self = setmetatable({}, TextBox)
    
    self.theme = theme
    self.callback = nil
    
    local textboxFrame = Instance.new("Frame")
    textboxFrame.Name = "TextBox"
    textboxFrame.Size = UDim2.new(1, -20, 0, 40)
    textboxFrame.Position = UDim2.new(0, 10, 0, pos and pos.Y.Offset or 0)
    textboxFrame.BackgroundColor3 = theme.colors.secondary
    textboxFrame.BorderSizePixel = 0
    textboxFrame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = textboxFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.colors.border
    stroke.Thickness = 1
    stroke.Parent = textboxFrame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "TextBoxLabel"
    textLabel.Size = UDim2.new(0.5, -15, 1, 0)
    textLabel.Position = UDim2.new(0, 12, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = placeholder or "TextBox"
    textLabel.TextColor3 = theme.colors.text
    textLabel.TextSize = 14
    textLabel.Font = theme.font
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextYAlignment = Enum.TextYAlignment.Center
    textLabel.Parent = textboxFrame
    
    local textBox = Instance.new("TextBox")
    textBox.Name = "Input"
    textBox.Size = UDim2.new(0.45, -15, 0, 24)
    textBox.Position = UDim2.new(0.55, 0, 0.5, -12)
    textBox.BackgroundColor3 = theme.colors.primary
    textBox.BorderSizePixel = 0
    textBox.PlaceholderText = "Enter value"
    textBox.Text = ""
    textBox.TextColor3 = theme.colors.text
    textBox.PlaceholderColor3 = theme.colors.textSecondary
    textBox.TextSize = 13
    textBox.Font = theme.font
    textBox.TextXAlignment = Enum.TextXAlignment.Center
    textBox.Parent = textboxFrame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 6)
    inputCorner.Parent = textBox
    
    textBox.Focused:Connect(function()
        TweenService:Create(stroke, TweenInfo.new(0.15), {Color = theme.colors.accent}):Play()
    end)
    
    textBox.FocusLost:Connect(function()
        TweenService:Create(stroke, TweenInfo.new(0.15), {Color = theme.colors.border}):Play()
        
        if self.callback then
            self.callback(textBox.Text)
        end
    end)
    
    self.textBox = textBox
    self.textboxFrame = textboxFrame
    return self
end

function TextBox:setCallback(callback)
    self.callback = callback
end

return TextBox
