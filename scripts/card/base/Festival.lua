-- Festival class
require "scripts.card.action.Action"

local params = {
   image = "images/Base/Festival.png",
   cost = 5,
   actions = 2,
   coins = 2,
   buys = 1
}

class.Festival(Action)

function Festival:__init()
   self.Action:__init(params)    -- the new instance
end

function Festival:playAction()
   self.Action.playAction(self)
   self:endAction()
end