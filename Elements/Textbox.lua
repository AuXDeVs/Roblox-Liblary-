local TweenService = game:GetService("TweenService")

local TextBox = {}
TextBox.__index = TextBox

function TextBox:new(placeholder, pos, size, parent, theme)
    local self = setmetatable({}, TextBox)
    
    self.theme = theme
    self.callback = nil
    
    local textBox = Instance.new("TextBox")
    textBox.Name = "TextBox"
    textBox.Size = size
    textBox.Position = pos
    textBox.BackgroundColor3 = theme.colors.primary
    textBox.BorderSizePixel = 0
    textBox.PlaceholderText = placeholder
    textBox.Text = ""
    textBox.TextColor3 = theme.colors.text
    textBox.PlaceholderColor3 = theme.colors.textSecondary
    textBox.TextScaled = true
    textBox.Font = theme.font
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = textBox
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.colors.border
    stroke.Thickness = 2
    stroke.Parent = textBox
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = textBox
    
    textBox.Focused:Connect(function()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = theme.colors.accent}):Play()
        TweenService:Create(textBox, TweenInfo.new(0.2), {BackgroundColor3 = theme.colors.secondary}):Play()
    end)
    
    textBox.FocusLost:Connect(function()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = theme.colors.border}):Play()
        TweenService:Create(textBox, TweenInfo.new(0.2), {BackgroundColor3 = theme.colors.primary}):Play()
        
        if self.callback then
            self.callback(textBox.Text)
        end
    end)
    
    self.textBox = textBox
    return self
end

function TextBox:setCallback(callback)
    self.callback = callback
end

function TextBox:setText(text)
    self.textBox.Text = text
end

function TextBox:getText()
    return self.textBox.Text
end

return TextBox
