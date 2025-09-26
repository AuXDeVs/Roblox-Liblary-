--[[

Elements/Toggle.lua

--]]


local Toggle = {}
Toggle.__index = Toggle

local TweenService = game:GetService("TweenService")

function Toggle.new(parent, text, default, callback, theme)
    local self = {}
    setmetatable(self, Toggle)
    
    self.Theme = theme
    self.text = text or "Toggle"
    self.state = default or false
    self.callback = callback or function() end
    
    self:CreateToggle(parent)
    self:SetupEvents()
    self:UpdateToggle()
    
    return self
end

function Toggle:CreateToggle(parent)
    -- Main Frame
    self.Frame = Instance.new("Frame")
    self.Frame.Parent = parent
    self.Frame.BackgroundColor3 = self.Theme.Secondary
    self.Frame.BorderSizePixel = 0
    self.Frame.Size = UDim2.new(1, 0, 0, 35)
    
    -- // Corner rds
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = self.Frame
    
    -- // Border
    local Border = Instance.new("UIStroke")
    Border.Color = self.Theme.Border
    Border.Thickness = 1
    Border.Parent = self.Frame
    
    -- // Text Label
    self.Label = Instance.new("TextLabel")
    self.Label.Parent = self.Frame
    self.Label.BackgroundTransparency = 1
    self.Label.Position = UDim2.new(0, 12, 0, 0)
    self.Label.Size = UDim2.new(1, -60, 1, 0)
    self.Label.Font = Enum.Font.Gotham
    self.Label.Text = self.text
    self.Label.TextColor3 = self.Theme.Text
    self.Label.TextScaled = true
    self.Label.TextXAlignment = Enum.TextXAlignment.Left
    
    -- // Toggle Bkrund
    self.ToggleBg = Instance.new("Frame")
    self.ToggleBg.Parent = self.Frame
    self.ToggleBg.BackgroundColor3 = self.Theme.Border
    self.ToggleBg.BorderSizePixel = 0
    self.ToggleBg.Position = UDim2.new(1, -40, 0.5, -8)
    self.ToggleBg.Size = UDim2.new(0, 32, 0, 16)
    
    local ToggleBgCorner = Instance.new("UICorner")
    ToggleBgCorner.CornerRadius = UDim.new(0, 8)
    ToggleBgCorner.Parent = self.ToggleBg
    
    -- // Toggle 
    self.ToggleBtn = Instance.new("Frame")
    self.ToggleBtn.Parent = self.ToggleBg
    self.ToggleBtn.BackgroundColor3 = self.Theme.Text
    self.ToggleBtn.BorderSizePixel = 0
    self.ToggleBtn.Position = UDim2.new(0, 2, 0.5, 0)
    self.ToggleBtn.Size = UDim2.new(0, 12, 0, 12)
    self.ToggleBtn.AnchorPoint = Vector2.new(0, 0.5)
    
    local ToggleBtnCorner = Instance.new("UICorner")
    ToggleBtnCorner.CornerRadius = UDim.new(0, 6)
    ToggleBtnCorner.Parent = self.ToggleBtn
    
    -- // Click dct
    self.ClickDetector = Instance.new("TextButton")
    self.ClickDetector.Parent = self.Frame
    self.ClickDetector.BackgroundTransparency = 1
    self.ClickDetector.Size = UDim2.new(1, 0, 1, 0)
    self.ClickDetector.Text = ""
end

function Toggle:SetupEvents()
    
    self.ClickDetector.MouseEnter:Connect(function()
        local tween = TweenService:Create(
            self.Frame,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}
        )
        tween:Play()
    end)
    
    self.ClickDetector.MouseLeave:Connect(function()
        local tween = TweenService:Create(
            self.Frame,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {BackgroundColor3 = self.Theme.Secondary}
        )
        tween:Play()
    end)
    
    -- // Click event
    self.ClickDetector.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
end

function Toggle:Toggle()
    self.state = not self.state
    self:UpdateToggle()
    
    if self.callback then
        self.callback(self.state)
    end
end

function Toggle:UpdateToggle()
    local bgColor = self.state and self.Theme.Accent or self.Theme.Border
    local btnPosition = self.state and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
    
    local bgTween = TweenService:Create(
        self.ToggleBg,
        TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {BackgroundColor3 = bgColor}
    )
    bgTween:Play()
    
    local btnTween = TweenService:Create(
        self.ToggleBtn,
        TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Position = btnPosition}
    )
    btnTween:Play()
end

function Toggle:SetState(newState)
    self.state = newState
    self:UpdateToggle()
end

function Toggle:GetState()
    return self.state
end

function Toggle:SetText(newText)
    self.text = newText
    self.Label.Text = newText
end

function Toggle:SetCallback(newCallback)
    self.callback = newCallback
end

function Toggle:Destroy()
    self.Frame:Destroy()
end

return Toggle
