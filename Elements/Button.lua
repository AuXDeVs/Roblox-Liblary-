--[[

Elements/Button.lua 


--]]


local Button = {}
Button.__index = Button

local TweenService = game:GetService("TweenService")

function Button.new(parent, text, callback, theme)
    local self = {}
    setmetatable(self, Button)
    
    self.Theme = theme
    self.text = text or "Button"
    self.callback = callback or function() end
    
    self:CreateButton(parent)
    self:SetupEvents()
    
    return self
end

function Button:CreateButton(parent)
    -- // Button
    self.Button = Instance.new("TextButton")
    self.Button.Parent = parent
    self.Button.BackgroundColor3 = self.Theme.Secondary
    self.Button.BorderSizePixel = 0
    self.Button.Size = UDim2.new(1, 0, 0, 35)
    self.Button.Font = Enum.Font.Gotham
    self.Button.Text = self.text
    self.Button.TextColor3 = self.Theme.Text
    self.Button.TextScaled = true
    self.Button.AutoButtonColor = false
    
    -- // Corner rds
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = self.Button
    
    -- // Border
    local Border = Instance.new("UIStroke")
    Border.Color = self.Theme.Border
    Border.Thickness = 1
    Border.Parent = self.Button
    
    -- // Riple
    self.Ripple = Instance.new("Frame")
    self.Ripple.Parent = self.Button
    self.Ripple.BackgroundColor3 = self.Theme.Accent
    self.Ripple.BackgroundTransparency = 1
    self.Ripple.BorderSizePixel = 0
    self.Ripple.Size = UDim2.new(0, 0, 0, 0)
    self.Ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.Ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Ripple.ZIndex = 2
    
    local RippleCorner = Instance.new("UICorner")
    RippleCorner.CornerRadius = UDim.new(1, 0)
    RippleCorner.Parent = self.Ripple
end

function Button:SetupEvents()
    
    self.Button.MouseEnter:Connect(function()
        local tween = TweenService:Create(
            self.Button,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {BackgroundColor3 = self.Theme.Accent}
        )
        tween:Play()
    end)
    
    self.Button.MouseLeave:Connect(function()
        local tween = TweenService:Create(
            self.Button,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {BackgroundColor3 = self.Theme.Secondary}
        )
        tween:Play()
    end)
    
    self.Button.MouseButton1Down:Connect(function()
        
        local scaleDown = TweenService:Create(
            self.Button,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad),
            {Size = UDim2.new(1, -4, 0, 31)}
        )
        scaleDown:Play()
        
        self.Ripple.Size = UDim2.new(0, 0, 0, 0)
        self.Ripple.BackgroundTransparency = 0.7
        
        local rippleExpand = TweenService:Create(
            self.Ripple,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad),
            {
                Size = UDim2.new(0, 100, 0, 100),
                BackgroundTransparency = 1
            }
        )
        rippleExpand:Play()
    end)
    
    self.Button.MouseButton1Up:Connect(function()

        local scaleUp = TweenService:Create(
            self.Button,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad),
            {Size = UDim2.new(1, 0, 0, 35)}
        )
        scaleUp:Play()
        
        -- // call back
        if self.callback then
            self.callback()
        end
    end)
end

function Button:SetText(newText)
    self.text = newText
    self.Button.Text = newText
end

function Button:SetCallback(newCallback)
    self.callback = newCallback
end

function Button:Destroy()
    self.Button:Destroy()
end

return Button
