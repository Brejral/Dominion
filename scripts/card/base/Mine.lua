-- Mine class
require "scripts.card.action.Action"

local params = {
   image = "images/Base/Mine.png",
   cost = 5
}

Mine = class.Mine(Action)

function Mine:__init()
   self.Action:__init(params)    -- the new instance
end

function Mine:playAction()
   self.Action.playAction(self)
   local selectionParams = {card = self, max = 1, min = 1, types = Treasure}
   gameScreen:setupForHandSelection(selectionParams)
end

function Mine:handleHandSelection(cards)
   local player = game:getCurrentPlayerForTurn()
   player:trashCard(cards[1])
   local selectionParams = {card = self, maxCost = cards[1]:getCost() + 3, maxPotion = cards[1]:costsPotion(), types = Treasure}
   gameScreen:setupForSupplySelection(selectionParams)
end

function Mine:handleSupplySelection(cards)
   local player = game:getCurrentPlayerForTurn()
   player:addCardToHandFromSupply(cards[1])
   self:endAction()
end