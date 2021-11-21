KEYVALUES_VERSION = "1.00"


if not KeyValues then
	KeyValues = {}
end

-- Load all the necessary key value files
function LoadGameKeyValues()
	local scriptPath = "scripts/npc/"
	local override = LoadKeyValues(scriptPath.."npc_abilities_override.txt")
	local files = {
		AbilityKV = {base = "npc_abilities",custom = "npc_abilities_custom"},
		ItemKV = {base = "items", custom = "npc_items_custom"},
		UnitKV = {base = "npc_units", custom = "npc_units_custom"},
		HeroKV = {base = "npc_heroes", custom = "npc_heroes_custom", new = "heroes/new"}
	}
	if not override then
		error("[KeyValues] Critical Error on "..override..".txt")
	end
	-- Load and validate the files
	for KVType,KVFilePaths in pairs(files) do
		local file = LoadKeyValues(scriptPath .. KVFilePaths.base .. ".txt")
		-- Replace main game keys by any match on the override file
		for k,v in pairs(override) do
			if file[k] then
				if type(v) == "table" then
					table.merge(file[k], v)
				else
					file[k] = v
				end
			end
		end
		local custom_file = LoadKeyValues(scriptPath .. KVFilePaths.custom .. ".txt")
		if custom_file then
			if KVType == "HeroKV" then
				for k,v in pairs(custom_file) do
					if not file[k] then
						file[k] = {}
						table.deepmerge(file[k], v)
					else
						table.deepmerge(file[k], v)
					end
				end
			else
				table.deepmerge(file, custom_file)
			end
		else
			error("[KeyValues] Critical Error on " .. KVFilePaths.custom .. ".txt")
		end
		if KVFilePaths.new then
			table.deepmerge(file, LoadKeyValues(scriptPath .. KVFilePaths.new .. ".txt"))
		end

		file.Version = nil
		KeyValues[KVType] = file
	end

	-- Merge All KVs
	KeyValues.All = {}
	for name,path in pairs(files) do
		for key,value in pairs(KeyValues[name]) do
			KeyValues.All[key] = value
		end
	end

	-- Merge units and heroes (due to them sharing the same class CDOTA_BaseNPC)
	for key,value in pairs(KeyValues.HeroKV) do
		if not KeyValues.UnitKV[key] then
			KeyValues.UnitKV[key] = value
		elseif type(KeyValues.All[key]) == "table" then
			table.deepmerge(KeyValues.UnitKV[key], value)
		end
	end
	KeyValues.HeroKV = nil

	for k,v in pairs(KeyValues.UnitKV) do
		local override_hero = v.override_hero or v.base_hero
		if override_hero and KeyValues.UnitKV[override_hero] then
			table.deepmerge(v, KeyValues.UnitKV[override_hero])
		end
	end
end

-- Works for heroes and units on the same table due to merging both tables on game init
function CDOTA_BaseNPC:GetKeyValue(key, level, bOriginalHero)
	return GetUnitKV(bOriginalHero and self:GetUnitName() or self:GetFullName(), key, level)
end

-- Dynamic version of CDOTABaseAbility:GetAbilityKeyValues()
function CDOTABaseAbility:GetKeyValue(key, level)
	if level then return GetAbilityKV(self:GetAbilityName(), key, level)
	else return GetAbilityKV(self:GetAbilityName(), key) end
end

-- Item version
function CDOTA_Item:GetKeyValue(key, level)
	if level then return GetItemKV(self:GetAbilityName(), key, level)
	else return GetItemKV(self:GetAbilityName(), key) end
end

function CDOTABaseAbility:GetAbilitySpecial(key)
	return GetAbilitySpecial(self:GetAbilityName(), key, self:GetLevel())
end

-- Global functions
-- Key is optional, returns the whole table by omission
-- Level is optional, returns the whole value by omission
function GetKeyValue(name, key, level, tbl)
	local t = tbl or KeyValues.All[name]
	if key and t then
		if t[key] and level then
			local s = string.split(t[key])
			if s[level] then
				return tonumber(s[level]) or s[level] -- Try to cast to number
			else
				return tonumber(s[#s]) or s[#s]
			end
		else
			return t[key]
		end
	else
		return t
	end
end

function GetUnitKV(unitName, key, level)
	return GetKeyValue(unitName, key, level, KeyValues.UnitKV[unitName])
end

function GetAbilityKV(abilityName, key, level)
	return GetKeyValue(abilityName, key, level, KeyValues.AbilityKV[abilityName])
end

function GetItemKV(itemName, key, level)
	return GetKeyValue(itemName, key, level, KeyValues.ItemKV[itemName])
end

function GetAbilitySpecial(name, key, level, t)
	if not t then t = KeyValues.All[name] end
	if t then
		local AbilitySpecial = t.AbilitySpecial
		if AbilitySpecial then
			if key then
				-- Find the key we are looking for
				for _,values in pairs(AbilitySpecial) do
					if values[key] then
						return GetValueInStringForLevel(values[key], level)
					end
				end
			else
				local o = {}
				for _,values in pairs(AbilitySpecial) do
					for k,v in pairs(values) do
						if k ~= 'var_type' and k ~= 'CalculateSpellDamageTooltip' and k ~= 'levelkey' then
						  o[k] = v
						end
					end
				end
				return o
			end
		end
	end
end

function GetValueInStringForLevel(str, level)
	if not level then
		return str
	else
		local s = string.split(str)
		if s[level] then
			-- If we match the level, return that one
			return tonumber(s[level])
		else
			-- Otherwise, return the max
			return tonumber(s[#s])
		end
	end
end

function GetItemNameById(itemid)
	for name,kv in pairs(KeyValues.ItemKV) do
		if kv and type(kv) == "table" and kv.ID and kv.ID == itemid then
			return name
		end
	end
end

function GetItemIdByName(itemName)
	return KeyValues.ItemKV[itemName].ID
end

--if not KeyValues.All then LoadGameKeyValues() end
LoadGameKeyValues()
