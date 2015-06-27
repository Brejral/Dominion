-- Upgrade class
require "scripts.card.action.Action"

local params = {
   image = "images/Intrigue/Upgrade.png",
   cost = 5,
   cards = 1,
   actions = 1
}

class.Upgrade(Action)

function Upgrade:__init()
   self.Action:__init(params)    -- the new instance
end

function Upgrade:playAction()
   self.Action.playAction(self)
   local selectionParams = {card = self, min = 1, max = 1}
   gameScreen:setupForHandSelection(selectionParams)
end

function Upgrade:handleHandSelection(cards)
   local player = game:getCurrentPlayerForTurn()
   player:trashCard(cards[1])
   local cost = cards[1]:getCost() + 1
   local potion = cards[1]:costsPotion()
   local selectionParams = {card = self, min = 1, max = 1, minCost = cost, minPotion = potion, maxCost = cost, maxPotion = potion}
   gameScreen:setupForSupplySelection(selectionParams)
end

function Upgrade:handleSupplySelection(cards)
   if #cards > 0 then
      local player = game:getCurrentPlayerForTurn()
      player:gainCardFromSupply(cards[1])
   end
   self:endAction()
end
