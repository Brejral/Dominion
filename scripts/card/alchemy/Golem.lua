-- Golem class
require "scripts.card.action.Action"

local params = {
   image = "images/Alchemy/Golem.png",
   cost = 4,
   costsPotion = true
}

class.Golem(Action)

function Golem:__init()
   self.Action:__init(params)    -- the new instance
end

function Golem:playAction()
   self.Action.playAction(self)
   self:endAction()
end