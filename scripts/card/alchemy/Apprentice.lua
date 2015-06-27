-- Apprentice class
require "scripts.card.action.Action"

local params = {
   image = "images/Alchemy/Apprentice.png",
   cost = 5,
   actions = 1
}

class.Apprentice(Action)

function Apprentice:__init()
   self.Action:__init(params)    -- the new instance
end

function Apprentice:playAction()
   self.Action.playAction(self)
   self:endAction()
end