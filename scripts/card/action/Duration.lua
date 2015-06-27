require "scripts.card.action.Action"

-- Duration class
class.Duration(Action)

-- This function creates a new instance of Duration
--
function Duration:__init(params)
   self.Action:__init(params)    -- the new instance

   --Properties
   params = params or {}
   self.durationCards = params.durationCards or 0
   self.durationActions = params.durationActions or 0
   self.durationBuys = params.durationBuys or 0
   self.durationCoins = params.durationCoins or 0
end

-- Here are some functions (methods) for Duration:

function Duration:performDuration()
   local player = game:getCurrentPlayerForTurn()
   player:drawCards(self:getDurationCards())
   player:addActions(self:getDurationActions())
   player:addBuys(self:getDurationBuys())
   player:addCoins(self:getDurationCoins())
end

function Duration:getDurationCards()
   return self.durationCards
end

function Duration:getDurationActions()
   return self.durationActions
end

function Duration:getDurationBuys()
   return self.durationBuys
end

function Duration:getDurationCoins()
   return self.durationCoins
end