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
    leftFrame.Size = UDim2.new(0, 180, 1, 0)
    leftFrame.Position = UDim2.new(0, 0, 0, 0)
    leftFrame.BackgroundColor3 = self.theme.colors.secondary
    leftFrame.BorderSizePixel = 0
    leftFrame.Parent = self.parent
    
    self:corner(leftFrame)
    self:stroke(leftFrame, self.theme.colors.border, 1)
    
    local profileFrame = Instance.new("Frame")
    profileFrame.Name = "Profile"
    profileFrame.Size = UDim2.new(1, -10, 0, 60)
    profileFrame.Position = UDim2.new(0, 5, 1, -65)
    profileFrame.BackgroundColor3 = self.theme.colors.primary
    profileFrame.BorderSizePixel = 0
    profileFrame.Parent = leftFrame
    
    self:corner(profileFrame)
    
    local avatar = Instance.new("ImageLabel")
    avatar.Name = "Avatar"
    avatar.Size = UDim2.new(0, 40, 0, 40)
    avatar.Position = UDim2.new(0, 10, 0, 10)
    avatar.BackgroundColor3 = self.theme.colors.border
    avatar.BorderSizePixel = 0
    avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=150&height=150&format=png"
    avatar.Parent = profileFrame
    
    self:corner(avatar, UDim.new(0, 20))
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "PlayerName"
    nameLabel.Size = UDim2.new(1, -60, 0, 20)
    nameLabel.Position = UDim2.new(0, 55, 0, 10)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = LocalPlayer.Name
    nameLabel.TextColor3 = self.theme.colors.text
    nameLabel.TextScaled = true
    nameLabel.Font = self.theme.font
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = profileFrame
    
    local displayLabel = Instance.new("TextLabel")
    displayLabel.Name = "DisplayName"
    displayLabel.Size = UDim2.new(1, -60, 0, 15)
    displayLabel.Position = UDim2.new(0, 55, 0, 30)
    displayLabel.BackgroundTransparency = 1
    displayLabel.Text = "@" .. LocalPlayer.DisplayName
    displayLabel.TextColor3 = self.theme.colors.textSecondary
    displayLabel.TextScaled = true
    displayLabel.Font = self.theme.font
    displayLabel.TextXAlignment = Enum.TextXAlignment.Left
    displayLabel.Parent = profileFrame
    
    -- scrollable tabs
    local tabsScroll = Instance.new("ScrollingFrame")
    tabsScroll.Name = "TabsScroll"
    tabsScroll.Size = UDim2.new(1, -10, 1, -75)
    tabsScroll.Position = UDim2.new(0, 5, 0, 5)
    tabsScroll.BackgroundTransparency = 1
    tabsScroll.ScrollBarThickness = 6
    tabsScroll.ScrollBarImageColor3 = self.theme.colors.accent
    tabsScroll.BorderSizePixel = 0
    tabsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabsScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    tabsScroll.Parent = leftFrame
    
    local tabsList = Instance.new("UIListLayout")
    tabsList.SortOrder = Enum.SortOrder.LayoutOrder
    tabsList.Padding = UDim.new(0, 5)
    tabsList.Parent = tabsScroll
    
    local rightFrame = Instance.new("Frame")
    rightFrame.Name = "RightFrame"
    rightFrame.Size = UDim2.new(1, -185, 1, 0)
    rightFrame.Position = UDim2.new(0, 185, 0, 0)
    rightFrame.BackgroundColor3 = self.theme.colors.primary
    rightFrame.BorderSizePixel = 0
    rightFrame.Parent = self.parent
    
    self:corner(rightFrame)
    self:stroke(rightFrame, self.theme.colors.border, 1)
    
    -- scrollable content
    local contentScroll = Instance.new("ScrollingFrame")
    contentScroll.Name = "ContentScroll"
    contentScroll.Size = UDim2.new(1, -10, 1, -10)
    contentScroll.Position = UDim2.new(0, 5, 0, 5)
    contentScroll.BackgroundTransparency = 1
    contentScroll.ScrollBarThickness = 6
    contentScroll.ScrollBarImageColor3 = self.theme.colors.accent
    contentScroll.BorderSizePixel = 0
    contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentScroll.ScrollingDirection = Enum.ScrollingDirection.Y
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
    tabBtn.Size = UDim2.new(1, 0, 0, 35)
    tabBtn.BackgroundColor3 = self.theme.colors.primary
    tabBtn.Text = name
    tabBtn.TextColor3 = self.theme.colors.textSecondary
    tabBtn.TextScaled = true
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
    
    -- add layout for automatic element positioning
    local contentList = Instance.new("UIListLayout")
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Padding = UDim.new(0, 10)
    contentList.Parent = tabContent
    
    -- auto-update content scroll when elements are added
    contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self:updateScrollSize()
    end)
    
    local tab = {
        name = name,
        button = tabBtn,
        content = tabContent,
        elements = {},
        contentList = contentList
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
    
    -- Update content scroll for selected tab
    self:updateScrollSize()
end

-- proper scroll size calculation
function Tabs:updateScrollSize()
    -- Update tabs scroll
    local tabsHeight = 0
    for _, tab in pairs(self.tabs) do
        tabsHeight = tabsHeight + 40
    end
    self.tabsScroll.CanvasSize = UDim2.new(0, 0, 0, tabsHeight)
    
    -- Update content scroll for active tab
    if self.activeTab then
        local tab = self.tabs[self.activeTab]
        if tab and tab.contentList then
            local contentHeight = tab.contentList.AbsoluteContentSize.Y
            self.contentScroll.CanvasSize = UDim2.new(0, 0, 0, contentHeight + 20)
        end
    end
end

-- add element tracking
function Tabs:addElementToTab(tabName, element)
    local tab = self.tabs[tabName]
    if tab then
        table.insert(tab.elements, element)
        self:updateScrollSize()
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
