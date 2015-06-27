-- Copper class
require "scripts.card.treasure.Treasure"

local params = {
  image = "images/Treasure/Copper.png",
  coins = 1,
  cost = 0
}

class.Copper(Treasure)

function Copper:__init()
   self.Treasure:__init(params)    -- the new instance
end
