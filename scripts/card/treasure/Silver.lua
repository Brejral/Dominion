-- Silver class
require "scripts.card.treasure.Treasure"

local params = {
  image = "images/Treasure/Silver.png",
  coins = 2,
  cost = 3
}

class.Silver(Treasure)

function Silver:__init()
   self.Treasure:__init(params)    -- the new instance
end