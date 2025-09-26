local TweenService = game:GetService("TweenService")

local Button = {}
Button.__index = Button

function Button:new(text, pos, size, parent, theme)
    local self = setmetatable({}, Button)
    
    self.theme = theme
    self.callback = nil
    
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = size
    button.Position = pos
    button.BackgroundColor3 = theme.colors.accent
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = theme.colors.text
    button.TextScaled = true
    button.Font = theme.font
    button.AutoButtonColor = false
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.colors.border
    stroke.Thickness = 1
    stroke.Parent = button
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = theme.colors.accentHover}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = theme.colors.accentHover}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = theme.colors.accent}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = theme.colors.border}):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {Size = size - UDim2.new(0, 4, 0, 2)}):Play()
        wait(0.1)
        TweenService:Create(button, TweenInfo.new(0.1), {Size = size}):Play()
        
        if self.callback then
            self.callback()
        end
    end)
    
    self.button = button
    return self
end

function Button:setCallback(callback)
    self.callback = callback
end

function Button:setText(text)
    self.button.Text = text
end

return Button
