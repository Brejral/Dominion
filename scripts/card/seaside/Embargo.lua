-- Embargo class
require "scripts.card.action.Action"

local params = {
   image = "images/Seaside/Embargo.png",
   cost = 2,
   coins = 2
}

class.Embargo(Action)

function Embargo:__init()
   self.Action:__init(params)    -- the new instance
end

function Embargo:playAction()
   self.Action.playAction(self)
   local player = game:getCurrentPlayerForTurn()
   player:trashCard(self)
   local selectionParams = {card = self, min = 1, max = 1}
   gameScreen:setupForSupplySelection(selectionParams)
end

function Embargo:handleSupplySelection(cards)
   game.cardSupply:addEmbargoToken(classname(cards[1]))
   self:endAction()
end
