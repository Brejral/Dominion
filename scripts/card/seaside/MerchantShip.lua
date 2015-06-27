-- MerchantShip class
require "scripts.card.action.Duration"

local params = {
   image = "images/Seaside/MerchantShip.png",
   cost = 5,
   coins = 2,
   durationCoins = 2
}

class.MerchantShip(Duration)

function MerchantShip:__init()
   self.Duration:__init(params)    -- the new instance
end

function MerchantShip:playAction()
   self.Duration.playAction(self)
   self:endAction()
end