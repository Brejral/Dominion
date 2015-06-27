-- Chapel class
require "scripts.card.action.Action"

local params = {
   image = "images/Base/Chapel.png",
   cost = 2
}

class.Chapel(Action)

function Chapel:__init()
   self.Action:__init(params)    -- the new instance
end

function Chapel:playAction()
   self.Action.playAction(self)
   local selectionParams = {card = self, max = 4}
   gameScreen:setupForHandSelection(selectionParams)
end

function Chapel:handleHandSelection(cards)
   local player = game:getCurrentPlayerForTurn()
   player:trashCards(cards)
   self:endAction()
end