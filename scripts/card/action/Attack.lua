require "scripts.card.action.Action"

-- Attack class
class.Attack(Action)

-- This function creates a new instance of Attack
--
function Attack:__init(params)
   self.Action:__init(params)    -- the new instance

   --Properties
   params = params or {}
end

-- Here are some functions (methods) for Attack:

function Attack:playAction()
   self.Action.playAction(self)
   local player = game:getCurrentPlayerForTurn()
   player.stats.attacksPlayed = player.stats.attacksPlayed + 1
   game:setupAttackAction(self)
end

function Attack:performAttack()
end