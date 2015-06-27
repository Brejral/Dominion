-- Cutpurse class
require "scripts.card.action.Attack"

local params = {
   image = "images/Seaside/Cutpurse.png",
   cost = 4,
   coins = 2
}

class.Cutpurse(Attack)

function Cutpurse:__init()
   self.Attack:__init(params)    -- the new instance
end

function Cutpurse:playAction()
   self.Attack.playAction(self)
end

function Cutpurse:performAttack(player)
   for k,card in pairs(player.hand) do
      if card:is_a(Copper) then
         player:discardCard(card)
         break
      end
   end
   game:nextAttackTurn()
end
