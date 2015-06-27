-- SeaHag class
require "scripts.card.action.Attack"

local params = {
   image = "images/Seaside/SeaHag.png",
   cost = 4
}

class.SeaHag(Attack)

function SeaHag:__init()
   self.Attack:__init(params)    -- the new instance
end

function SeaHag:playAction()
   self.Attack.playAction(self)
end

function SeaHag:performAttack(player)
   player:discardCard(table.remove(player.deck))
   player:addToDeck(game.cardSupply:getCard("Curse"))
   game:nextAttackTurn()
end