-- Estate class
require "scripts.card.victory.Victory"

local params = {
  image = "images/Victory/Estate.png",
  points = 1,
  cost = 2
}

class.Estate(Victory)

function Estate:__init()
   self.Victory:__init(params)    -- the new instance
end