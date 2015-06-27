-- Island class
require "scripts.card.action.Action"
require "scripts.card.victory.Victory"

local params = {
   image = "images/Seaside/Island.png",
   cost = 4,
   points = 2
}

class.Island(Action, Victory)

function Island:__init()
   self.Action:__init(params)    -- the new instance
   self.Victory:__init(params)
end

function Island:playAction()
   self.Action.playAction(self)
   local selectionParams = {card = self, min = 1, max = 1}
   gameScreen:setupForHandSelection(selectionParams)
end

function Island:handleHandSelection(cards)
   local player = game:getCurrentPlayerForTurn()
   table.insert(player.setAsideCards, table.remove(player.playedCards, indexOf(player.playedCards, self)))
   if #cards > 0 then
      table.insert(player.setAsideCards, table.remove(player.hand, indexOf(player.hand, cards[1])))
   end
   self:endAction()
end
