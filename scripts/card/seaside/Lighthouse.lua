-- Lighthouse class
require "scripts.card.action.Duration"

local params = {
   image = "images/Seaside/Lighthouse.png",
   cost = 2,
   actions = 1,
   coins = 1,
   durationCoins = 1
}

class.Lighthouse(Duration)

function Lighthouse:__init()
   self.Duration:__init(params)    -- the new instance
end

function Lighthouse:playAction()
   self.Duration.playAction(self)
   self:endAction()
end