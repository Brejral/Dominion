-- Market class
require "scripts.card.action.Action"

local params = {
   image = "images/Base/Market.png",
   cost = 5,
   actions = 1,
   cards = 1,
   coins = 1,
   buys = 1
}

class.Market(Action)

function Market:__init()
   self.Action:__init(params)    -- the new instance
end

function Market:playAction()
   self.Action.playAction(self)
   self:endAction()
end
