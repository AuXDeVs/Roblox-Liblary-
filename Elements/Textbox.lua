--[[


Elements/Textbox.lua 


--]]

local Textbox = {}
Textbox.__index = Textbox

local TweenService = game:GetService("TweenService")

function Textbox.new(parent, placeholder, callback, theme)
    local self = {}
    setmetatable(self, Textbox)
    
    self.Theme = theme
    self.placeholder = placeholder or "Enter text..."
    self.callback = callback or function() end
    self.focused = false
    
    self:CreateTextbox(parent)
    self:SetupEvents()
    
    return self
end


function Textbox:CreateTextbox(parent)
 -- //Main Frame
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
    self.Border = Instance.new("UIStroke")
    self.Border.Color = self.Theme.Border
    self.Border.Thickness = 1
    self.Border.Parent = self.Frame

  
    -- // TextBox
    self.TextBox = Instance.new("TextBox")
    self.TextBox.Parent = self.Frame
    self.TextBox.BackgroundTransparency = 1
    self.TextBox.Position = UDim2.new(0, 12, 0, 0)
    self.TextBox.Size = UDim2.new(1, -24, 1, 0)
    self.TextBox.Font = Enum.Font.Gotham
    self.TextBox.PlaceholderText = self.placeholder
    self.TextBox.PlaceholderColor3 = self.Theme.TextSecondary
    self.TextBox.Text = ""
    self.TextBox.TextColor3 = self.Theme.Text
    self.TextBox.TextScaled = true
    self.TextBox.TextXAlignment = Enum.TextXAlignment.Left
    self.TextBox.ClearTextOnFocus = false

  
    -- // Focus indicator
    self.FocusIndicator = Instance.new("Frame")
    self.FocusIndicator.Parent = self.Frame
    self.FocusIndicator.BackgroundColor3 = self.Theme.Accent
    self.FocusIndicator.BorderSizePixel = 0
    self.FocusIndicator.Position = UDim2.new(0, 0, 1, -2)
    self.FocusIndicator.Size = UDim2.new(0, 0, 0, 2)

  
    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(0, 1)
    IndicatorCorner.Parent = self.FocusIndicator
end


function Textbox:SetupEvents()
    -- // Focus events
    self.TextBox.Focused:Connect(function()
        self.focused = true
        self:UpdateFocusState()
    end)
    
    self.TextBox.FocusLost:Connect(function(enterPressed)
        self.focused = false
        self:UpdateFocusState()
        
        if enterPressed and self.callback then
            self.callback(self.TextBox.Text)
        end
    end)
    
    self.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        if self.callback then
            self.callback(self.TextBox.Text)
        end
    end)
    

  
    self.TextBox.MouseEnter:Connect(function()
        if not self.focused then
            local tween = TweenService:Create(
                self.Border,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                {Color = Color3.fromRGB(80, 80, 80)}
            )
            tween:Play()
        end
    end)
    
    self.TextBox.MouseLeave:Connect(function()
        if not self.focused then
            local tween = TweenService:Create(
                self.Border,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                {Color = self.Theme.Border}
            )
            tween:Play()
        end
    end)
end


function Textbox:UpdateFocusState()
    if self.focused then
        
        local borderTween = TweenService:Create(
            self.Border,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {Color = self.Theme.Accent}
        )
        borderTween:Play()
        
        local indicatorTween = TweenService:Create(
            self.FocusIndicator,
            TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Size = UDim2.new(1, 0, 0, 2)}
        )
        indicatorTween:Play()
        
        local bgTween = TweenService:Create(
            self.Frame,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}
        )
        bgTween:Play()
    else
        local borderTween = TweenService:Create(
            self.Border,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {Color = self.Theme.Border}
        )
        borderTween:Play()
        
        local indicatorTween = TweenService:Create(
            self.FocusIndicator,
            TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 0, 0, 2)}
        )
        indicatorTween:Play()
        
        local bgTween = TweenService:Create(
            self.Frame,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {BackgroundColor3 = self.Theme.Secondary}
        )
        bgTween:Play()
    end
end


function Textbox:SetText(newText)
    self.TextBox.Text = newText
end


function Textbox:GetText()
    return self.TextBox.Text
end


function Textbox:SetPlaceholder(newPlaceholder)
    self.placeholder = newPlaceholder
    self.TextBox.PlaceholderText = newPlaceholder
end


function Textbox:SetCallback(newCallback)
    self.callback = newCallback
end


function Textbox:Clear()
    self.TextBox.Text = ""
end


function Textbox:Destroy()
    self.Frame:Destroy()
end


return Textbox
