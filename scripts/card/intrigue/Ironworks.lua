-- Ironworks class
require "scripts.card.action.Action"

local params = {
   image = "images/Intrigue/Ironworks.png",
   cost = 4
}

class.Ironworks(Action)

function Ironworks:__init()
   self.Action:__init(params)    -- the new instance
end

function Ironworks:playAction()
   self.Action.playAction(self)
   local selectionParams = {card = self, maxCost = 4}
   gameScreen:setupForSupplySelection(selectionParams)
end

function Ironworks:handleSupplySelection(cards)
   local player = game:getCurrentPlayerForTurn()
   local card = cards[1]
   player:gainCardFromSupply(card)
   if card:is_a(Action) then
      player:addActions(1)
   end
   if card:is_a(Treasure) then
      player:addCoins(1)
   end
   if card:is_a(Victory) then
      player:drawCard()
   end
   self:endAction()
end
