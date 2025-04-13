local Fusion = require(script.Parent.Parent.Packages.fusion)
local Synthetic = require(script.Parent.Parent.Packages["synthetic-fusion"])
local Style = require(script.Parent.Style)
local ContainerComponent = require(script.Parent.Container)

return function(AssetTypeValue: Fusion.Value<string>)
	local TypeOptions: { Synthetic.OptionData } = {
		{
			Text = "Animations",
			Icon = {
				Image = "rbxassetid://8445470826",
				ImageRectOffset = Vector2.new(504, 704),
				ImageRectSize = Vector2.new(96, 96),
			},
			IsInitiallySelected = true,
			SelectedText = "Animations",
			SelectedIcon = {
				Image = "rbxassetid://8445470826",
				ImageRectOffset = Vector2.new(504, 704),
				ImageRectSize = Vector2.new(96, 96),
			},
			Disabled = false,
			OnSelect = function()
				AssetTypeValue:set("Animation")
			end,
		},
		{
			Text = "Audios",
			Icon = {
				Image = "rbxassetid://8445470826",
				ImageRectOffset = Vector2.new(604, 4),
				ImageRectSize = Vector2.new(96, 96),
			},
			IsInitiallySelected = false,
			SelectedText = "Audios",
			SelectedIcon = {
				Image = "rbxassetid://8445470826",
				ImageRectOffset = Vector2.new(604, 4),
				ImageRectSize = Vector2.new(96, 96),
			},
			Disabled = true,
			OnSelect = function()
				AssetTypeValue:set("Audio")
			end,
		},
	}

	local AssetTypesMenu = Synthetic.Component.Menu.Row.Segmented.primaryContainer(Style, TypeOptions, 0, false, 0)
	AssetTypesMenu.Name = "AssetTypesMenu"
	AssetTypesMenu.AnchorPoint = Vector2.new(0.5, 0.5)
	AssetTypesMenu.Position = UDim2.new(0.5, 0, 0.5, 0)
	AssetTypesMenu.Size = UDim2.new(0.9, 0, 0.85, 0)
	AssetTypesMenu:FindFirstChildOfClass("UIStroke").Color = Color3.fromRGB(34, 34, 34)

	local Wrapper = ContainerComponent("AssetTypesMenuWrapper", {
		AssetTypesMenu,
	})

	Wrapper.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Wrapper.Size = UDim2.new(0, 240, 0, 45.5)
	Wrapper.Position = UDim2.new(0.5, 0, 0, 32)

	return Wrapper
end
