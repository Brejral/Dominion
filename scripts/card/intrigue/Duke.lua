-- Duke class
require "scripts.card.victory.Victory"

local params = {
   image = "images/Intrigue/Duke.png",
   cost = 5
}

class.Duke(Victory)

function Duke:__init()
   self.Victory:__init(params)    -- the new instance
end

function Duke:getPoints(player)
   local duchies = 0
   for k,card in pairs(player:getAllCards()) do
      if card:is_a(Duchy) then duchies = duchies + 1 end
   end
   return duchies
end
