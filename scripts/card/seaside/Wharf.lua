-- Wharf class
require "scripts.card.action.Duration"

local params = {
   image = "images/Seaside/Wharf.png",
   cost = 5,
   cards = 2,
   buys = 1,
   durationCards = 2,
   durationBuys = 1
}

class.Wharf(Duration)

function Wharf:__init()
   self.Duration:__init(params)    -- the new instance
end

function Wharf:playAction()
   self.Duration.playAction(self)
   self:endAction()
end