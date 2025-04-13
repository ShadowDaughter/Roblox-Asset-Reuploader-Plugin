local Fusion = require(script.Parent.Parent.Packages.fusion)

return function(name: string, children: { any }, cornerRadius: UDim?)
	local Container = Fusion.New("Frame")({
		Name = name,
		AnchorPoint = Vector2.new(0.5, 0.5),
		[Fusion.Children] = {
			Fusion.New("UICorner")({
				CornerRadius = cornerRadius or UDim.new(1, 0),
			}),
			children,
		},
	})

	return Container
end
