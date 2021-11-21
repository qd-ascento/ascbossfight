function TpOnBoss1(trigger)
   local caller = trigger.caller
   local activator = trigger.activator
   if not IsValidEntity(activator) then return end

   local wws= "teleport_boss1" -- вот та сама точка, куда мы будем телепортировать героя, мы её указали в скрипте

   local ent = Entities:FindByName( nil, wws) --строка ищет как раз таки нашу точку pnt1
   local point = ent:GetAbsOrigin() --эта строка выясняет где находится pnt1 и получает её координаты
   activator:SetAbsOrigin( point ) -- получили координаты, теперь меняем место героя на pnt1
   FindClearSpaceForUnit(activator, point, false) --нужно чтобы герой не застрял
   activator:Stop() --приказываем ему остановиться, иначе он побежит назад к предыдущей точке

   require('timers')
   PlayerResource:SetCameraTarget(trigger.activator:GetPlayerOwnerID(), trigger.activator)
   Timers:CreateTimer(0.1, function()
      PlayerResource:SetCameraTarget(trigger.activator:GetPlayerOwnerID(), nil)
      return nil
   end)
end

function TpOnBoss2(trigger)
   local caller = trigger.caller
   local activator = trigger.activator
   if not IsValidEntity(activator) then return end

   local wws= "teleport_boss2" -- вот та сама точка, куда мы будем телепортировать героя, мы её указали в скрипте

   local ent = Entities:FindByName( nil, wws) --строка ищет как раз таки нашу точку pnt1
   local point = ent:GetAbsOrigin() --эта строка выясняет где находится pnt1 и получает её координаты
   activator:SetAbsOrigin( point ) -- получили координаты, теперь меняем место героя на pnt1
   FindClearSpaceForUnit(activator, point, false) --нужно чтобы герой не застрял
   activator:Stop() --приказываем ему остановиться, иначе он побежит назад к предыдущей точке

   require('timers')
   PlayerResource:SetCameraTarget(trigger.activator:GetPlayerOwnerID(), trigger.activator)
   Timers:CreateTimer(0.1, function()
      PlayerResource:SetCameraTarget(trigger.activator:GetPlayerOwnerID(), nil)
      return nil
   end)
end


function spawn(trigger)
   local caller = trigger.caller
   local activator = trigger.activator
   if not IsValidEntity(activator) then return end

   local wws= "spawn" -- вот та сама точка, куда мы будем телепортировать героя, мы её указали в скрипте

   local ent = Entities:FindByName( nil, wws) --строка ищет как раз таки нашу точку pnt1
   local point = ent:GetAbsOrigin() --эта строка выясняет где находится pnt1 и получает её координаты
   trigger.activator:SetAbsOrigin( point ) -- получили координаты, теперь меняем место героя на pnt1
   FindClearSpaceForUnit(trigger.activator, point, false) --нужно чтобы герой не застрял
   trigger.activator:Stop() --приказываем ему остановиться, иначе он побежит назад к предыдущей точке

   require('timers')
   PlayerResource:SetCameraTarget(trigger.activator:GetPlayerOwnerID(), trigger.activator)
   Timers:CreateTimer(0.1, function()
      PlayerResource:SetCameraTarget(trigger.activator:GetPlayerOwnerID(), nil)
      return nil
   end)
end
