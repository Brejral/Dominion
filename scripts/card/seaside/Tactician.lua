-- Tactician class
require "scripts.card.action.Duration"

local params = {
   image = "images/Seaside/Tactician.png",
   cost = 5
}

class.Tactician(Duration)

function Tactician:__init()
   self.Duration:__init(params)    -- the new instance
end

function Tactician:playAction()
   self.Duration.playAction(self)
   local player = game:getCurrentPlayerForTurn()
   self.cardDiscarded = #player.hand > 0
   player:discardHand()
   self:endAction()
end

function Tactician:performDuration()
   if self.cardDiscarded then
      local player = game:getCurrentPlayerForTurn()
      player:drawCards(5)
      player:addActions(1)
      player:addBuys(1)
   end
end
