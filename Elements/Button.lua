local TweenService = game:GetService("TweenService")

local Button = {}
Button.__index = Button

function Button:new(text, pos, size, parent, theme)
    local self = setmetatable({}, Button)
    
    self.theme = theme
    self.callback = nil
    
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(1, -20, 0, 45)
    button.Position = UDim2.new(0, 10, 0, pos and pos.Y.Offset or 0)
    button.BackgroundColor3 = theme.colors.secondary
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = theme.colors.text
    button.TextSize = 16
    button.Font = theme.font
    button.AutoButtonColor = false
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.colors.border
    stroke.Thickness = 1
    stroke.Parent = button
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = theme.colors.primary}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = theme.colors.secondary}):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = theme.colors.accent}):Play()
        wait(0.1)
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = theme.colors.secondary}):Play()
        
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
