-- Laboratory class
require "scripts.card.action.Action"

local params = {
   image = "images/Base/Laboratory.png",
   cost = 5,
   actions = 1,
   cards = 2
}

class.Laboratory(Action)

function Laboratory:__init()
   self.Action:__init(params)    -- the new instance
end

function Laboratory:playAction()
   self.Action.playAction(self)
   self:endAction()
end