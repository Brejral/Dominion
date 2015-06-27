-- TradingPost class
require "scripts.card.action.Action"

local params = {
   image = "images/Intrigue/TradingPost.png",
   cost = 5
}

class.TradingPost(Action)

function TradingPost:__init()
   self.Action:__init(params)    -- the new instance
end

function TradingPost:playAction()
   self.Action.playAction(self)
   local player = game:getCurrentPlayerForTurn()
   local num = math.min(2, #player.hand)
   local selectionParams = {card = self, min = num, max = num}
   gameScreen:setupForHandSelection(selectionParams)
end

function TradingPost:handleHandSelection(cards)
   local player = game:getCurrentPlayerForTurn()
   player:trashCards(cards)
   if #cards == 2 then
      player:addCardToHandFromSupply("Silver")
   end
   self:endAction()
end
