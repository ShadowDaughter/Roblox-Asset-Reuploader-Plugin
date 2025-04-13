-- Roblox Services
local ScriptEditorService = game:GetService("ScriptEditorService")

-- Functions
local function validateInstance(instance: Instance | string, type: "Script" | "Value" | "ID"): boolean
	local typeCheck = {
		["Script"] = function()
			return typeof(instance) == "Instance" and (instance:IsA("Script") or instance:IsA("ModuleScript") or instance:IsA("LocalScript"))
		end,
		["Value"] = function()
			return typeof(instance) == "Instance" and (instance:IsA("NumberValue") or instance:IsA("StringValue"))
		end,
		["ID"] = function()
			return typeof(instance) == "string" and #instance > 7 and #instance < 16 and string.find(instance, "[^0]")
		end,
	}

	return typeCheck[type] and typeCheck[type]()
end

-- Main
local AssetsManager = {}

function AssetsManager:TestForPermissions(): boolean
	local testScript = Instance.new("ModuleScript")

	local success = pcall(ScriptEditorService.UpdateSourceAsync, ScriptEditorService, testScript, function()
		return ""
	end)

	testScript:Destroy()
	return success
end

function AssetsManager:UpdateInstances(Instances: { Animation | StringValue | NumberValue | BaseScript | ModuleScript }, oldId: string, newId: string)
	for _, instance: Animation | StringValue | NumberValue | BaseScript | ModuleScript in Instances do
		if instance:IsA("Animation") then
			instance.AnimationId = string.gsub(instance.AnimationId, oldId, newId)
		elseif instance:IsA("StringValue") then
			instance.Value = string.gsub(instance.Value, oldId, newId) or instance.Value
		elseif instance:IsA("NumberValue") then
			instance.Value = tonumber(string.gsub(tostring(instance.Value), oldId, newId)) or instance.Value
		elseif instance:IsA("Script") or instance:IsA("LocalScript") or instance:IsA("ModuleScript") then
			ScriptEditorService:UpdateSourceAsync(instance, function()
				return (string.gsub(instance.Source, oldId, newId))
			end)
		end

		warn(`ASSET REUPLOADER :: {instance.Name} :: Replaced "{oldId}" with "{newId}"`)
	end
end

function AssetsManager:GetInstanceIds(AssetType: "Animation" | "Audio", Instances: { Instance })
	local idsToQuery, mainInstances, scriptIdInfo, valueInstances = {}, {}, {}, {}
	local loopedOverAnimations = {}

	local mainIndex = AssetType == "Animation" and "AnimationId" or "SoundId"
	local mainType = AssetType == "Animation" and "Animation" or "Sound"

	for _, instance in pairs(Instances) do
		local isAScript = validateInstance(instance, "Script")
		local isAValueInstance = validateInstance(instance, "Value")
		local isAMainType = instance:IsA(mainType)
		if not isAMainType and not isAScript and not isAValueInstance then
			continue
		end

		if isAScript then
			local scriptSource = instance.Source
			local lastEnd = 0

			while true do
				local idStart, idEnd = scriptSource:find("%d+", lastEnd)
				if not idStart then
					break
				end
				local instanceId = scriptSource:sub(idStart, idEnd)
				lastEnd = idEnd + 1

				if not validateInstance(instanceId, "ID") then
					continue
				end
				if scriptIdInfo[instanceId] then
					table.insert(scriptIdInfo[instanceId], instance)
					continue
				end

				scriptIdInfo[instanceId] = {}
				table.insert(scriptIdInfo[instanceId], instance)

				if not loopedOverAnimations[instanceId] then
					table.insert(idsToQuery, instanceId)
					loopedOverAnimations[instanceId] = true
				end
			end
		else
			local instanceId = string.gsub(isAValueInstance and instance.Value or instance[mainIndex], "%D", "")
			if validateInstance(instanceId, "ID") then
				local targetArray = isAMainType and mainInstances or valueInstances
				if not targetArray[instanceId] then
					targetArray[instanceId] = {}
				end
				table.insert(targetArray[instanceId], instance)

				if not loopedOverAnimations[instanceId] then
					table.insert(idsToQuery, instanceId)
					loopedOverAnimations[instanceId] = true
				end
			end
		end
	end

	return idsToQuery, mainInstances, scriptIdInfo, valueInstances
end

return AssetsManager
