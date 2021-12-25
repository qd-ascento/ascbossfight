god = class({})

function god:GetIntrinsicModifierName()
	return "modifier_god"
end

modifier_god = class({
	DeclareFunctions = function(self) return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
	}end,
})
----------------------------------------------------------
function modifier_god:GetAbsoluteNoDamageMagical()
	return 1
end
-------------------------------------------------------
function modifier_god:GetAbsoluteNoDamagePure()
	return 1
end

function modifier_god:GetAbsoluteNoDamagePhysical()
	return 1
end

--------------------------------------------------
