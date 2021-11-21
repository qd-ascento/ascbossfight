LinkLuaModifier("modifier_saitama_jogging", "heroes/hero_saitama/jogging.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_saitama_limiter_autocast", "heroes/hero_saitama/limiter.lua", LUA_MODIFIER_MOTION_NONE)

saitama_limiter = class({
	GetIntrinsicModifierName = function() return "modifier_saitama_limiter_autocast" end,
})

saitama_jogging = class({
	GetIntrinsicModifierName = function() return "modifier_saitama_jogging" end,
})

saitama_sit_ups = class({})

modifier_saitama_limiter = class({
	IsPurgable    = function() return false end,
	RemoveOnDeath = function() return false end,
	GetTexture    = function() return "arena/modifier_saitama_limiter" end,
})

modifier_saitama_limiter_autocast = class({
	IsHidden = function() return true end,
})

saitama_push_ups = class({})

saitama_squats = class({})

saitama_serious_punch = class({})

function modifier_saitama_limiter:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_ATTACK_POINT_CONSTANT,
	}
end

local FRACTION_700 = 1/7

function modifier_saitama_limiter:OnCreated()
	self.BaseBAT = self:GetCaster():GetBaseAttackTime()
	self.BATMod = 1
end

function modifier_saitama_limiter:GetModifierBaseAttackTimeConstant()
	local AS = self:GetCaster():GetIncreasedAttackSpeed()
	if AS > 7 then
		local BATMod = (7 / AS)
		self.BATMod = BATMod
		return self.BaseBAT * BATMod
	end
end

function modifier_saitama_limiter:GetModifierAttackPointConstant()
	return 0.75 * self.BATMod --0.75 is the base attack point
end

if IsServer() then
	function modifier_saitama_limiter:OnDeath(keys)
		local caster = self:GetCaster()
		local ability = caster:FindAbilityByName("saitama_limiter")
		local level = ability and math.max(ability:GetLevel(), 1) or 1
		if keys.unit == caster then
			self:SetStackCount(math.ceil(self:GetStackCount() * (1 - GetAbilitySpecial("saitama_limiter", "loss_stacks_pct", level) * 0.01)))
		elseif (
			keys.attacker == caster and
			keys.unit:IsTrueHero() and
			caster:GetTeamNumber() ~= keys.unit:GetTeamNumber()
		) then
			self:SetStackCount(self:GetStackCount() + GetAbilitySpecial("saitama_limiter", "stacks_for_kill", level))
		end
	end
end




if IsServer() then
	function saitama_push_ups:OnChannelFinish(bInterrupted)
		if not bInterrupted then
			local caster = self:GetCaster()
			caster:ModifyStrength(self:GetSpecialValueFor("bonus_strength"))

			local modifier = caster:FindModifierByName("modifier_saitama_limiter")
			if not modifier then modifier = caster:AddNewModifier(caster, self, "modifier_saitama_limiter", nil) end
			modifier:SetStackCount(modifier:GetStackCount() + self:GetSpecialValueFor("stacks_amount"))
		end
	end
end




if IsServer() then
	function saitama_jogging:OnUpgrade()
		local modifier = self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName())
		if modifier then
			modifier:UpdatePercentage()
		end
	end
end

modifier_saitama_jogging = class({})

function modifier_saitama_jogging:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_EVENT_ON_UNIT_MOVED
	}
end

function modifier_saitama_jogging:OnTooltip()
	return self:GetStackCount()
end

if IsServer() then
	function modifier_saitama_jogging:OnCreated()
		self.range = 0
	end

	function modifier_saitama_jogging:OnUnitMoved()
		local ability = self:GetAbility()
		local parent = self:GetParent()
		local position = parent:GetAbsOrigin()
		if self.position then
			local range = (self.position - position):Length2D()
			if range > 0 and range <= ability:GetSpecialValueFor("range_limit") then
				self.range = self.range + range
				self:UpdatePercentage()
			end
		end
		self.position = position
	end

	function modifier_saitama_jogging:UpdatePercentage()
		local ability = self:GetAbility()
		local completePart = self.range / ability:GetSpecialValueFor("range")
		if completePart < 1 then
			self:SetStackCount(math.floor(completePart * 100))
		else
			local parent = self:GetParent()
			self.range = 0
			self:SetStackCount(0)
			parent:ModifyStrength(ability:GetSpecialValueFor("bonus_strength"))

			local modifier = parent:FindModifierByName("modifier_saitama_limiter")
			if not modifier then modifier = parent:AddNewModifier(parent, ability, "modifier_saitama_limiter", nil) end
			modifier:SetStackCount(modifier:GetStackCount() + ability:GetSpecialValueFor("stacks_amount"))
		end
	end
end






function saitama_limiter:GetManaCost()
	return self:GetCaster():GetMaxMana() * self:GetSpecialValueFor("manacost_pct") * 0.01 + self:GetSpecialValueFor("manacost")
end

function saitama_limiter:CastFilterResult()
	local parent = self:GetCaster()
	return parent:GetModifierStackCount("modifier_saitama_limiter", parent) == 0 and UF_FAIL_CUSTOM or UF_SUCCESS
end

function saitama_limiter:GetCustomCastError()
	local parent = self:GetCaster()
	return parent:GetModifierStackCount("modifier_saitama_limiter", parent) == 0 and "#dota_hud_error_no_charges" or ""
end

if IsServer() then
	function saitama_limiter:OnSpellStart()
		local caster = self:GetCaster()
		StartAnimation(caster, {
			duration = 1.2, -- 36 / 30
			activity = ACT_DOTA_CAST_ABILITY_6
		})
		caster:EmitSound("Arena.Hero_Saitama.Limiter")

		caster:ModifyStrength(caster:GetStrength() * self:GetSpecialValueFor("bonus_strength_pct") * caster:GetModifierStackCount("modifier_saitama_limiter", caster) * 0.01)
	end
end



if IsServer() then
	function modifier_saitama_limiter_autocast:OnCreated()
		self:StartIntervalThink(0.1)
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_saitama_limiter") then
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_saitama_limiter", nil)
		end
	end

	function modifier_saitama_limiter_autocast:OnIntervalThink()
		local ability = self:GetAbility()
		local parent = self:GetParent()
		if parent:IsAlive() then
			if ability:GetAutoCastState() and parent:GetMana() >= ability:GetManaCost() and not parent:IsChanneling() and not parent:IsInvisible() and not (parent:GetCurrentActiveAbility() and parent:GetCurrentActiveAbility():IsInAbilityPhase()) and parent:GetModifierStackCount("modifier_saitama_limiter", parent) > 0 then
				parent:CastAbilityNoTarget(ability, parent:GetPlayerID())
			end
		end
	end
end










if IsServer() then
	function saitama_serious_punch:OnSpellStart()
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		if not target:TriggerSpellAbsorb(self) then
			target:TriggerSpellReflect(self)
			local damage = caster:GetAverageTrueAttackDamage(target) * (self:GetSpecialValueFor("base_damage_multiplier_pct") + self:GetSpecialValueFor("damage_multiplier_per_stack_pct") * caster:GetModifierStackCount("modifier_saitama_limiter", caster)) * 0.01

			target:EmitSound("Hero_Earthshaker.EchoSlam")
			ParticleManager:CreateParticle("particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_echoslam_start_fallback_mid_egset.vpcf", PATTACH_ABSORIGIN, target)

			ApplyDamage({
				attacker = caster,
				victim = target,
				damage = damage,
				damage_type = self:GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
				ability = self
			})

			target:RemoveModifierByName("modifier_knockback")
			if damage > 0 then
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, damage, nil)
				local sourcePos = caster:GetAbsOrigin()
				local duration =  damage / self:GetSpecialValueFor("knockback_duration_step")
				target:AddNewModifier(caster, self, "modifier_knockback", {
					knockback_duration = duration,
					knockback_distance = damage / self:GetSpecialValueFor("knockback_distance_step"),
					knockback_height = damage / self:GetSpecialValueFor("knockback_height_step"),
					should_stun = 1,
					duration = duration,
					center_x = sourcePos.x,
					center_y = sourcePos.y,
					center_z = sourcePos.z
				})
			end
		end
	end
end





if IsServer() then
	function saitama_sit_ups:OnChannelFinish(bInterrupted)
		if not bInterrupted then
			local caster = self:GetCaster()
			caster:ModifyStrength(self:GetSpecialValueFor("bonus_strength"))

			local modifier = caster:FindModifierByName("modifier_saitama_limiter")
			if not modifier then modifier = caster:AddNewModifier(caster, self, "modifier_saitama_limiter", nil) end
			modifier:SetStackCount(modifier:GetStackCount() + self:GetSpecialValueFor("stacks_amount"))
		end
	end
end





if IsServer() then
	function saitama_squats:OnChannelFinish(bInterrupted)
		if not bInterrupted then
			local caster = self:GetCaster()
			caster:ModifyStrength(self:GetSpecialValueFor("bonus_strength"))

			local modifier = caster:FindModifierByName("modifier_saitama_limiter")
			if not modifier then modifier = caster:AddNewModifier(caster, self, "modifier_saitama_limiter", nil) end
			modifier:SetStackCount(modifier:GetStackCount() + self:GetSpecialValueFor("stacks_amount"))
		end
	end
end
