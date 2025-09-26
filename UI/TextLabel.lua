--[[


UI/TextLabel.lua 


--]]

local TextLabel = {}
TextLabel.__index = TextLabel

function TextLabel.new(parent, text, theme)
    local self = {}
    setmetatable(self, TextLabel)
    
    self.Theme = theme
    self.text = text or "Label"
    
    self:CreateLabel(parent)
    
    return self
end

function TextLabel:CreateLabel(parent)
    -- Main Frame
    self.Frame = Instance.new("Frame")
    self.Frame.Parent = parent
    self.Frame.BackgroundColor3 = self.Theme.Secondary
    self.Frame.BorderSizePixel = 0
    self.Frame.Size = UDim2.new(1, 0, 0, 35)
    
    -- Corner rds
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = self.Frame
    
    -- Border
    local Border = Instance.new("UIStroke")
    Border.Color = self.Theme.Border
    Border.Thickness = 1
    Border.Parent = self.Frame
    
    -- Text Label
    self.Label = Instance.new("TextLabel")
    self.Label.Parent = self.Frame
    self.Label.BackgroundTransparency = 1
    self.Label.Position = UDim2.new(0, 12, 0, 0)
    self.Label.Size = UDim2.new(1, -24, 1, 0)
    self.Label.Font = Enum.Font.Gotham
    self.Label.Text = self.text
    self.Label.TextColor3 = self.Theme.Text
    self.Label.TextScaled = true
    self.Label.TextXAlignment = Enum.TextXAlignment.Left
end

function TextLabel:SetText(newText)
    self.text = newText
    self.Label.Text = newText
end

function TextLabel:GetText()
    return self.text
end

function TextLabel:Destroy()
    self.Frame:Destroy()
end

return TextLabel
