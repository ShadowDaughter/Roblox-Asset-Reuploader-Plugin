local Fusion = require(script.Parent.Parent.Packages.fusion)

return function()
	return Fusion.New("Frame")({
		Name = "ActionsDivider",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.29, 0),
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundTransparency = 1,

		[Fusion.Children] = {
			Fusion.New("Frame")({
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(0.45, -10, 0.5, 0),
				Size = UDim2.new(0.2, 0, 0, 1),
				BackgroundColor3 = Color3.fromRGB(120, 120, 120),
				BorderSizePixel = 0,
			}),

			Fusion.New("Frame")({
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0.55, 10, 0.5, 0),
				Size = UDim2.new(0.2, 0, 0, 1),
				BackgroundColor3 = Color3.fromRGB(120, 120, 120),
				BorderSizePixel = 0,
			}),

			Fusion.New("TextLabel")({
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0, 100, 0, 20),
				BackgroundTransparency = 1,
				Text = "Actions",
				TextColor3 = Color3.fromRGB(200, 200, 200),
				TextSize = 16,
				Font = Enum.Font.GothamMedium,
			}),
		},
	})
end
