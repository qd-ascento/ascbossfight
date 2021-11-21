function info_boss(trigger)
   local caller = trigger.caller
   local activator = trigger.activator
   if not IsValidEntity(activator) then return end

   GameRules:SendCustomMessage("<font color='#ff0000'>Войдите в портал и убейте босса, если</font> <font color='#0050ff'>Вы</font><font color='#ff0000'>, конечно, готовы!</font>",1,0)
end

function info_boss1(trigger)
   local caller = trigger.caller
   local activator = trigger.activator
   if not IsValidEntity(activator) then return end

   GameRules:SendCustomMessage("<font color='#ff0000'>Это портал со вторым боссов</font> <font color='#0050ff'>Вы</font><font color='#ff0000'>, точно уверены?!</font>",1,0)
end
