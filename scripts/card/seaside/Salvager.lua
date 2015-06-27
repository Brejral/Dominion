-- Salvager class
require "scripts.card.action.Action"

local params = {
   image = "images/Seaside/Salvager.png",
   cost = 4,
   buys = 1
}

class.Salvager(Action)

function Salvager:__init()
   self.Action:__init(params)    -- the new instance
end

function Salvager:playAction()
   self.Action.playAction(self)
   local player = game:getCurrentPlayerForTurn()
   if #player.hand > 0 then
      local selectionParams = {card = self, min = 1, max = 1}
      gameScreen:setupForHandSelection(selectionParams)
   else
      self:endAction()
   end   
end

function Salvager:handleHandSelection(cards)
   local card = cards[1]
   local player = game:getCurrentPlayerForTurn()
   player:trashCard(card)
   player:addCoins(card:getCost())
   self:endAction()
end