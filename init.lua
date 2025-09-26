--[[

I'll rewrite this soon.

--]]

local Library = {}
Library.__index = Library

-- // Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- // Load UI modules
local Window = require(script.UI.Window)
local TextLabel = require(script.UI.TextLabel)

-- // Load Element modules
local Button = require(script.Elements.Button)
local Toggle = require(script.Elements.Toggle)
local Textbox = require(script.Elements.Textbox)

-- // Theme Config
Library.Theme = {
    Background = Color3.fromRGB(15, 15, 15),
    Secondary = Color3.fromRGB(25, 25, 25),
    Accent = Color3.fromRGB(220, 50, 50),
    AccentHover = Color3.fromRGB(240, 70, 70),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 180),
    Border = Color3.fromRGB(45, 45, 45)
}

-- // Animation settings
Library.AnimationSpeed = 0.3
Library.EasingStyle = Enum.EasingStyle.Quart
Library.EasingDirection = Enum.EasingDirection.Out

-- // Create Window
function Library:CreateWindow(title, subtitle)
    return Window.new(title, subtitle, self.Theme, {
        Button = Button,
        Toggle = Toggle,
        Textbox = Textbox,
        TextLabel = TextLabel
    })
end

return Library
