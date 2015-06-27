-- Witch class
require "scripts.card.action.Attack"

local params = {
   image = "images/Base/Witch.png",
   cost = 5,
   cards = 2
}

class.Witch(Attack)

function Witch:__init()
   self.Attack:__init(params)    -- the new instance
end

function Witch:playAction()
   self.Attack.playAction(self)
end

function Witch:performAttack(player)
   player:gainCardFromSupply("Curse")
   game:nextAttackTurn()
end