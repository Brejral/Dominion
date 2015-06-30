require "scripts.card.Card"

-- Treasure class
class.Treasure(shared(Card))

-- This function creates a new instance of Treasure
--
function Treasure:__init(params)
   self.Card:__init(params)    -- the new instance

   --Properties
   params = params or {}
   self.coins = params.coins or 0
end

function Treasure:getCoins(player)
   return self.coins
end

-- Here are some functions (methods) for Treasure:
