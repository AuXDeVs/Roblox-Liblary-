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
    toggleFrame.Size = UDim2.new(1, -20, 0, 50)
    toggleFrame.Position = UDim2.new(0, 10, 0, pos and pos.Y.Offset or 0)
    toggleFrame.BackgroundColor3 = theme.colors.secondary
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = toggleFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.colors.border
    stroke.Thickness = 1
    stroke.Parent = toggleFrame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "ToggleText"
    textLabel.Size = UDim2.new(1, -80, 1, 0)
    textLabel.Position = UDim2.new(0, 15, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "Toggle"
    textLabel.TextColor3 = theme.colors.text
    textLabel.TextSize = 16
    textLabel.Font = theme.font
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = toggleFrame
    
    local toggleSwitch = Instance.new("Frame")
    toggleSwitch.Name = "ToggleSwitch"
    toggleSwitch.Size = UDim2.new(0, 50, 0, 25)
    toggleSwitch.Position = UDim2.new(1, -60, 0.5, -12.5)
    toggleSwitch.BackgroundColor3 = self.state and theme.colors.accent or Color3.fromRGB(60, 60, 60)
    toggleSwitch.BorderSizePixel = 0
    toggleSwitch.Parent = toggleFrame
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(0, 12)
    switchCorner.Parent = toggleSwitch
    
    local switchButton = Instance.new("Frame")
    switchButton.Name = "SwitchButton"
    switchButton.Size = UDim2.new(0, 21, 0, 21)
    switchButton.Position = self.state and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
    switchButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    switchButton.BorderSizePixel = 0
    switchButton.Parent = toggleSwitch
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 13)
    buttonCorner.Parent = switchButton
    
    local clickButton = Instance.new("TextButton")
    clickButton.Size = UDim2.new(1, 0, 1, 0)
    clickButton.BackgroundTransparency = 1
    clickButton.Text = ""
    clickButton.Parent = toggleFrame
    
    clickButton.MouseButton1Click:Connect(function()
        self.state = not self.state
        
        local newPos = self.state and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
        local newColor = self.state and theme.colors.accent or Color3.fromRGB(60, 60, 60)
        
        TweenService:Create(switchButton, TweenInfo.new(0.2), {Position = newPos}):Play()
        TweenService:Create(toggleSwitch, TweenInfo.new(0.2), {BackgroundColor3 = newColor}):Play()
        
        if self.callback then
            self.callback(self.state)
        end
    end)
    
    self.toggleFrame = toggleFrame
    self.textLabel = textLabel
    return self
end

function Toggle:setCallback(callback)
    self.callback = callback
end

function Toggle:setText(text)
    self.textLabel.Text = text
end

return Toggle
