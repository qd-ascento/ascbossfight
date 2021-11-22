require('spawn')
require('timers')
require('physics')
--require('abilities')
require('tp')

local requirements = {
	"ai/neutral",
--	"data/kv_data",
}


ENABLE_HERO_RESPAWN = true              -- Should the heroes automatically respawn on a timer or stay dead until manually respawned
UNIVERSAL_SHOP_MODE = true             -- Should the main shop contain Secret Shop items as well as regular items
ALLOW_SAME_HERO_SELECTION = true        -- Should we let people select the same hero as each other

HERO_SELECTION_TIME = 60.0              -- How long should we let people select their hero?
PRE_GAME_TIME = 10.0                    -- How long after people select their heroes should the horn blow and the game start?
POST_GAME_TIME = 60.0                   -- How long should we let people look at the scoreboard before closing the server automatically?
TREE_REGROW_TIME = 60.0                 -- How long should it take individual trees to respawn after being cut down/destroyed?

GOLD_PER_TICK = 0                     -- How much gold should players get per tick?
GOLD_TICK_TIME = 0                      -- How long should we wait in seconds between gold ticks?
STARTING_GOLD = 0

RECOMMENDED_BUILDS_DISABLED = false     -- Should we disable the recommened builds for heroes (Note: this is not working currently I believe)
CAMERA_DISTANCE_OVERRIDE = 1200.0        -- How far out should we allow the camera to go?  1134 is the default in Dota

MINIMAP_ICON_SIZE = 1                   -- What icon size should we use for our heroes?
MINIMAP_CREEP_ICON_SIZE = 1             -- What icon size should we use for creeps?
MINIMAP_RUNE_ICON_SIZE = 1              -- What icon size should we use for runes?

RUNE_SPAWN_TIME = 120                    -- How long in seconds should we wait between rune spawns?
CUSTOM_BUYBACK_COST_ENABLED = true      -- Should we use a custom buyback cost setting?
CUSTOM_BUYBACK_COOLDOWN_ENABLED = true  -- Should we use a custom buyback time?
BUYBACK_ENABLED = false                 -- Should we allow people to buyback when they die?

DISABLE_FOG_OF_WAR_ENTIRELY = false      -- Should we disable fog of war entirely for both teams?
FOG_VISION = false      					-- View map
USE_STANDARD_HERO_GOLD_BOUNTY = true    -- Should we give gold for hero kills the same as in Dota, or allow those values to be changed?

USE_CUSTOM_TOP_BAR_VALUES = true        -- Should we do customized top bar values or use the default kill count per team?
TOP_BAR_VISIBLE = true                  -- Should we display the top bar score/count at all?
SHOW_KILLS_ON_TOPBAR = false             -- Should we display kills only on the top bar? (No denies, suicides, kills by neutrals)  Requires USE_CUSTOM_TOP_BAR_VALUES

ENABLE_TOWER_BACKDOOR_PROTECTION = false-- Should we enable backdoor protection for our towers?
REMOVE_ILLUSIONS_ON_DEATH = false       -- Should we remove all illusions if the main hero dies?
DISABLE_GOLD_SOUNDS = false             -- Should we disable the gold sound when players get gold?

USE_CUSTOM_HERO_LEVELS = true           -- Should we allow heroes to have custom levels?
MAX_LEVEL = 1500                          -- What level should we let heroes get to?
USE_CUSTOM_XP_VALUES = true             -- Should we use custom XP values to level up heroes, or the default Dota numbers?
FIXED_RESPAWN_TIME = 10                 -- What time should we use for a fixed respawn timer?  Use -1 to keep the default dota behavior.

FREE_COURIER = true                  -- Бесплатная кура?

-- Fill this table up with the required XP per level if you want to change it
XP_PER_LEVEL_TABLE = {}
XP_PER_LEVEL_TABLE[0] = 0
XP_PER_LEVEL_TABLE[1] = 100
for i = 2, MAX_LEVEL do
  	XP_PER_LEVEL_TABLE[i] = i * (i * 200) / 2
end
if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end


function Precache( context )

end

local modifiers = {
	modifier_saitama_limiter = "heroes/hero_saitama/modifier_saitama_limiter",
	modifier_golden_boss = "heroes/boss/golden_boss",
	modifier_exp_boss = "heroes/boss/exp_boss",
	modifier_str_auto = "items/items_shards",
	modifier_agi_auto = "items/items_shards",
	modifier_int_auto = "items/items_shards",
	command_aura = "heroes/command_aura",
	modifier_item_assault_enemy_aura_visible = "items/item_assault",
	
}

for k,v in pairs(modifiers) do
	LinkLuaModifier(k, v, LUA_MODIFIER_MOTION_NONE)
end


function CAddonTemplateGameMode:OnFirstPlayerLoaded()
	StatsClient:FetchPreGameData()
end

function CAddonTemplateGameMode:OnHeroSelectionEnd()
	PanoramaShop:StartItemStocks()
end


function CAddonTemplateGameMode:InitGameMode()

	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 5 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 )

	GameRules:SetHeroRespawnEnabled( ENABLE_HERO_RESPAWN )
	GameRules:SetCustomGameSetupAutoLaunchDelay( 0 )
  	GameRules:SetUseUniversalShopMode( UNIVERSAL_SHOP_MODE )
 	GameRules:SetSameHeroSelectionEnabled( ALLOW_SAME_HERO_SELECTION )
  	GameRules:SetHeroSelectionTime( HERO_SELECTION_TIME )
  	GameRules:SetPreGameTime( PRE_GAME_TIME)
  	GameRules:SetPostGameTime( POST_GAME_TIME )
  	GameRules:SetTreeRegrowTime( TREE_REGROW_TIME )
  	GameRules:SetUseCustomHeroXPValues ( USE_CUSTOM_XP_VALUES )
  	GameRules:SetGoldPerTick(GOLD_PER_TICK)
  	GameRules:SetGoldTickTime(GOLD_TICK_TIME)
  	GameRules:SetRuneSpawnTime(RUNE_SPAWN_TIME)
  	GameRules:SetUseBaseGoldBountyOnHeroes(USE_STANDARD_HERO_GOLD_BOUNTY)
  	GameRules:SetHeroMinimapIconScale( MINIMAP_ICON_SIZE )
  	GameRules:SetCreepMinimapIconScale( MINIMAP_CREEP_ICON_SIZE )
  	GameRules:SetRuneMinimapIconScale( MINIMAP_RUNE_ICON_SIZE )
  	GameRules:SetStartingGold(STARTING_GOLD)

  	if mode == nil then
  		mode = GameRules:GetGameModeEntity()  

  		mode:SetUnseenFogOfWarEnabled(true)
  		mode:SetFreeCourierModeEnabled( FREE_COURIER )
  		mode:SetFixedRespawnTime( 5 )
	    mode:SetRecommendedItemsDisabled( RECOMMENDED_BUILDS_DISABLED )
	    mode:SetCameraDistanceOverride( CAMERA_DISTANCE_OVERRIDE )
	    mode:SetCustomBuybackCostEnabled( CUSTOM_BUYBACK_COST_ENABLED )
	    mode:SetCustomBuybackCooldownEnabled( CUSTOM_BUYBACK_COOLDOWN_ENABLED )

	    mode:SetBuybackEnabled( BUYBACK_ENABLED )
	    mode:SetTopBarTeamValuesOverride ( USE_CUSTOM_TOP_BAR_VALUES )
	    mode:SetTopBarTeamValuesVisible( TOP_BAR_VISIBLE )
	    mode:SetUseCustomHeroLevels ( USE_CUSTOM_HERO_LEVELS )
	    mode:SetCustomHeroMaxLevel ( MAX_LEVEL )
	    mode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )

	    mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_DAMAGE,0.5)
	    mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_DAMAGE,0.5)
	    mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_DAMAGE,0.5)
	    mode:SetMaximumAttackSpeed( 1200 ) 
		mode:SetMinimumAttackSpeed( 50 )
	    --mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_STATUS_RESISTANCE_PERCENT,0)

	    mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_HP,0.6)
	    mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_HP_REGEN,0.05)
	    --mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_STATUS_RESISTANCE_PERCENT,0)


	    mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_ARMOR,0.05)
	    mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_ATTACK_SPEED,0.05)
	   -- GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_MOVE_SPEED_PERCENT,0)

	    mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MANA,0.4)
	    mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MANA_REGEN,0.05)
	   -- mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_SPELL_AMP_PERCENT,0)
	    --mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MAGIC_RESISTANCE_PERCENT,0)

	    --mode:SetBotThinkingEnabled( USE_STANDARD_DOTA_BOT_THINKING )
	    mode:SetTowerBackdoorProtectionEnabled( ENABLE_TOWER_BACKDOOR_PROTECTION )

	    mode:SetFogOfWarDisabled( DISABLE_FOG_OF_WAR_ENTIRELY )
	    mode:SetUnseenFogOfWarEnabled( FOG_VISION )
	    mode:SetGoldSoundDisabled( DISABLE_GOLD_SOUNDS )
	    mode:SetRemoveIllusionsOnDeath( REMOVE_ILLUSIONS_ON_DEATH )
	end
end




function Activate()
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()
end
