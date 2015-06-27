require "scripts.card.Card"

-- Action class
class.Action(shared(Card))

-- This function creates a new instance of Action
--
function Action:__init(params)
   self.Card:__init(params)    -- the new instance

   --Properties
   params = params or {}
   self.coins = params.coins or 0
   self.cards = params.cards or 0
   self.actions = params.actions or 0
   self.buys = params.buys or 0
   self.pointTokens = params.pointTokens or 0
end

-- Here are some functions (methods) for Action:

function Action:playAction()
   local player = game:getCurrentPlayerForTurn()
   player:drawCards(self:getCards())
   player:addActions(self:getActions() - 1)
   player:addBuys(self:getBuys())
   player:addCoins(self:getCoins())
   player:addPoints(self:getPointTokens())
end

function Action:endAction()
   local event = {name = "actionEnd"}
   Runtime:dispatchEvent(event)
end

function Action:getCoins()
   return self.coins
end

function Action:getCards()
   return self.cards
end

function Action:getBuys()
   return self.buys
end

function Action:getActions()
   return self.actions
end

function Action:getPointTokens(player)
   return self.pointTokens
end