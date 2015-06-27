-- Coppersmith class
require "scripts.card.action.Action"

local params = {
   image = "images/Intrigue/Coppersmith.png",
   cost = 4
}

class.Coppersmith(Action)

function Coppersmith:__init()
   self.Action:__init(params)    -- the new instance
end

function Coppersmith:playAction()
   self.Action.playAction(self)
   game.copperBonus = game.copperBonus + 1
   self:endAction()
end