-- Cellar class
require "scripts.card.action.Action"

class.Cellar(Action)

local params = {
   image = "images/Base/Cellar.png",
   cost = 2,
   actions = 1
}

function Cellar:__init()
   self.Action:__init(params)    -- the new instance
end

function Cellar:playAction()
   self.Action.playAction(self)
   local selectionParams = {card = self}
   gameScreen:setupForHandSelection(selectionParams)
end

function Cellar:handleHandSelection(cards)
   local player = game:getCurrentPlayerForTurn()
   player:discardCards(cards)
   player:drawCards(#cards)
   self:endAction()
end