local TweenService = game:GetService("TweenService")

local Toggle = {}
Toggle.__index = Toggle

function Toggle:new(pos, size, parent, theme, state)
    local self = setmetatable({}, Toggle)
    
    self.theme = theme
    self.state = state or false
    self.callback = nil
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "Toggle"
    toggleFrame.Size = UDim2.new(0, 60, 0, 30)
    toggleFrame.Position = pos
    toggleFrame.BackgroundColor3 = self.state and theme.colors.success or theme.colors.secondary
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = toggleFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.colors.border
    stroke.Thickness = 1
    stroke.Parent = toggleFrame
    
    local toggleButton = Instance.new("Frame")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 26, 0, 26)
    toggleButton.Position = self.state and UDim2.new(0, 32, 0, 2) or UDim2.new(0, 2, 0, 2)
    toggleButton.BackgroundColor3 = theme.colors.text
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 13)
    buttonCorner.Parent = toggleButton
    
    local clickButton = Instance.new("TextButton")
    clickButton.Size = UDim2.new(1, 0, 1, 0)
    clickButton.BackgroundTransparency = 1
    clickButton.Text = ""
    clickButton.Parent = toggleFrame
    
    clickButton.MouseButton1Click:Connect(function()
        self.state = not self.state
        
        local newPos = self.state and UDim2.new(0, 32, 0, 2) or UDim2.new(0, 2, 0, 2)
        local newColor = self.state and theme.colors.success or theme.colors.secondary
        
        TweenService:Create(toggleButton, TweenInfo.new(0.3), {Position = newPos}):Play()
        TweenService:Create(toggleFrame, TweenInfo.new(0.3), {BackgroundColor3 = newColor}):Play()
        
        if self.callback then
            self.callback(self.state)
        end
    end)
    
    self.toggleFrame = toggleFrame
    self.toggleButton = toggleButton
    return self
end

function Toggle:setCallback(callback)
    self.callback = callback
end

function Toggle:setState(state)
    self.state = state
    local newPos = self.state and UDim2.new(0, 32, 0, 2) or UDim2.new(0, 2, 0, 2)
    local newColor = self.state and self.theme.colors.success or self.theme.colors.secondary
    
    TweenService:Create(self.toggleButton, TweenInfo.new(0.3), {Position = newPos}):Play()
    TweenService:Create(self.toggleFrame, TweenInfo.new(0.3), {BackgroundColor3 = newColor}):Play()
end

return Toggle
