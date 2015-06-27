-- Feast class
require "scripts.card.action.Action"

local params = {
   image = "images/Base/Feast.png",
   cost = 4
}

class.Feast(Action)

function Feast:__init()
   self.Action:__init(params)    -- the new instance
end

function Feast:playAction()
   self.Action.playAction(self)
   local player = game:getCurrentPlayerForTurn()
   player:trashCard(self)
   local selectionParams = {card = self, maxCost = 5}
   gameScreen:setupForSupplySelection(selectionParams)
end

function Feast:handleSupplySelection(cards)
   local card = cards[1]
   local player = game:getCurrentPlayerForTurn()
   player:gainCardFromSupply(card)
   self:endAction()
end