-- ShantyTown class
require "scripts.card.action.Action"

local params = {
   image = "images/Intrigue/ShantyTown.png",
   cost = 3,
   actions = 2
}

class.ShantyTown(Action)

function ShantyTown:__init()
   self.Action:__init(params)    -- the new instance
end

function ShantyTown:playAction()
   self.Action.playAction(self)
   local player = game:getCurrentPlayerForTurn()
   if not player:hasTypeInHand(Action) then
      player:drawCards(2)
   end
   self:endAction()
end