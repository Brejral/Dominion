-- Vineyard class
require "scripts.card.action.Action"

local params = {
   image = "images/Alchemy/Vineyard.png",
   cost = 3,
   actions = 2,
   cards = 1
}

class.Vineyard(Action)

function Vineyard:__init()
   self.Action:__init(params)    -- the new instance
end

function Vineyard:playAction()
   self.Action.playAction(self)
   self:endAction()
end