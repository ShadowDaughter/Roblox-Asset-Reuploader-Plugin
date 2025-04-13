-- ROBLOX Services
local SelectionService = game:GetService("Selection")

-- Components
local Components = script.Parent.Parent.Components
local Fusion = require(script.Parent.Parent.Packages.fusion)
local BottomNotificationComponent = require(Components.BottomNotification)
local ContainerComponent = require(Components.Container)
local AssetTypesMenuComponent = require(Components.AssetTypesMenu)
local DividerComponent = require(Components.DividerComponent)
local ButtonComponent = require(Components.ButtonComponent)

-- Main
local UiManager = {}

function UiManager:SendNotification(PluginWidget: DockWidgetPluginGui, Message: string)
	local NotificationBar = BottomNotificationComponent(Message, PluginWidget)
	NotificationBar.Parent = PluginWidget:FindFirstChild("MainFrame")
end

function UiManager:CreateUi(PluginWidget: DockWidgetPluginGui, buttonCallback: ("Animation" | "Audio", { Instance }) -> ())
	local MainFrame = ContainerComponent("MainFrame", {})
	MainFrame.BackgroundTransparency = 1
	MainFrame.Size = UDim2.new(1, 0, 1, 0)
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

	local AssetTypeValue = Fusion.Value("Animation")
	local AssetTypesMenu = AssetTypesMenuComponent(AssetTypeValue)
	local Divider = DividerComponent()

	local ReuploadAllButton = ButtonComponent("Reupload All", function()
		buttonCallback(AssetTypeValue:get(), game:GetDescendants())
	end, {
		Image = "rbxassetid://8445470984",
		ImageRectOffset = Vector2.new(404, 304),
		ImageRectSize = Vector2.new(96, 96),
	})

	local ReuploadSelectedButton = ButtonComponent("Reupload Selected", function()
		buttonCallback(AssetTypeValue:get(), SelectionService:Get())
	end, {
		Image = "rbxassetid://8445470826",
		ImageRectOffset = Vector2.new(804, 804),
		ImageRectSize = Vector2.new(96, 96),
	})

	local ButtonsWrapper = ContainerComponent("ButtonsWrapper", {
		Fusion.New("UIListLayout")({
			Padding = UDim.new(0, -30),
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}),
		ReuploadAllButton,
		ReuploadSelectedButton,
	}, UDim.new(0, 20))

	ButtonsWrapper.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	ButtonsWrapper.Size = UDim2.new(0.7, 0, 0.375, 0)
	ButtonsWrapper.Position = UDim2.new(0.5, 0, 0.55, 0)

	MainFrame.Parent = PluginWidget
	AssetTypesMenu.Parent = MainFrame
	Divider.Parent = MainFrame
	ButtonsWrapper.Parent = MainFrame
end

return UiManager
