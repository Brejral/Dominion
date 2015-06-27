-- Conspirator class
require "scripts.card.action.Action"

local params = {
   image = "images/Intrigue/Conspirator.png",
   cost = 4,
   coins = 2
}

class.Conspirator(Action)

function Conspirator:__init()
   self.Action:__init(params)    -- the new instance
end

function Conspirator:playAction()
   self.Action.playAction(self)
   local player = game:getCurrentPlayerForTurn()
   if player:getNumOfTypePlayed(Action) >= 3 then
      player:addActions(1)
      player:drawCard()
   end
   self:endAction()
end