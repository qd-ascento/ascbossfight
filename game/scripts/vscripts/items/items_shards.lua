LinkLuaModifier("modifier_str_auto", "items/items_shards.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_agi_auto", "items/items_shards.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_int_auto", "items/items_shards.lua", LUA_MODIFIER_MOTION_NONE)

up_str = class({
	GetIntrinsicModifierName = function() return "modifier_str_auto" end,
})

	function up_str:OnSpellStart()
	
		local caster = self:GetCaster()
		--if not caster:IsTrueHero() then return end

		--local value = self:GetSpecialValueFor("strength")
		local cost = self:GetSpecialValueFor("cost")


		if caster:HasModifier("modifier_golden_boss") then
			

			local gold_now = caster:GetModifierStackCount("modifier_golden_boss", ability)
			local give_gold = 0
			local cost_points = 0
			if cost <= gold_now then
			if(caster:GetStrength() < 100000000) then

				if(caster:GetStrength() > 50000000) then
					caster:SetMaxHealth(2000000000)
					caster:SetHealth(2000000000)
				end

			give_gold = math.floor(gold_now / cost)
			cost_points = math.floor(give_gold * cost)
			--if cost_points <= gold_now then
			caster:ModifyStrength(give_gold)
			caster.Additional_str = (caster.Additional_str or 0) + give_gold
			caster:SetModifierStackCount("modifier_golden_boss", attacker, gold_now - cost_points)

			--end
		end
		end
	end
		--self:RemoveSelf()
	end

	modifier_str_auto = class({
	IsHidden = function() return true end,
})

if IsServer() then
	function modifier_str_auto:OnCreated()
		self:StartIntervalThink(0.01)
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_golden_boss") then
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_golden_boss", nil)
		end
	end

	function modifier_str_auto:OnIntervalThink()
		local ability = self:GetAbility()
		local parent = self:GetParent()
		if parent:IsAlive() then
			if ability:GetAutoCastState() and not parent:IsChanneling() and not parent:IsInvisible() and not (parent:GetCurrentActiveAbility() and parent:GetCurrentActiveAbility():IsInAbilityPhase()) and parent:GetModifierStackCount("modifier_golden_boss", parent) > 99 then
				parent:CastAbilityNoTarget(ability, parent:GetPlayerID())
			end
		end
	end
end


up_agi = class({
	GetIntrinsicModifierName = function() return "modifier_agi_auto" end,
})

	function up_agi:OnSpellStart()

		local caster = self:GetCaster()
		--if not caster:IsTrueHero() then return end

		--local value = self:GetSpecialValueFor("agility")
		local cost = self:GetSpecialValueFor("cost")


		if caster:HasModifier("modifier_golden_boss") then
			

			local gold_now = caster:GetModifierStackCount("modifier_golden_boss", ability)
			local give_gold = 0
			local cost_points = 0
			if cost <= gold_now then
				if(caster:GetAgility() < 1000000000) then
			give_gold = math.floor(gold_now / cost)
			cost_points = math.floor(give_gold * cost)
			--if cost_points <= gold_now then
			caster:ModifyAgility(give_gold)
			caster.Additional_agi = (caster.Additional_agi or 0) + give_gold
			caster:SetModifierStackCount("modifier_golden_boss", attacker, gold_now - cost_points)
			--end
		end
		end
	end
	end

		modifier_agi_auto = class({
	IsHidden = function() return true end,
})

if IsServer() then
	function modifier_agi_auto:OnCreated()
		self:StartIntervalThink(0.01)
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_golden_boss") then
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_golden_boss", nil)
		end
	end

	function modifier_agi_auto:OnIntervalThink()
		local ability = self:GetAbility()
		local parent = self:GetParent()
		if parent:IsAlive() then
			if ability:GetAutoCastState() and not parent:IsChanneling() and not parent:IsInvisible() and not (parent:GetCurrentActiveAbility() and parent:GetCurrentActiveAbility():IsInAbilityPhase()) and parent:GetModifierStackCount("modifier_golden_boss", parent) > 99 then
				parent:CastAbilityNoTarget(ability, parent:GetPlayerID())
			end
		end
	end
end

	up_int = class({
	GetIntrinsicModifierName = function() return "modifier_int_auto" end,
})

	function up_int:OnSpellStart()

		local caster = self:GetCaster()
		--if not caster:IsTrueHero() then return end

		--local value = self:GetSpecialValueFor("intelligence")
		local cost = self:GetSpecialValueFor("cost")


		if caster:HasModifier("modifier_golden_boss") then
			

			local gold_now = caster:GetModifierStackCount("modifier_golden_boss", ability)
			local give_gold = 0
			local cost_points = 0
			if cost <= gold_now then
			if(caster:GetIntellect() < 1000000000) then
			give_gold = math.floor(gold_now / cost)
			cost_points = math.floor(give_gold * cost)
			--if cost_points <= gold_now then
			caster:ModifyIntellect(give_gold)
			caster.Additional_int = (caster.Additional_int or 0) + give_gold
			caster:SetModifierStackCount("modifier_golden_boss", attacker, gold_now - cost_points)
			--end
		end
		end
	end
		--self:RemoveSelf()
	end

			modifier_int_auto = class({
	IsHidden = function() return true end,
})

if IsServer() then
	function modifier_int_auto:OnCreated()
		self:StartIntervalThink(0.01)
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_golden_boss") then
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_golden_boss", nil)
		end
	end

	function modifier_int_auto:OnIntervalThink()
		local ability = self:GetAbility()
		local parent = self:GetParent()
		if parent:IsAlive() then
			if ability:GetAutoCastState() and not parent:IsChanneling() and not parent:IsInvisible() and not (parent:GetCurrentActiveAbility() and parent:GetCurrentActiveAbility():IsInAbilityPhase()) and parent:GetModifierStackCount("modifier_golden_boss", parent) > 99 then
				parent:CastAbilityNoTarget(ability, parent:GetPlayerID())
			end
		end
	end
end