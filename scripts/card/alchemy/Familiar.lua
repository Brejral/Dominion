-- Familiar class
require "scripts.card.action.Attack"

local params = {
   image = "images/Alchemy/Familiar.png",
   cost = 3,
   actions = 1,
   cards = 1,
   costsPotion = true
}

class.Familiar(Attack)

function Familiar:__init()
   self.Attack:__init(params)    -- the new instance
end

function Familiar:playAction()
   self.Attack.playAction(self)
end

function Familiar:performAttack(player)
   player:gainCardFromSupply("Curse")
   game:nextAttackTurn()
end