--[[

Credit's for This slider
Function From Bloodball
Youngstarts Library 
Credits Bloodball :>

--]]
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Slider = {}
Slider.__index = Slider

function Slider:new(name, min, max, precise, pos, size, parent, theme)
    local self = setmetatable({}, Slider)
    
    self.theme = theme
    self.callback = nil
    self.min = min or 0
    self.max = max or 100
    self.precise = precise or false
    self.value = self.min
    self.dragging = false
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "Slider"
    sliderFrame.Size = UDim2.new(1, -20, 0, 60)
    sliderFrame.Position = UDim2.new(0, 10, 0, pos and pos.Y.Offset or 0)
    sliderFrame.BackgroundColor3 = theme.colors.secondary
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = parent
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.colors.border
    stroke.Thickness = 1
    stroke.Parent = sliderFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "SliderTitle"
    titleLabel.Size = UDim2.new(0.7, -10, 0, 20)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = name or "Slider"
    titleLabel.TextColor3 = theme.colors.text
    titleLabel.TextSize = 14
    titleLabel.Font = theme.font
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = sliderFrame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "ValueLabel"
    valueLabel.Size = UDim2.new(0.3, -10, 0, 20)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = self.min .. "/" .. self.max
    valueLabel.TextColor3 = theme.colors.textSecondary
    valueLabel.TextSize = 12
    valueLabel.Font = theme.font
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = sliderFrame
    
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Name = "SliderTrack"
    sliderTrack.Size = UDim2.new(1, -20, 0, 6)
    sliderTrack.Position = UDim2.new(0, 10, 0, 35)
    sliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = sliderFrame
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new(0, 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = theme.colors.accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderTrack
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "SliderButton"
    sliderButton.Size = UDim2.new(1, 0, 1, 0)
    sliderButton.Position = UDim2.new(0, 0, 0, 0)
    sliderButton.BackgroundTransparency = 1
    sliderButton.Text = ""
    sliderButton.Parent = sliderTrack
    
    local function updateSlider(percentage)
        percentage = math.clamp(percentage, 0, 1)
        local newValue = self.min + (self.max - self.min) * percentage
        
        if self.precise then
            newValue = math.floor(newValue * 100) / 100
        else
            newValue = math.floor(newValue)
        end
        
        self.value = newValue
        
        sliderFill:TweenSize(
            UDim2.new(percentage, 0, 1, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.1,
            true
        )
        
        valueLabel.Text = self.value .. "/" .. self.max
        
        if self.callback then
            self.callback(self.value)
        end
    end
    
    local connection
    
    sliderButton.MouseButton1Down:Connect(function()
        self.dragging = true
        
        if connection then
            connection:Disconnect()
        end
        
        connection = RunService.RenderStepped:Connect(function()
            if not self.dragging then
                if connection then
                    connection:Disconnect()
                    connection = nil
                end
                return
            end
            
            local mouse = UserInputService:GetMouseLocation()
            local percentage = math.clamp(
                (mouse.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X,
                0, 1
            )
            updateSlider(percentage)
        end)
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if self.dragging then
                self.dragging = false
                if connection then
                    connection:Disconnect()
                    connection = nil
                end
            end
        end
    end)
    
    self.sliderFrame = sliderFrame
    self.titleLabel = titleLabel
    self.valueLabel = valueLabel
    self.updateSlider = updateSlider
    
    return self
end

function Slider:setCallback(callback)
    self.callback = callback
end

function Slider:setValue(value)
    value = math.clamp(value, self.min, self.max)
    local percentage = (value - self.min) / (self.max - self.min)
    self:updateSlider(percentage)
end

function Slider:getText()
    return self.titleLabel.Text
end

function Slider:setText(text)
    self.titleLabel.Text = text
end

return Slider
