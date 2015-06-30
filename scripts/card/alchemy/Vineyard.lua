-- Vineyard class
require "scripts.card.victory.Victory"

local params = {
   image = "images/Alchemy/Vineyard.png",
   cost = 0,
   costsPotion = true
}

class.Vineyard(Victory)

function Vineyard:__init()
   self.Victory:__init(params)    -- the new instance
end

function Vineyard:getPoints(player)
   local actions = 0
   for k,card in pairs(player:getAllCards()) do
      if card:is_a(Action) then actions = actions + 1 end
   end
   return math.floor(actions / 3)
end