-- Potion class
require "scripts.card.treasure.Treasure"

local params = {
  image = "images/Alchemy/Potion.png",
  cost = 4
}

class.Potion(Treasure)

function Potion:__init()
   self.Treasure:__init(params)    -- the new instance
end