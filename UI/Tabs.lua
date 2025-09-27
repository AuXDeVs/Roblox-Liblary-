local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local Tabs = {}
Tabs.__index = Tabs

function Tabs:new(parent, theme)
    local self = setmetatable({}, Tabs)
    
    self.theme = theme
    self.parent = parent
    self.tabs = {}
    self.activeTab = nil
    
    self:create()
    return self
end

function Tabs:corner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or self.theme.cornerRadius
    corner.Parent = parent
    return corner
end

function Tabs:stroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or self.theme.colors.border
    stroke.Thickness = thickness or self.theme.borderSize
    stroke.Parent = parent
    return stroke
end

function Tabs:tween(obj, props, time)
    local info = TweenInfo.new(
        time or self.theme.animTime,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

function Tabs:create()
    
    local leftFrame = Instance.new("Frame")
    leftFrame.Name = "LeftFrame"
    -- FIXED: Reduced width from 180 to 160 for better proportions
    leftFrame.Size = UDim2.new(0, 160, 1, 0)
    leftFrame.Position = UDim2.new(0, 0, 0, 0)
    leftFrame.BackgroundColor3 = self.theme.colors.secondary
    leftFrame.BorderSizePixel = 0
    leftFrame.Parent = self.parent
    
    self:corner(leftFrame)
    self:stroke(leftFrame, self.theme.colors.border, 1)
    
    local profileFrame = Instance.new("Frame")
    profileFrame.Name = "Profile"
    -- FIXED: Reduced height and better positioning
    profileFrame.Size = UDim2.new(1, -8, 0, 55)
    profileFrame.Position = UDim2.new(0, 4, 1, -59)
    profileFrame.BackgroundColor3 = self.theme.colors.primary
    profileFrame.BorderSizePixel = 0
    profileFrame.Parent = leftFrame
    
    self:corner(profileFrame)
    
    local avatar = Instance.new("ImageLabel")
    avatar.Name = "Avatar"
    -- FIXED: Smaller avatar
    avatar.Size = UDim2.new(0, 35, 0, 35)
    avatar.Position = UDim2.new(0, 8, 0, 10)
    avatar.BackgroundColor3 = self.theme.colors.border
    avatar.BorderSizePixel = 0
    avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=150&height=150&format=png"
    avatar.Parent = profileFrame
    
    self:corner(avatar, UDim.new(0, 17))
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "PlayerName"
    -- FIXED: Better positioning for name
    nameLabel.Size = UDim2.new(1, -50, 0, 18)
    nameLabel.Position = UDim2.new(0, 48, 0, 8)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = LocalPlayer.Name
    nameLabel.TextColor3 = self.theme.colors.text
    nameLabel.TextSize = 13
    nameLabel.Font = self.theme.font
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = profileFrame
    
    local displayLabel = Instance.new("TextLabel")
    displayLabel.Name = "DisplayName"
    -- FIXED: Better positioning for display name
    displayLabel.Size = UDim2.new(1, -50, 0, 14)
    displayLabel.Position = UDim2.new(0, 48, 0, 28)
    displayLabel.BackgroundTransparency = 1
    displayLabel.Text = "@" .. LocalPlayer.DisplayName
    displayLabel.TextColor3 = self.theme.colors.textSecondary
    displayLabel.TextSize = 11
    displayLabel.Font = self.theme.font
    displayLabel.TextXAlignment = Enum.TextXAlignment.Left
    displayLabel.Parent = profileFrame
    
    local tabsScroll = Instance.new("ScrollingFrame")
    tabsScroll.Name = "TabsScroll"
    -- FIXED: Better positioning and sizing
    tabsScroll.Size = UDim2.new(1, -8, 1, -68)
    tabsScroll.Position = UDim2.new(0, 4, 0, 4)
    tabsScroll.BackgroundTransparency = 1
    tabsScroll.ScrollBarThickness = 4
    tabsScroll.ScrollBarImageColor3 = self.theme.colors.accent
    tabsScroll.BorderSizePixel = 0
    tabsScroll.Parent = leftFrame
    
    local tabsList = Instance.new("UIListLayout")
    tabsList.SortOrder = Enum.SortOrder.LayoutOrder
    -- FIXED: Reduced padding for better spacing
    tabsList.Padding = UDim.new(0, 3)
    tabsList.Parent = tabsScroll
    
    local rightFrame = Instance.new("Frame")
    rightFrame.Name = "RightFrame"
    -- FIXED: Adjusted positioning to match new left frame width
    rightFrame.Size = UDim2.new(1, -165, 1, 0)
    rightFrame.Position = UDim2.new(0, 165, 0, 0)
    rightFrame.BackgroundColor3 = self.theme.colors.primary
    rightFrame.BorderSizePixel = 0
    rightFrame.Parent = self.parent
    
    self:corner(rightFrame)
    self:stroke(rightFrame, self.theme.colors.border, 1)
    
    local contentScroll = Instance.new("ScrollingFrame")
    contentScroll.Name = "ContentScroll"
    -- FIXED: Better padding
    contentScroll.Size = UDim2.new(1, -8, 1, -8)
    contentScroll.Position = UDim2.new(0, 4, 0, 4)
    contentScroll.BackgroundTransparency = 1
    contentScroll.ScrollBarThickness = 4
    contentScroll.ScrollBarImageColor3 = self.theme.colors.accent
    contentScroll.BorderSizePixel = 0
    contentScroll.Parent = rightFrame
    
    self.leftFrame = leftFrame
    self.rightFrame = rightFrame
    self.tabsScroll = tabsScroll
    self.contentScroll = contentScroll
    self.tabsList = tabsList
    
    self:updateScrollSize()
end

function Tabs:addTab(name)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = "Tab_" .. name
    -- FIXED: Reduced height from 35 to 32 for better proportions
    tabBtn.Size = UDim2.new(1, 0, 0, 32)
    tabBtn.BackgroundColor3 = self.theme.colors.primary
    tabBtn.Text = name
    tabBtn.TextColor3 = self.theme.colors.textSecondary
    -- FIXED: Better text size
    tabBtn.TextSize = 13
    tabBtn.Font = self.theme.font
    tabBtn.BorderSizePixel = 0
    tabBtn.AutoButtonColor = false
    tabBtn.Parent = self.tabsScroll
    
    self:corner(tabBtn)
    
    local tabContent = Instance.new("Frame")
    tabContent.Name = "Content_" .. name
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.Position = UDim2.new(0, 0, 0, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false
    tabContent.Parent = self.contentScroll
    
    local contentList = Instance.new("UIListLayout")
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    -- FIXED: Reduced padding for better element spacing
    contentList.Padding = UDim.new(0, 6)
    contentList.Parent = tabContent
    
    local tab = {
        name = name,
        button = tabBtn,
        content = tabContent,
        elements = {}
    }
    
    tabBtn.MouseButton1Click:Connect(function()
        self:selectTab(name)
    end)
    
    tabBtn.MouseEnter:Connect(function()
        if self.activeTab ~= name then
            self:tween(tabBtn, {BackgroundColor3 = self.theme.colors.border})
        end
    end)
    
    tabBtn.MouseLeave:Connect(function()
        if self.activeTab ~= name then
            self:tween(tabBtn, {BackgroundColor3 = self.theme.colors.primary})
        end
    end)
    
    self.tabs[name] = tab
    
    if not self.activeTab then
        self:selectTab(name)
    end
    
    self:updateScrollSize()
    return tabContent
end

function Tabs:selectTab(name)
    local tab = self.tabs[name]
    if not tab then return end
    
    if self.activeTab then
        local oldTab = self.tabs[self.activeTab]
        if oldTab then
            self:tween(oldTab.button, {
                BackgroundColor3 = self.theme.colors.primary,
                TextColor3 = self.theme.colors.textSecondary
            })
            oldTab.content.Visible = false
        end
    end
    
    self:tween(tab.button, {
        BackgroundColor3 = self.theme.colors.accent,
        TextColor3 = self.theme.colors.text
    })
    tab.content.Visible = true
    self.activeTab = name
end

function Tabs:updateScrollSize()
    -- FIXED: Better scroll size calculation
    local tabsHeight = #self.tabs * 35 + (#self.tabs - 1) * 3
    self.tabsScroll.CanvasSize = UDim2.new(0, 0, 0, tabsHeight)
    
    if self.activeTab then
        local tab = self.tabs[self.activeTab]
        if tab then
            -- FIXED: Better element spacing calculation
            local elementsHeight = #tab.elements * 46 + (#tab.elements - 1) * 6
            self.contentScroll.CanvasSize = UDim2.new(0, 0, 0, math.max(elementsHeight, 200))
        end
    end
end

function Tabs:getTab(name)
    return self.tabs[name]
end

function Tabs:removeTab(name)
    local tab = self.tabs[name]
    if tab then
        tab.button:Destroy()
        tab.content:Destroy()
        self.tabs[name] = nil
        
        if self.activeTab == name then
            self.activeTab = nil
            for tabName, _ in pairs(self.tabs) do
                self:selectTab(tabName)
                break
            end
        end
        
        self:updateScrollSize()
    end
end

return Tabs
