-- Warehouse class
require "scripts.card.action.Action"

local params = {
   image = "images/Seaside/Warehouse.png",
   cost = 3,
   cards = 3,
   actions = 1
}

class.Warehouse(Action)

function Warehouse:__init()
   self.Action:__init(params)    -- the new instance
end

function Warehouse:playAction()
   self.Action.playAction(self)
   local selectionParams = {card = self, min = 3, max = 3}
   gameScreen:setupForHandSelection(selectionParams)
end

function Warehouse:handleHandSelection(cards)
   local player = game:getCurrentPlayerForTurn()
   for k,card in pairs(cards) do
      player:discardCard(card)
   end
   self:endAction()
end
