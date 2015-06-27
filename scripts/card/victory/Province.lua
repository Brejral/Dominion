-- Province class
require "scripts.card.victory.Victory"

local params = {
  image = "images/Victory/Province.png",
  points = 6,
  cost = 8
}

class.Province(Victory)

function Province:__init()
   self.Victory:__init(params)    -- the new instance
end
