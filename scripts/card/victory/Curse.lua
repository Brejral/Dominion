require "scripts.card.Card"

-- Curse class
class.Curse(Card)

local params = {
  image = "images/Victory/Curse.png",
  points = -1,
  cost = 0
}
-- This function creates a new instance of Curse
--
function Curse:__init()
   self.Card:__init(params)    -- the new instance
   --Properties
   params = params or {}
   self.points = params.points or 0
end

-- Here are some functions (methods) for Curse:

function Curse:getPoints(player)
   return self.points
end
   