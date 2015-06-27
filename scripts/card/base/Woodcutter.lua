-- Woodcutter class
require "scripts.card.action.Action"

local params = {
   image = "images/Base/Woodcutter.png",
   cost = 3,
   coins = 2,
   buys = 1
}

class.Woodcutter(Action)

function Woodcutter:__init()
   self.Action:__init(params)    -- the new instance
end

function Woodcutter:playAction()
   self.Action.playAction(self)
   self:endAction()
end