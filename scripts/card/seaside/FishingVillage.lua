-- FishingVillage class
require "scripts.card.action.Duration"

local params = {
   image = "images/Seaside/FishingVillage.png",
   cost = 3,
   actions = 2,
   coins = 1,
   durationActions = 1,
   durationCoins = 1
}

class.FishingVillage(Duration)

function FishingVillage:__init()
   self.Duration:__init(params)    -- the new instance
end

function FishingVillage:playAction()
   self.Duration.playAction(self)
   self:endAction()
end