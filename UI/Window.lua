--[[

UI/Window.lua 

--]]

local Window = {}
Window.__index = Window

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

function Window.new(title, subtitle, theme, elements)
    local self = {}
    setmetatable(self, Window)
    
    self.Theme = theme
    self.Elements = elements
    self.title = title or "Modern UI"
    self.subtitle = subtitle or "v1.0"
    
    self:CreateWindow()
    self:SetupDragging()
    self:SetupMinimize()
    
    return self
end

function Window:CreateWindow()
    -- // Create ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "ModernUILibrary"
    self.ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- // Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Parent = self.ScreenGui
    self.MainFrame.BackgroundColor3 = self.Theme.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
    self.MainFrame.Size = UDim2.new(0, 400, 0, 500)
    self.MainFrame.ClipsDescendants = true
    
  -- // Corner frame Rds
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = self.MainFrame
    
    -- // Border
    local Border = Instance.new("UIStroke")
    Border.Color = self.Theme.Border
    Border.Thickness = 1
    Border.Parent = self.MainFrame
    
    -- // Header
    self.Header = Instance.new("Frame")
    self.Header.Name = "Header"
    self.Header.Parent = self.MainFrame
    self.Header.BackgroundColor3 = self.Theme.Secondary
    self.Header.BorderSizePixel = 0
    self.Header.Size = UDim2.new(1, 0, 0, 40)
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 8)
    HeaderCorner.Parent = self.Header
    
    -- // Title
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "Title"
    self.TitleLabel.Parent = self.Header
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    self.TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.Text = self.title
    self.TitleLabel.TextColor3 = self.Theme.Text
    self.TitleLabel.TextScaled = true
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- // Minimize Button
    self.MinimizeBtn = Instance.new("TextButton")
    self.MinimizeBtn.Name = "MinimizeBtn"
    self.MinimizeBtn.Parent = self.Header
    self.MinimizeBtn.BackgroundColor3 = self.Theme.Accent
    self.MinimizeBtn.BorderSizePixel = 0
    self.MinimizeBtn.Position = UDim2.new(1, -35, 0.5, -10)
    self.MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
    self.MinimizeBtn.Font = Enum.Font.GothamBold
    self.MinimizeBtn.Text = "-"
    self.MinimizeBtn.TextColor3 = self.Theme.Text
    self.MinimizeBtn.TextScaled = true
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 4)
    MinCorner.Parent = self.MinimizeBtn
    
    -- // Content Frame
    self.ContentFrame = Instance.new("ScrollingFrame")
    self.ContentFrame.Name = "Content"
    self.ContentFrame.Parent = self.MainFrame
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.Position = UDim2.new(0, 0, 0, 50)
    self.ContentFrame.Size = UDim2.new(1, 0, 1, -50)
    self.ContentFrame.ScrollBarThickness = 4
    self.ContentFrame.ScrollBarImageColor3 = self.Theme.Accent
    self.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    -- // Layout
    local Layout = Instance.new("UIListLayout")
    Layout.Parent = self.ContentFrame
    Layout.Padding = UDim.new(0, 8)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local Padding = Instance.new("UIPadding")
    Padding.Parent = self.ContentFrame
    Padding.PaddingTop = UDim.new(0, 10)
    Padding.PaddingBottom = UDim.new(0, 10)
    Padding.PaddingLeft = UDim.new(0, 15)
    Padding.PaddingRight = UDim.new(0, 15)
end

function Window:SetupMinimize()
    self.isMinimized = false
    self.originalSize = self.MainFrame.Size
    
    self.MinimizeBtn.MouseButton1Click:Connect(function()
        self.isMinimized = not self.isMinimized
        local targetSize = self.isMinimized and UDim2.new(0, 400, 0, 40) or self.originalSize
        self.MinimizeBtn.Text = self.isMinimized and "+" or "-"
        
        local tween = TweenService:Create(
            self.MainFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Size = targetSize}
        )
        tween:Play()
    end)
end

function Window:SetupDragging()
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    self.Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- // Add Elements
function Window:AddButton(text, callback)
    return self.Elements.Button.new(self.ContentFrame, text, callback, self.Theme)
end

function Window:AddToggle(text, default, callback)
    return self.Elements.Toggle.new(self.ContentFrame, text, default, callback, self.Theme)
end

function Window:AddTextbox(placeholder, callback)
    return self.Elements.Textbox.new(self.ContentFrame, placeholder, callback, self.Theme)
end

function Window:AddLabel(text)
    return self.Elements.TextLabel.new(self.ContentFrame, text, self.Theme)
end

function Window:Destroy()
    self.ScreenGui:Destroy()
end

return Window
