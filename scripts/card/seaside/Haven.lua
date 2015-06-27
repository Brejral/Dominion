-- Haven class
require "scripts.card.action.Duration"

local params = {
   image = "images/Seaside/Haven.png",
   cost = 2,
   cards = 1,
   actions = 1
}

class.Haven(Duration)

function Haven:__init()
   self.Duration:__init(params)    -- the new instance
end

function Haven:playAction()
   self.Duration.playAction(self)
   local player = game:getCurrentPlayerForTurn()
   local selectionParams = {card = self, min = 1, max = 1}
   gameScreen:setupForHandSelection(selectionParams)
end

function Haven:handleHandSelection(cards)
   local player = game:getCurrentPlayerForTurn()
   self.setAsideCard = table.remove(player.hand, indexOf(player.hand, cards[1]))
   self:endAction()
end

function Haven:performDuration()
   self.Duration.performDuration(self)
   local player = game:getCurrentPlayerForTurn()
   player:addCardToHand(self.setAsideCard)
   self.setAsideCard = nil
end
