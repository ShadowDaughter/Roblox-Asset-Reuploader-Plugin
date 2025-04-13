-- Services
local StudioService = game:GetService("StudioService")
local Services = script.Parent.Services
local AssetsManager = require(Services.AssetsManager)
local UiManager = require(Services.UiManager)
local HttpManager = require(Services.HttpManager)

-- Plugin  Variables
local PluginToolbar = plugin:CreateToolbar("Asset Reuploader")
local WidgetInformation = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false, 500, 250, 500, 250)
local PluginWidget = plugin:CreateDockWidgetPluginGui("Asset Reuploader", WidgetInformation)
local pluginButton = PluginToolbar:CreateButton("Asset Reuploader", "Reupload assets to Roblox", "rbxassetid://78689563976440", "Open/Close Menu")

-- Other
local UserId = StudioService:GetUserId()
local IsBusy = false

-- Functions
local function validatPost(Instances: { Instance })
	if not Instances or #Instances == 0 then
		UiManager:SendNotification(PluginWidget, "[ERROR] Invalid asset IDs provided.")
		return false
	end

	if not AssetsManager:TestForPermissions() then
		UiManager:SendNotification(PluginWidget, "[ERROR] Plugin lacks script injection permission.")
		return false
	end

	if game.CreatorId == 0 then
		UiManager:SendNotification(PluginWidget, "[ERROR] Game needs to be published.")
		return false
	end

	if game.CreatorType == Enum.CreatorType.User and UserId ~= game.CreatorId then
		UiManager:SendNotification(PluginWidget, "[ERROR] Game needs to be owned by you or a group.")
		return false
	end

	if IsBusy then
		UiManager:SendNotification(PluginWidget, "[ERROR] Plugin is already busy.")
		return false
	end

	local success, _ = HttpManager:AttemptConnection()
	if not success then
		UiManager:SendNotification(PluginWidget, "[ERROR] Could not connect to localhost.")
		return false
	end

	return true
end

local function getIdsFromLocalHost(AssetType: "Animation" | "Audio", MainInstances, ValueInstances, ScriptIdInfo)
	while task.wait(1) do
		local success, idsToChange = HttpManager:CheckStatus()

		if not success then
			UiManager:SendNotification(PluginWidget, "[ERROR] Disconnected from localhost, stopped reupload.")
			break
		elseif idsToChange == "Done" then
			UiManager:SendNotification(PluginWidget, `[INFO] Finished reuploading all {AssetType}s.`)
			break
		elseif idsToChange == "Idle" or idsToChange == "" then
			continue
		end

		success, idsToChange = HttpManager:JSONDecode(idsToChange)
		if not success or type(idsToChange) ~= "table" then
			warn("Invalid JSON from localhost:", idsToChange)
			UiManager:SendNotification(PluginWidget, `[WARN] Invalid JSON from localhost, check console.`)
			continue
		end

		for oldId, newId in idsToChange do
			if MainInstances[oldId] then
				AssetsManager:UpdateInstances(MainInstances[oldId], oldId, newId)
			end
			if ValueInstances[oldId] then
				AssetsManager:UpdateInstances(ValueInstances[oldId], oldId, newId)
			end
			if ScriptIdInfo[oldId] then
				AssetsManager:UpdateInstances(ScriptIdInfo[oldId], oldId, newId)
			end
		end
	end
end

local function postAssets(AssetType: "Animation" | "Audio", Instances: { Instance })
	UiManager:SendNotification(PluginWidget, "[INFO] Attempting connection to localhost...")
	if not validatPost(Instances) then
		return
	else
		UiManager:SendNotification(PluginWidget, "[INFO] Connection successful.")
		IsBusy = true
	end

	local idsToQuery, mainInstances, scriptIdInfo, valueInstances = AssetsManager:GetInstanceIds(AssetType, Instances)
	local success, result = HttpManager:UploadIds(AssetType, idsToQuery)

	if not success then
		UiManager:SendNotification(PluginWidget, `[ERROR] Failed to upload asset IDs: {result}.`)
		IsBusy = false
		return
	else
		UiManager:SendNotification(PluginWidget, `[INFO] {result}`)
	end

	getIdsFromLocalHost(AssetType, mainInstances, valueInstances, scriptIdInfo)
	IsBusy = false
end

-- Main
PluginWidget.Name = "Asset Reuploader"
PluginWidget.Title = "Asset Reuploader"
pluginButton.Click:Connect(function()
	PluginWidget.Enabled = not PluginWidget.Enabled
end)

UiManager:CreateUi(PluginWidget, postAssets)
