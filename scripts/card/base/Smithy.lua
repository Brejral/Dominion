-- Smithy class
require "scripts.card.action.Action"

local params = {
   image = "images/Base/Smithy.png",
   cost = 4,
   cards = 3
}

class.Smithy(Action)

function Smithy:__init()
   self.Action:__init(params)    -- the new instance
end

function Smithy:playAction()
   self.Action.playAction(self)
   self:endAction()
end