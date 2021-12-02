FirstSpawned = {}


DONATE_SET_PREMIUM_1 = {
	players = {
--		330607354,
	},
}

DONATE_SET_PREMIUM_2 = {
	players = {
--		330607354,
	},
}

DONATE_SET_PREMIUM_3 = {
	players = {
--		330607354,
	},
}

DONATE_ITEM_TELEPORT1 = {
	players = {
--		-1,
	},	
}
DONATE_ITEM_TELEPORT = {
	players = {
--		-1,
	},	
}



DONATE_ITEM_TELEPORT2 = {
	players = {
--
	},	
}

DONATE_ITEM_AGANIM = {
	players = {
--		330607354,
	},	
}

DONATE_ITEM_RAPIER = {
	players = {
--		330607354,
	},	
}

DONATE_ITEM_APEX = {
	players = {
--		330607354,
	},	
}


DONATE_ITEMS = {
	heroes = {

		{
			name = "item_teleport_spawn",
			can_be_bought = true,
			free_available = true,
			count = 1,
			sets ={
				DONATE_ITEM_TELEPORT,
			},
		},
		{
			name = "item_teleport_city",
			can_be_bought = true,
			free_available = true,
			count = 1,
			sets ={
				DONATE_ITEM_TELEPORT,
			},
		},



	},
	artifacts = {


				{
			name = "item_teleport_boss1",
			can_be_bought = true,
			free_available = true,
			count = 1,
			sets ={
				DONATE_ITEM_TELEPORT1,
			},
		},
		{
			name = "item_teleport_boss2",
			can_be_bought = true,
			free_available = true,
			count = 1,
			sets ={
				DONATE_ITEM_TELEPORT2,
			},
		},
		{
			name = "item_teleport_boss3",
			can_be_bought = true,
			free_available = true,
			count = 1,
			sets ={
				DONATE_ITEM_TELEPORT3,
			},
		},
		{
			name = "item_teleport_boss4",
			can_be_bought = true,
			free_available = true,
			count = 1,
			sets ={
				DONATE_ITEM_TELEPORT4,
			},
		},
		{
			name = "item_teleport_boss5",
			can_be_bought = true,
			free_available = true,
			count = 1,
			sets ={
				DONATE_ITEM_TELEPORT5,
			},
		},
		

	},
}

Donate = Donate or class({})

function Donate:OnGameRulesStateChange()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		self.players = {}
		for p = 0, PlayerResource:GetPlayerCount() - 1 do
			self.players[p] = {}
			local acc_id = PlayerResource:GetSteamAccountID( p )
			local player = self.players[p]

			if acc_id then
				for list, items in pairs( DONATE_ITEMS ) do
					for _, item in pairs( items ) do
						local item_info = {
							name = item.name,
							sets = {}
						}
						local player_has = item.free_available or nil
						for _, set in pairs( item.sets ) do
							for _, id in pairs( set.players or {} ) do
								if id == acc_id then
									player_has = true
								end
							end
							if set.name and set.can_be_bought then
								local set_info = {
									name = set.name,
									can_be_bought = set.can_be_bought,
									free_available = set.free_available,
								}
								table.insert( item_info.sets, set_info )
							end
						end

						if item.can_be_bought or player_has then
							player[list] = player[list] or {}

							if player_has then
								item_info.count = item.count
							else
								item_info.count = -1
							end
							table.insert( player[list], item_info )
						end
					end
				end
			end
			self:UpdateNetTables( p )
		end
	end
end

function Donate:UpdateNetTables( pId )
	CustomNetTables:SetTableValue( "donate", tostring( pId ), self.players[pId] )
end

function Donate:PlayerTake( info )
	local self = Donate

	local player_data = self.players[info.id]
	if not player_data then return end

	local player = PlayerResource:GetPlayer( info.id )

	if player and player:GetAssignedHero() then
		for _, l in pairs( player_data ) do
			for _, i in pairs( l ) do
				if i.name == info.itemname and i.count > 0 then
					local hero = player:GetAssignedHero()
					for ii = 0, 8 do
						if not hero:GetItemInSlot( ii ) then
							local tploc = i.name
							if i.name == "item_teleport_boss1" then
								tploc = "teleport_boss1"
							elseif i.name == "item_teleport_boss2" then
								tploc = "teleport_boss2"
							elseif i.name == "item_teleport_boss3" then
								tploc = "teleport_boss3"
							elseif i.name == "item_teleport_boss4" then
								tploc = "teleport_boss4"
							elseif i.name == "item_teleport_boss5" then
								tploc = "teleport_boss5"
							elseif i.name == "item_teleport_spawn" then
								tploc = "teleport_spawn"
							elseif i.name == "item_teleport_city" then
								tploc = "teleport_city"
							end
   							local ent = Entities:FindByName( nil, tploc)
   							local point = ent:GetAbsOrigin()
   							hero:SetAbsOrigin( point )
   							FindClearSpaceForUnit(hero, point, false)
   							PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), hero)
   							hero:Stop()

   							require('timers')
   							Timers:CreateTimer(0.1, function()
      							PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), nil)
      							return nil
  							end)

							--player:GetAssignedHero():AddItemByName( i.name )
							--i.count = i.count - 1
							self:UpdateNetTables( info.id )
							return
						end
					end
				end
			end
		end
	end
end



function Donate:OnNPCSpawned(keys)
	--print("[BAREBONES] NPC Spawned")
--	DeepPrintTable(keys)
	local npc = EntIndexToHScript(keys.entindex)
	local name = npc:GetUnitName()
	
	if npc:IsRealHero() and npc.bFirstSpawned == nil then
		npc.bFirstSpawned = true
		local playerID = npc:GetPlayerID()
		
		--npc:AddItemByName("item_skull_of_midas")
		local steamID = PlayerResource:GetSteamAccountID(playerID)
		
		--print( "Steam Community ID: " .. tostring( steamID ) )
		--print( "Current Hero: " .. tostring( name ) )
--	
	
		addModifierBySteamID(DONATE_SET_PREMIUM_1.players,"modifier_special_effect_legendary",steamID,npc)
--		addModifierBySteamID(				
		
		if not FirstSpawned[playerID] then
			local point = npc:GetAbsOrigin()
			local team = npc:GetTeam()
			--local unit = CreateUnitByName( "npc_dota_courier", point, true, npc, npc, team )
			--unit:SetControllableByPlayer(npc:GetPlayerID(), true)

		end
	end
end

function addModifierBySteamID(enum,modifier_name,steamID,npc)
	for _,ID in pairs(enum) do
		if steamID == ID then
			Timers:CreateTimer(1,function() npc:AddNewModifier( npc, nil, modifier_name, nil) end)
		end
	end
end

ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( Donate, "OnGameRulesStateChange" ), Donate )
ListenToGameEvent("npc_spawned",Dynamic_Wrap(Donate,'OnNPCSpawned'),Donate)
CustomGameEventManager:RegisterListener( "donate_player_take", Dynamic_Wrap( Donate, "PlayerTake" ) )
