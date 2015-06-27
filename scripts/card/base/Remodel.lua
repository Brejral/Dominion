-- Remodel class
require "scripts.card.action.Action"

local params = {
   image = "images/Base/Remodel.png",
   cost = 4
}

class.Remodel(Action)

function Remodel:__init()
   self.Action:__init(params)    -- the new instance
end

function Remodel:playAction()
   self.Action.playAction(self)
   local selectionParams = {card = self, max = 1, min = 1}
   gameScreen:setupForHandSelection(selectionParams)
end

function Remodel:handleHandSelection(cards)
   local player = game:getCurrentPlayerForTurn()
   player:trashCard(cards[1])
   local selectionParams = {card = self, maxCost = cards[1]:getCost() + 2, maxPotion = cards[1]:costsPotion()}
   gameScreen:setupForSupplySelection(selectionParams)
end

function Remodel:handleSupplySelection(cards)
   local player = game:getCurrentPlayerForTurn()
   player:gainCardFromSupply(cards[1])
   self:endAction()
end