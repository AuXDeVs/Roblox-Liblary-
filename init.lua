local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Window = loadstring(game:HttpGet("https://raw.githubusercontent.com/AuXDeVs/Roblox-Liblary-/refs/heads/main/UI/Window.lua"))()
local TextLabel = loadstring(game:HttpGet("https://raw.githubusercontent.com/AuXDeVs/Roblox-Liblary-/refs/heads/main/UI/TextLabel.lua"))()
local Tabs = loadstring(game:HttpGet("https://raw.githubusercontent.com/AuXDeVs/Roblox-Liblary-/refs/heads/main/UI/Tabs.lua"))() -- FIXED: ADDED THIS LINE
local Button = loadstring(game:HttpGet("https://raw.githubusercontent.com/AuXDeVs/Roblox-Liblary-/refs/heads/main/Elements/Button.lua"))()
local Toggle = loadstring(game:HttpGet("https://raw.githubusercontent.com/AuXDeVs/Roblox-Liblary-/refs/heads/main/Elements/Toggle.lua"))()
local TextBox = loadstring(game:HttpGet("https://raw.githubusercontent.com/AuXDeVs/Roblox-Liblary-/refs/heads/main/Elements/Textbox.lua"))()

local UI = {}
UI.__index = UI

UI.theme = {
    colors = {
        primary = Color3.fromRGB(35, 35, 35),
        secondary = Color3.fromRGB(25, 25, 25),
        accent = Color3.fromRGB(220, 20, 20),
        accentHover = Color3.fromRGB(255, 40, 40),
        text = Color3.fromRGB(255, 255, 255),
        textSecondary = Color3.fromRGB(200, 200, 200),
        border = Color3.fromRGB(60, 60, 60),
        success = Color3.fromRGB(40, 220, 40),
        warning = Color3.fromRGB(255, 165, 0),
        background = Color3.fromRGB(15, 15, 15)
    },
    font = Enum.Font.GothamMedium,
    fontSize = Enum.FontSize.Size14,
    cornerRadius = UDim.new(0, 6),
    borderSize = 1,
    animTime = 0.2
}

function UI:new()
    local gui = PlayerGui:FindFirstChild("ModernUI")
    if gui then gui:Destroy() end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ModernUI"
    screenGui.Parent = PlayerGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    self.gui = screenGui
    return self
end

function UI:window(title, size)
    return Window:new(title, size, self.theme)
end

function UI:button(text, pos, size, parent)
    return Button:new(text, pos, size, parent, self.theme)
end

function UI:toggle(pos, size, parent, state)
    return Toggle:new(pos, size, parent, self.theme, state)
end

function UI:textbox(placeholder, pos, size, parent)
    return TextBox:new(placeholder, pos, size, parent, self.theme)
end

function UI:label(text, pos, size, parent)
    return TextLabel:new(text, pos, size, parent, self.theme)
end

function UI:tabs(parent) -- FIXED: ADDED TABS METHOD
    return Tabs:new(parent, self.theme)
end

function UI:corner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or self.theme.cornerRadius
    corner.Parent = parent
    return corner
end

function UI:stroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or self.theme.colors.border
    stroke.Thickness = thickness or self.theme.borderSize
    stroke.Parent = parent
    return stroke
end

function UI:tween(obj, props, time)
    local info = TweenInfo.new(
        time or self.theme.animTime,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

return UI
