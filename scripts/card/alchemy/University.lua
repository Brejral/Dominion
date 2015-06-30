-- University class
require "scripts.card.action.Action"

local params = {
   image = "images/Alchemy/University.png",
   cost = 2,
   actions = 2,
   costsPotion = true
}

class.University(Action)

function University:__init()
   self.Action:__init(params)    -- the new instance
end

function University:playAction()
   self.Action.playAction(self)
   local selectionParams = {card = self, maxCost = 5, types = Action}
   gameScreen:setupForSupplySelection(selectionParams)
end

function University:handleSupplySelection(cards)
   local card = cards[1]
   local player = game:getCurrentPlayerForTurn()
   player:gainCardFromSupply(card)
   self:endAction()
end