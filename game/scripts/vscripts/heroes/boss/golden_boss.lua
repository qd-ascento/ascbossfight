golden_boss = class({})
johny_book = class({})

function golden_boss:OnSpellStart()
	
	local caster = self:GetCaster()
	--local johny_book = "johny_book"
	if caster:FindAbilityByName("up_agi") == nil and caster:FindAbilityByName("up_int") == nil then
		caster:RemoveAbility("up_str")
		caster:AddAbility("up_agi")
		caster:FindAbilityByName("up_agi"):SetLevel(1)
	elseif caster:FindAbilityByName("up_str") == nil and caster:FindAbilityByName("up_int") == nil then
		caster:RemoveAbility("up_agi")
		caster:AddAbility("up_int")
		caster:FindAbilityByName("up_int"):SetLevel(1)
	elseif caster:FindAbilityByName("up_str") == nil and caster:FindAbilityByName("up_agi") == nil then
		caster:RemoveAbility("up_int")
		caster:AddAbility("up_str")
		caster:FindAbilityByName("up_str"):SetLevel(1)
	end

	--caster:FindAbilityByName(give_book):SetLevel(1)

end

function golden_boss:GetIntrinsicModifierName()
	return "modifier_golden_boss"
end

modifier_golden_boss = class({

	DeclareFunctions = function(self) return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_CREATED,
	}end,
})

----------------------------------------------
	function modifier_golden_boss:OnCreated()
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_golden_boss") then
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_golden_boss", nil)

		end
		
		parent:AddAbility("up_str")
		parent:FindAbilityByName("up_str"):SetLevel(1)
	end

--------------------------------------------------
function modifier_golden_boss:OnAttackLanded(data)

	local target = data.target
	local attacker = data.attacker
	local ability = data.ability
	local goldDamage = data.damage
	local gold_now = attacker:GetModifierStackCount("modifier_golden_boss", ability)
	local addGold = 0

	if gold_now < 0 then
		attacker:SetModifierStackCount("modifier_golden_boss", attacker, gold_now*0)
	end

	local parent = self:GetParent()
	if not parent:HasModifier("modifier_golden_boss") then
		parent:AddNewModifier(parent, self:GetAbility(), "modifier_golden_boss", nil)
	end

	if parent == attacker and attacker:IsRealHero() and not attacker:IsIllusion() then

				--if target:GetUnitName() == "npc_dota_badguys_tower1_top" then

					--attacker:SetModifierStackCount("modifier_golden_boss", attacker, gold_now + goldDamage)
				
				--end

		if gold_now <= 1000000 then

			if target:GetUnitName() == "npc_boss1" then

				if goldDamage <= 200 then
					addGold = goldDamage
				else
					addGold = 200
				end

				attacker:SetModifierStackCount("modifier_golden_boss", attacker, gold_now + addGold)

			end

			if target:GetUnitName() == "npc_boss2" then

				if goldDamage <= 1000 then
					addGold = goldDamage
				else
					addGold = 1000
				end

				attacker:SetModifierStackCount("modifier_golden_boss", attacker, gold_now + addGold)
				
			end

			if target:GetUnitName() == "npc_boss3" then

				if goldDamage <= 3000 then
					addGold = goldDamage
				else
					addGold = 3000
				end

				attacker:SetModifierStackCount("modifier_golden_boss", attacker, gold_now + addGold)
				
			end

			if target:GetUnitName() == "npc_boss4" then

				if goldDamage <= 6800 then
					addGold = goldDamage
				else
					addGold = 6800
				end

				attacker:SetModifierStackCount("modifier_golden_boss", attacker, gold_now + addGold)
				
			end

			if target:GetUnitName() == "npc_boss5" then

				if goldDamage <= 13000 then
					addGold = goldDamage
				else
					addGold = 13000
				end

				attacker:SetModifierStackCount("modifier_golden_boss", attacker, gold_now + addGold)
				
			end

		end

		if gold_now > 1000000 then

			attacker:SetModifierStackCount("modifier_golden_boss", attacker, 1000000)

		end

	end

end



