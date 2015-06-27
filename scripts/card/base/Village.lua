-- Village class
require "scripts.card.action.Action"

local params = {
   image = "images/Base/Village.png",
   cost = 3,
   actions = 2,
   cards = 1
}

class.Village(Action)

function Village:__init()
   self.Action:__init(params)    -- the new instance
end

function Village:playAction()
   self.Action.playAction(self)
   self:endAction()
end