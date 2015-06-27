-- Bridge class
require "scripts.card.action.Action"

local params = {
   image = "images/Intrigue/Bridge.png",
   cost = 4,
   buys = 1,
   coins = 1
}

class.Bridge(Action)

function Bridge:__init()
   self.Action:__init(params)    -- the new instance
end

function Bridge:playAction()
   self.Action.playAction(self)
   game.costDiscount = game.costDiscount + 1
   self:endAction()
end
