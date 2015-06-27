-- Courtyard class
require "scripts.card.action.Action"

local params = {
   image = "images/Intrigue/Courtyard.png",
   cost = 2,
   cards = 3
}

class.Courtyard(Action)

function Courtyard:__init()
   self.Action:__init(params)    -- the new instance
end

function Courtyard:playAction()
   self.Action.playAction(self)
   local selectionParams = {card = self, min = 1, max = 1}
   gameScreen:setupForHandSelection(selectionParams)
end

function Courtyard:handleHandSelection(cards)
   local card = cards[1]
   local player = game:getCurrentPlayerForTurn()
   player:addToDeck(table.remove(player.hand, indexOf(player.hand, card)))
   self:endAction()
end