function Spawn( entityKeyValues )
    if not IsServer() then
        return
    end

    if thisEntity == nil then
        return
    end
  
    thisEntity:SetContextThink( "NeutralThink", NeutralThink, 1 )
end

function NeutralThink()
    if ( not thisEntity:IsAlive() ) then        --если юнит мертв
        return -1 
    end
  
    if GameRules:IsGamePaused() == true then    --если игра приостановлена
        return 1 
    end

    if thisEntity:IsChanneling() then    -- если юнит кастует скил
        return 1 
    end
  
    if thisEntity:IsControllableByAnyPlayer() then    -- если юнит принадлежит игроку, то поведение отключается
        return -1
    end
  
    local npc = thisEntity

    if not thisEntity.bInitialized then
        npc.vInitialSpawnPos = Entities:FindByName( nil, "spawner_boss_1" ):GetAbsOrigin()         -- точка спавна юнита
        npc.fMaxDist = npc:GetAcquisitionRange()    -- радиус агра
        npc.bInitialized = true                        -- флаг инициализации
        npc.agro = false                            -- флаг агра
      
    end

    local search_radius                             -- радиус поиска зависит от того, имеет ли юнит агр
    if npc.agro then
        search_radius = npc.fMaxDist * 1.5            -- расшираяется
    else
        search_radius = npc.fMaxDist                -- становится обычным
    end
  
    -- Как далеко юнит находится от своей точки спавна ?
    local fDist = ( npc:GetOrigin() - npc.vInitialSpawnPos ):Length2D()
    if fDist > search_radius then
        RetreatHome()            -- если юнит слишком далеко, то идет на точку спавна
        return 3
    end
  
    local enemies = FindUnitsInRadius(
                        npc:GetTeamNumber(),        --команда юнита
                        npc.vInitialSpawnPos,        --местоположение юнита
                        nil,    --айди юнита (необязательно)
                        search_radius + 50,    --радиус поиска
                        DOTA_UNIT_TARGET_TEAM_ENEMY,    -- юнитов чьей команды ищем вражеской/дружественной
                        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,    --юнитов какого типа ищем
                        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,    --поиск по флагам
                        FIND_CLOSEST,    --сортировка от ближнего к дальнему
                        false )

    if #enemies == 0 then    -- если найденных юнитов нету
        if npc.agro then
            RetreatHome()    -- если юнит под действием агра
        end     
        return 0.5
    end
  
    local enemy = enemies[1]    -- врагом выбирается первый близжайший
  
  
    if npc.agro then    -- если юнит находится под действием агра
      
        AttackMove(npc, enemy)
--        npc:MoveToPositionAggressive(enemy:GetAbsOrigin())

    else
        local allies = FindUnitsInRadius(    -- ищет всех союзных братков в радиусе
                npc:GetTeamNumber(),
                npc.vInitialSpawnPos,
                nil,
                npc.fMaxDist,
                DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
                FIND_CLOSEST,
                false )
              
        for i=1,#allies do    -- заставляет братков быть агрессивными и атаковать врага
            local ally = allies[i]
            ally.agro = true    -- накладывает действие агра
            AttackMove(ally, enemy) 
        end 
    end 
    return 1
  
end

function AttackMove( unit, enemy )
    if enemy == nil then
        return
    end
--    print("ATTACK MOVE")
    ExecuteOrderFromTable({
        UnitIndex = unit:entindex(),                --индекс кастера
        OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,    -- тип приказа атака
        Position = enemy:GetOrigin(),                -- пощиция врага
        Queue = false,
    })

    return 1
end

function RetreatHome()
    thisEntity.agro = false    -- снимается действие агра

    ExecuteOrderFromTable({
        UnitIndex = thisEntity:entindex(),
        OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
        Position = thisEntity.vInitialSpawnPos     
    })
end