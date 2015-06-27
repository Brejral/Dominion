-- Duchy class
require "scripts.card.victory.Victory"

local params = {
  image = "images/Victory/Duchy.png",
  points = 3,
  cost = 5
}

class.Duchy(Victory)

function Duchy:__init()
   self.Victory:__init(params)    -- the new instance
end