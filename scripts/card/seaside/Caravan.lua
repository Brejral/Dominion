-- Caravan class
require "scripts.card.action.Duration"

local params = {
   image = "images/Seaside/Caravan.png",
   cost = 4,
   actions = 1,
   cards = 1,
   durationCards = 1
}

class.Caravan(Duration)

function Caravan:__init()
   self.Duration:__init(params)    -- the new instance
end

function Caravan:playAction()
   self.Duration.playAction(self)
   self:endAction()
end