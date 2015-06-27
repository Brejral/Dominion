-- PhilosophersStone class
require "scripts.card.treasure.Treasure"

local params = {
   image = "images/Alchemy/PhilosophersStone.png",
   cost = 3,
   costsPotion = true
}

class.PhilosophersStone(Treasure)

function PhilosophersStone:__init()
   self.Treasure:__init(params)    -- the new instance
end
