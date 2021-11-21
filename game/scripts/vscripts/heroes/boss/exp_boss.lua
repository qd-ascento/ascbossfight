exp_boss = class({})

function exp_boss:GetIntrinsicModifierName()
	return "modifier_exp_boss"
end

modifier_exp_boss = class({
	IsHidden = function(self) return true end,
	DeclareFunctions = function(self) return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}end,
})

----------------------------------------------------------
function modifier_exp_boss:GetAbsoluteNoDamageMagical()
	return 1
end
-------------------------------------------------------
function modifier_exp_boss:GetAbsoluteNoDamagePure()
	return 1
end

--------------------------------------------------
function modifier_exp_boss:OnAttackLanded(data)
	local caster = self:GetCaster()
	local target = data.target
	local attacker = data.attacker
	local expDamage = data.damage

		if target == caster and attacker:IsRealHero() and not attacker:IsIllusion() then
			attacker:AddExperience(expDamage, 0, true, true)
		end
end