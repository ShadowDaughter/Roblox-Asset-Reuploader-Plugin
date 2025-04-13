local TweenService = game:GetService("TweenService")
local Synthetic = require(script.Parent.Parent.Packages["synthetic-fusion"])
local Style = require(script.Parent.Style)
local ContainerComponent = require(script.Parent.Container)

local function playSound(PluginWidget: DockWidgetPluginGui)
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://17208361335"
	sound.Volume = 0.2
	sound.Parent = PluginWidget

	sound.Ended:Connect(function()
		sound:Destroy()
	end)

	sound:Play()
end

local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
return function(text: string, PluginWidget: DockWidgetPluginGui)
	local MainFrame = PluginWidget:FindFirstChild("MainFrame")

	if not MainFrame then
		return
	end

	if MainFrame:FindFirstChild("NotificationBarWrapper") then
		MainFrame:FindFirstChild("NotificationBarWrapper"):Destroy()
	end

	local Wrapper = nil
	local NotificationBar = nil
	NotificationBar = Synthetic.Component.Snackbar.Small.surfaceContainer(Style, text, nil, nil, function()
		local tween = TweenService:Create(NotificationBar, tweenInfo, { Size = UDim2.new(0, 0, 0.5, 0) })
		tween:Play()
		tween.Completed:Wait()
		Wrapper:Destroy()
	end)
	NotificationBar.Name = "NotificationBar"
	NotificationBar.AnchorPoint = Vector2.new(0.5, 0.5)
	NotificationBar.Position = UDim2.new(0.5, 0, 1.5, 0)
	NotificationBar.Size = UDim2.new(0.995, 0, 0.995, 0)
	NotificationBar.AutomaticSize = Enum.AutomaticSize.None
	NotificationBar:FindFirstChildOfClass("TextLabel").LineHeight = 0
	NotificationBar:FindFirstChildOfClass("TextLabel"):FindFirstChildOfClass("UIFlexItem").FlexMode = Enum.UIFlexMode.Grow

	Wrapper = ContainerComponent("NotificationBarWrapper", {
		NotificationBar,
	})
	Wrapper.BackgroundTransparency = 1
	Wrapper.Size = UDim2.new(1, -25, 0.15, 0)
	Wrapper.Position = UDim2.new(0.5, 0, 1, -35)
	Wrapper.AutomaticSize = Enum.AutomaticSize.None
	Wrapper.ClipsDescendants = true

	TweenService:Create(NotificationBar, tweenInfo, { Position = UDim2.new(0.5, 0, 0.5, 0) }):Play()
	task.spawn(playSound, PluginWidget)

	return Wrapper
end
