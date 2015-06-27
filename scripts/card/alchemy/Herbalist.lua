-- Herbalist class
require "scripts.card.action.Action"

local params = {
   image = "images/Alchemy/Herbalist.png",
   cost = 2,
   buys = 1,
   coins = 1
}

class.Herbalist(Action)

function Herbalist:__init()
   self.Action:__init(params)    -- the new instance
end

function Herbalist:playAction()
   self.Action.playAction(self)
   self:endAction()
end