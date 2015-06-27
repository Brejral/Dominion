-- Moneylender class
require "scripts.card.action.Action"

local params = {
   image = "images/Base/Moneylender.png",
   cost = 4
}

class.Moneylender(Action)

function Moneylender:__init()
   self.Action:__init(params)    -- the new instance
end

function Moneylender:playAction()
   self.Action.playAction(self)
   local selectionParams = {card = self, types = Copper, max = 1}
   gameScreen:setupForHandSelection(selectionParams)
end

function Moneylender:handleHandSelection(cards)
   if #cards > 0 then
      local player = game:getCurrentPlayerForTurn()
      player:trashCards(cards)
      player:addCoins(3)
   end
   self:endAction()
end