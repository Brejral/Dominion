-- University class
require "scripts.card.action.Action"

local params = {
   image = "images/Alchemy/University.png",
   cost = 2,
   actions = 2,
   costsPotion = true
}

class.University(Action)

function University:__init()
   self.Action:__init(params)    -- the new instance
end

function University:playAction()
   self.Action.playAction(self)
   self:endAction()
end