local TweenService = game:GetService("TweenService")

local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown:new(name, options, pos, size, parent, theme)
    local self = setmetatable({}, Dropdown)
    
    self.theme = theme
    self.callback = nil
    self.options = options or {}
    self.selected = {}
    self.isOpen = false
    self.multiSelect = true
    
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Name = "Dropdown"
    dropdownFrame.Size = UDim2.new(1, -20, 0, 50)
    dropdownFrame.Position = UDim2.new(0, 10, 0, pos and pos.Y.Offset or 0)
    dropdownFrame.BackgroundColor3 = theme.colors.secondary
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.Parent = parent
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.colors.border
    stroke.Thickness = 1
    stroke.Parent = dropdownFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "DropdownTitle"
    titleLabel.Size = UDim2.new(0.7, -10, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = name or "Dropdown"
    titleLabel.TextColor3 = theme.colors.text
    titleLabel.TextSize = 14
    titleLabel.Font = theme.font
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = dropdownFrame
    
    local selectedLabel = Instance.new("TextLabel")
    selectedLabel.Name = "SelectedLabel"
    selectedLabel.Size = UDim2.new(0.25, -30, 1, 0)
    selectedLabel.Position = UDim2.new(0.7, 0, 0, 0)
    selectedLabel.BackgroundTransparency = 1
    selectedLabel.Text = "None"
    selectedLabel.TextColor3 = theme.colors.textSecondary
    selectedLabel.TextSize = 12
    selectedLabel.Font = theme.font
    selectedLabel.TextXAlignment = Enum.TextXAlignment.Right
    selectedLabel.Parent = dropdownFrame
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "DropdownButton"
    dropdownButton.Size = UDim2.new(0, 20, 0, 20)
    dropdownButton.Position = UDim2.new(1, -25, 0.5, -10)
    dropdownButton.BackgroundColor3 = theme.colors.primary
    dropdownButton.BorderSizePixel = 0
    dropdownButton.Text = "v"
    dropdownButton.TextColor3 = theme.colors.text
    dropdownButton.TextSize = 12
    dropdownButton.Font = theme.font
    dropdownButton.Parent = dropdownFrame
    
    local optionsFrame = Instance.new("Frame")
    optionsFrame.Name = "OptionsFrame"
    optionsFrame.Size = UDim2.new(1, 0, 0, 0)
    optionsFrame.Position = UDim2.new(0, 0, 1, 0)
    optionsFrame.BackgroundColor3 = theme.colors.primary
    optionsFrame.BorderSizePixel = 0
    optionsFrame.Visible = false
    optionsFrame.ZIndex = 10
    optionsFrame.Parent = dropdownFrame
    
    local optionsStroke = Instance.new("UIStroke")
    optionsStroke.Color = theme.colors.border
    optionsStroke.Thickness = 1
    optionsStroke.Parent = optionsFrame
    
    local optionsScroll = Instance.new("ScrollingFrame")
    optionsScroll.Name = "OptionsScroll"
    optionsScroll.Size = UDim2.new(1, -4, 1, -4)
    optionsScroll.Position = UDim2.new(0, 2, 0, 2)
    optionsScroll.BackgroundTransparency = 1
    optionsScroll.ScrollBarThickness = 4
    optionsScroll.ScrollBarImageColor3 = theme.colors.accent
    optionsScroll.BorderSizePixel = 0
    optionsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    optionsScroll.ZIndex = 11
    optionsScroll.Parent = optionsFrame
    
    local optionsList = Instance.new("UIListLayout")
    optionsList.SortOrder = Enum.SortOrder.LayoutOrder
    optionsList.Padding = UDim.new(0, 2)
    optionsList.Parent = optionsScroll
    
    local function updateSelectedText()
        if #self.selected == 0 then
            selectedLabel.Text = "None"
        elseif #self.selected == 1 then
            selectedLabel.Text = self.selected[1]
        else
            selectedLabel.Text = #self.selected .. " selected"
        end
    end
    
    local function createOption(optionText, index)
        local optionButton = Instance.new("TextButton")
        optionButton.Name = "Option" .. index
        optionButton.Size = UDim2.new(1, 0, 0, 25)
        optionButton.BackgroundColor3 = theme.colors.secondary
        optionButton.BorderSizePixel = 0
        optionButton.Text = ""
        optionButton.ZIndex = 12
        optionButton.Parent = optionsScroll
        
        local optionLabel = Instance.new("TextLabel")
        optionLabel.Name = "OptionLabel"
        optionLabel.Size = UDim2.new(1, -25, 1, 0)
        optionLabel.Position = UDim2.new(0, 5, 0, 0)
        optionLabel.BackgroundTransparency = 1
        optionLabel.Text = optionText
        optionLabel.TextColor3 = theme.colors.text
        optionLabel.TextSize = 12
        optionLabel.Font = theme.font
        optionLabel.TextXAlignment = Enum.TextXAlignment.Left
        optionLabel.ZIndex = 13
        optionLabel.Parent = optionButton
        
        local checkBox = Instance.new("Frame")
        checkBox.Name = "CheckBox"
        checkBox.Size = UDim2.new(0, 15, 0, 15)
        checkBox.Position = UDim2.new(1, -20, 0.5, -7)
        checkBox.BackgroundColor3 = theme.colors.primary
        checkBox.BorderSizePixel = 0
        checkBox.ZIndex = 13
        checkBox.Parent = optionButton
        
        local checkStroke = Instance.new("UIStroke")
        checkStroke.Color = theme.colors.border
        checkStroke.Thickness = 1
        checkStroke.Parent = checkBox
        
        local checkMark = Instance.new("TextLabel")
        checkMark.Name = "CheckMark"
        checkMark.Size = UDim2.new(1, 0, 1, 0)
        checkMark.Position = UDim2.new(0, 0, 0, 0)
        checkMark.BackgroundTransparency = 1
        checkMark.Text = "✓"
        checkMark.TextColor3 = theme.colors.accent
        checkMark.TextSize = 10
        checkMark.Font = theme.font
        checkMark.TextXAlignment = Enum.TextXAlignment.Center
        checkMark.TextYAlignment = Enum.TextYAlignment.Center
        checkMark.Visible = false
        checkMark.ZIndex = 14
        checkMark.Parent = checkBox
        
        optionButton.MouseButton1Click:Connect(function()
            local isSelected = false
            for i, v in pairs(self.selected) do
                if v == optionText then
                    table.remove(self.selected, i)
                    isSelected = true
                    break
                end
            end
            
            if not isSelected then
                table.insert(self.selected, optionText)
            end
            
            checkMark.Visible = not isSelected
            updateSelectedText()
            
            if self.callback then
                self.callback(self.selected)
            end
        end)
        
        optionButton.MouseEnter:Connect(function()
            TweenService:Create(optionButton, TweenInfo.new(0.1), {BackgroundColor3 = theme.colors.border}):Play()
        end)
        
        optionButton.MouseLeave:Connect(function()
            TweenService:Create(optionButton, TweenInfo.new(0.1), {BackgroundColor3 = theme.colors.secondary}):Play()
        end)
    end
    
    local function populateOptions()
        for i, option in pairs(self.options) do
            createOption(option, i)
        end
        
        local contentHeight = #self.options * 27
        optionsScroll.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
    end
    
    local function toggleDropdown()
        self.isOpen = not self.isOpen
        
        if self.isOpen then
            local maxHeight = math.min(#self.options * 27 + 4, 150)
            optionsFrame.Visible = true
            optionsFrame:TweenSize(
                UDim2.new(1, 0, 0, maxHeight),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.2,
                true
            )
            dropdownButton.Text = "^"
        else
            optionsFrame:TweenSize(
                UDim2.new(1, 0, 0, 0),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.2,
                true,
                function()
                    optionsFrame.Visible = false
                end
            )
            dropdownButton.Text = "v"
        end
    end
    
    dropdownButton.MouseButton1Click:Connect(toggleDropdown)
    
    populateOptions()
    updateSelectedText()
    
    self.dropdownFrame = dropdownFrame
    self.titleLabel = titleLabel
    self.selectedLabel = selectedLabel
    self.optionsFrame = optionsFrame
    self.populateOptions = populateOptions
    
    return self
end

function Dropdown:setCallback(callback)
    self.callback = callback
end

function Dropdown:setOptions(options)
    self.options = options or {}
    self.selected = {}
    
    for _, child in pairs(self.optionsFrame.OptionsScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    self:populateOptions()
end

function Dropdown:getSelected()
    return self.selected
end

function Dropdown:setText(text)
    self.titleLabel.Text = text
end

return Dropdown
