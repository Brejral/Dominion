-- Gardens class
require "scripts.card.victory.Victory"

local params = {
   image = "images/Base/Gardens.png",
   cost = 4
}

Gardens = class.Gardens(Victory)

function Gardens:__init()
   self.Victory:__init(params)    -- the new instance
end

function Gardens:getPoints(player)
   local numCards = #player:getAllCards()
   return math.floor(numCards / 10)
end