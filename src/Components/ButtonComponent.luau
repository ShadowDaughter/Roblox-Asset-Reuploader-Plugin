local Synthetic = require(script.Parent.Parent.Packages["synthetic-fusion"])
local Style = require(script.Parent.Style)

return function(text: string, callback: () -> (), Icon: Synthetic.ImageData)
	local OutlineButton = Synthetic.Component.Button.FilledButton.primaryContainer(Style, callback, text, Icon, 0, true)
	OutlineButton.AnchorPoint = Vector2.new(0.5, 0.5)
	OutlineButton.Position = UDim2.new(0.5, 0, 0.5, 0)
	OutlineButton.Size = UDim2.new(1, 0, 0.8, 0)
	OutlineButton.AutomaticSize = Enum.AutomaticSize.None
	OutlineButton:FindFirstChildOfClass("CanvasGroup").AnchorPoint = Vector2.new(0.5, 0.5)
	OutlineButton:FindFirstChildOfClass("CanvasGroup").Position = UDim2.new(0.5, 0, 0.5, 0)
	OutlineButton:FindFirstChild("Button", true).Size = UDim2.new(1, 0, 1, 0)
	return OutlineButton
end
