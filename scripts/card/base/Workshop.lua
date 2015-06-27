-- Workshop class
require "scripts.card.action.Action"

local params = {
   image = "images/Base/Workshop.png",
   cost = 3
}

class.Workshop(Action)

function Workshop:__init()
   self.Action:__init(params)    -- the new instance
end

function Workshop:playAction()
   self.Action.playAction(self)
   local selectionParams = {card = self, maxCost = 4}
   gameScreen:setupForSupplySelection(selectionParams)
end

function Workshop:handleSupplySelection(cards)
   local player = game:getCurrentPlayerForTurn()
   player:gainCardFromSupply(cards[1])
   self:endAction()
end
