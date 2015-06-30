-- Outpost class
require "scripts.card.action.Duration"

local params = {
   image = "images/Seaside/Outpost.png",
   cost = 5
}

class.Outpost(Duration)

function Outpost:__init()
   self.Duration:__init(params)    -- the new instance
end

function Outpost:playAction()
   self.Duration.playAction(self)
   local player = game:getCurrentPlayerForTurn()
   player.cardsDrawnDuringCleanup = 3
   self:endAction()
end

function Outpost:onEndOfTurn(player)
   if game:hasExtraPossessedTurnForPlayer(player) then
      local selectionParams = {
         title = player:getPossessor(),
         msg = "Play extra turn for Outpost after this turn or the next possessed turn?",
         cards = {self},
         choices = {"After This", "After Next"},
         afterSelection = self.handleChoiceModal,
         target = self
      }
   else
      game:addExtraTurn({player = player, isOutpost = true})
      game:checkForEndOfTurnCards()
   end
end
