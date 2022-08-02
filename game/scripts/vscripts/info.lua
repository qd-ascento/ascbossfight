function info_boss(trigger)
   local caller = trigger.caller
   local activator = trigger.activator
   if not IsValidEntity(activator) then return end

   GameRules:SendCustomMessage("<font color='#ff0000'>Чтобы начать битву с боссом, нажмите на значок </font> <font color='#0050ff'>Телепорта</font><font color='#ff0000'> в верхнем левом углу.</font>",1,0)
end

function info_boss1(trigger)
   local caller = trigger.caller
   local activator = trigger.activator
   if not IsValidEntity(activator) then return end

   GameRules:SendCustomMessage("<font color='#ff0000'>Это портал со вторым боссов</font> <font color='#0050ff'>Вы</font><font color='#ff0000'>, точно уверены?!</font>",1,0)
end
