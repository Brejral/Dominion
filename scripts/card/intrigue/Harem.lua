-- Harem class
require "scripts.card.victory.Victory"
require "scripts.card.treasure.Treasure"

local params = {
   image = "images/Intrigue/Harem.png",
   cost = 6,
   coins = 2,
   points = 2
}

class.Harem(Victory, Treasure)

function Harem:__init()
   self.Victory:__init(params)
   self.Treasure:__init(params)
end
