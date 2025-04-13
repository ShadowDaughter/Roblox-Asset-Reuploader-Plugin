-- ROBLOX Services
local HttpService = game:GetService("HttpService")

-- Other
local ConnectUrl = "http://localhost:5544/api/connect"
local StatusUrl = "http://localhost:5544/api/status"
local UploadUrl = "http://localhost:5544/api/upload"

-- Main
local HttpManager = {}

function HttpManager:CallHttp(Method: "Get" | "Post", url: string, args: any): (boolean, any)
	local success, result

	for index = 1, 3 do
		if success then
			break
		end

		if index > 1 then
			task.wait(1)
		end

		success, result = pcall(function()
			return HttpService[Method .. "Async"](HttpService, url, args)
		end)
	end

	return success, result
end

function HttpManager:AttemptConnection()
	return self:CallHttp("Get", ConnectUrl)
end

function HttpManager:CheckStatus()
	return self:CallHttp("Get", StatusUrl)
end

function HttpManager:UploadIds(AssetType: "Animation" | "Audio", AssetIds: { string })
	return self:CallHttp(
		"Post",
		UploadUrl,
		HttpService:JSONEncode({
			assetType = AssetType,
			assetIds = AssetIds,
			creatorId = game.CreatorId,
			isGroup = game.CreatorType == Enum.CreatorType.Group,
			placeId = game.PlaceId,
		})
	)
end

function HttpManager:JSONDecode(...)
	return pcall(HttpService.JSONDecode, HttpService, ...)
end

return HttpManager
