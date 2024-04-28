local httpService = game:GetService("HttpService")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local players = game:GetService("Players")

local player = players.LocalPlayer
local floor = math.floor;

-- Variables --
local positionTable = {}
local count = 0

-- Important Functions --
local function isCorrectType(_type)
	return pcall(function() return Instance.new(_type) end)
end
local function isCorrectProperty(_parent, _property)
	return pcall(function()
		return _parent[_property]
	end)
end
local function createNewComponent(Type, Parent, Properties)
	local isValid, child = isCorrectType(Type)
	if not isValid then return false end
	
	child.Parent = Parent
	for property, value in pairs (Properties) do 
		if not isCorrectProperty(child, property) then continue end
		child[property] = value	
	end
	return child
end
local function formatJSON(json)
	local finalString = json
	local fr = string.sub(json,2,#finalString)
	local lr = string.gsub(fr, "}]", "}\n}")
	finalString = "{\n	".. lr
	finalString = string.gsub(finalString, "},", "},\n	")
	finalString = string.gsub(finalString, ":", "=")
	if json:len() ==2 then
		finalString = "nil"
	end
	
	return finalString
end


local newUI = Instance.new("ScreenGui", game.CoreGui)
newUI.ResetOnSpawn = false
-- Position handler --
local positionText = createNewComponent("TextLabel", newUI, {
	Name = "PositionText", ZIndex = math.huge,
	BackgroundTransparency = 1, Text = "0,0,0", RichText = true, TextScaled = true, Font = Enum.Font.Roboto, TextColor3 = Color3.new(.1,.1,.1), TextStrokeTransparency = .8,
	AnchorPoint = Vector2.new(.5,.5), Position = UDim2.new(.5,0,.15,0), Size = UDim2.new(.2,0,.03,0),
})
local scrollFBackground = createNewComponent("Frame", newUI, {
	Name = "Background", ZIndex = 998,
	BackgroundColor3 = Color3.fromRGB(30,30,30),
	AnchorPoint = Vector2.new(.5,.5), Position = UDim2.new(.5,0,.5,0), Size = UDim2.new(.4,0,.2,0)
})
createNewComponent("UICorner", scrollFBackground, {CornerRadius = UDim.new(0,4)})
local positionList = createNewComponent("ScrollingFrame", scrollFBackground, {
	Name = "ListHolder", ZIndex = 9999,
	BackgroundTransparency = 1, CanvasSize = UDim2.new(0,0,1,0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 0,
	AnchorPoint = Vector2.new(.5,.5), Position = UDim2.new(.5,0,.5,0), Size = UDim2.new(.98,0,.95,0)
})
createNewComponent("UIListLayout", positionList, {Padding = UDim.new(.02,0)})
local addPositionButton : TextButton = createNewComponent("TextButton", newUI, {
	Name = "PositionButton", ZIndex = math.huge,
	BackgroundTransparency = 1, Text = "+", TextScaled = true, Font = Enum.Font.Roboto, TextColor3 = Color3.new(.1,.1,.1), TextStrokeTransparency = .8,
	AnchorPoint = Vector2.new(.5,.5), Position = UDim2.new(.6,0,.15,0), Size = UDim2.new(.06,0,.03,0),
})
local openDetailsButton : TextButton = createNewComponent("TextButton", newUI, {
	Name = "DetailsButton", ZIndex = math.huge,
	BackgroundTransparency = 1, Text = "○", TextScaled = true, Font = Enum.Font.Roboto, TextColor3 = Color3.new(.1,.1,.1), TextStrokeTransparency = .8,
	AnchorPoint = Vector2.new(.5,.5), Position = UDim2.new(.4,0,.15,0), Size = UDim2.new(.06,0,.03,0),
})
local exportButton : TextButton = createNewComponent("TextButton", scrollFBackground, {
	Name = "Export", ZIndex = math.huge,
	BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(35,35,35), Text = "       ‎   export         ‎ ", TextScaled = true, Font = Enum.Font.Roboto, TextColor3 = Color3.new(1,1,1),
	AnchorPoint = Vector2.new(.5,.5), Position = UDim2.new(.5,0,1.2,0), Size = UDim2.new(.3,0,.2,0),
})
createNewComponent("UICorner", exportButton, {CornerRadius = UDim.new(0,4)})
local copyText = createNewComponent("TextBox", newUI, {
	Name = "CopyText", ZIndex = math.huge, TextSize = 14, Visible = false, TextEditable = false, ClearTextOnFocus = false, TextWrapped = false,
	BackgroundColor3 = Color3.fromRGB(35,35,35), Text = "",  TextColor3 = Color3.fromRGB(234, 234, 234), TextYAlignment = Enum.TextYAlignment.Top, TextXAlignment = Enum.TextXAlignment.Left,
	AnchorPoint = Vector2.new(.5,.5), Position = UDim2.new(.5,0,.5,0), Size = UDim2.new(.4,0,.4,0), Font = Enum.Font.Roboto, TextDirection = Enum.TextDirection.LeftToRight,
})


-- UI Functions --
local function createNewPosHolder(Number, Position)
	local mainFrame = createNewComponent("Frame", positionList, {
		Name = Number, ZIndex = 10000,
		BackgroundColor3 = Color3.new(1,1,1),
		Size = UDim2.new(1,0,.15,0)
	})
	createNewComponent("UICorner", mainFrame, {CornerRadius = UDim.new(0,2)})
	local removeButton : TextButton = createNewComponent("TextButton", mainFrame, {
		Name = "Remove", ZIndex = 10005,
		BackgroundColor3 = Color3.fromRGB(255,65,65),
		AnchorPoint = Vector2.new(.5,.5), Position = UDim2.new(.97,0,.5,0), Size = UDim2.new(.5,0,.5,0), Text = ""
	})
	createNewComponent("UICorner", removeButton, {CornerRadius = UDim.new(1,0)})
	createNewComponent("UIAspectRatioConstraint", removeButton, {})
	local nameTextBox : TextBox= createNewComponent("TextBox", mainFrame, {
		Name = "name", ZIndex = 10005, MaxVisibleGraphemes = 20, TextSize = 14,
		BackgroundColor3 = Color3.fromRGB(35,35,35), PlaceholderText = "<name>", Text = "",  TextColor3 = Color3.fromRGB(132, 206, 109), PlaceholderColor3 = Color3.fromRGB(206, 200, 187),
		AnchorPoint = Vector2.new(.5,.5), Position = UDim2.new(.185,0,.5,0), Size = UDim2.new(.35,0,.8,0), Font = Enum.Font.Roboto
	})
	createNewComponent("UICorner", nameTextBox, {CornerRadius = UDim.new(0,3)})
	local posHolderText = createNewComponent("TextLabel", mainFrame, {
		Name = "position", ZIndex = 10005, 
		BackgroundTransparency = 1, TextScaled = true, RichText = true,
		AnchorPoint = Vector2.new(.5,.5), Position = UDim2.new(.67,0,.5,0), Size = UDim2.new(.5,0,.8,0), Font = Enum.Font.Roboto,
	})
	
	local x,y,z = Position.X,Position.Y,Position.Z
	posHolderText.Text = string.format("<font color='rgb(225,50,50)'>%.1f</font>, <font color='rgb(50,225,50)'>%.1f</font>, <font color='rgb(50,50,225)'>%.1f</font>", x,y,z)
	removeButton.MouseButton1Click:Connect(function()
		local found = positionTable[Number]
		if found then
			print(found)
			positionTable[Number] = nil
		end
		count-=1
		mainFrame:Destroy()
	end)
	nameTextBox.FocusLost:Connect(function()
		local name = nameTextBox.Text
		if name == "" then name = "N/A" end
		positionTable[Number]["Name"] = name
		nameTextBox.Text = name
	end)
end


addPositionButton.MouseButton1Click:Connect(function()
	local character = player.Character or player.CharacterAdded:Wait()
	local root = (character and character:FindFirstChild("HumanoidRootPart")) or false 	
	if not root then return end
	
	local positionToSave = root.Position
	count+= 1
	createNewPosHolder(count, positionToSave)
	local x,y,z = positionToSave.X,positionToSave.Y,positionToSave.Z
	positionTable[count] = {
		["Name"] = "N/A",
		["Position"] = string.format("Vector3.new(%.1f, %.1f, %.1f)", x,y,z)
	}
end)
openDetailsButton.MouseButton1Click:Connect(function()
	scrollFBackground.Visible = not scrollFBackground.Visible
	copyText.Visible = false	
end)
exportButton.MouseButton1Click:Connect(function()
	local json = httpService:JSONEncode(positionTable)
	copyText.Text = formatJSON(json)
	copyText.Visible = true
	copyText:CaptureFocus()
	scrollFBackground.Visible = false
end)

runService.Heartbeat:Connect(function()
	local character = player.Character or player.CharacterAdded:Wait()
	local root = (character and character:FindFirstChild("HumanoidRootPart")) or false 

	if not root then return end
	local x,y,z = root.Position.X,root.Position.Y,root.Position.Z
	positionText.Text = string.format("<font color='rgb(225,50,50)'>%.1f</font>, <font color='rgb(50,225,50)'>%.1f</font>, <font color='rgb(50,50,225)'>%.1f</font>", x,y,z)
end)
