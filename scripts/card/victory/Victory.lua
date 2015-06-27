require "scripts.card.Card"

-- Victory class
class.Victory(shared(Card))
--
function Victory:__init(params)
   self.Card:__init(params)    -- the new instance

   --Properties
   params = params or {}
   self.points = params.points or 0
end

-- Here are some functions (methods) for Victory:

function Victory:getPoints(player)
   return self.points
end
