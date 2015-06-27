-- Gold class
require "scripts.card.treasure.Treasure"

local params = {
  image = "images/Treasure/Gold.png",
  coins = 3,
  cost = 6
}

class.Gold(Treasure)

function Gold:__init()
   self.Treasure:__init(params)    -- the new instance
end