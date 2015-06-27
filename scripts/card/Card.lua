-- Card class
class.Card()

-- This function creates a new instance of Card
--
function Card:__init(params)
   --Properties
   params = params or {}
   self.image = params.image or ""
   self.cost = params.cost or 0
   self.costsPotion = params.costsPotion or false
end

function Card:getImage()
   return self.image
end

function Card:getCost()
   local cost = self.cost - game.costDiscount
   return cost < 0 and 0 or cost
end

function Card:costsPotion()
   return self.costsPotion
end

function Card:costGreaterThan(value, potion)
   return self:getCost() >= value and (not potion or (potion and self.costsPotion))
end

function Card:costLessThan(value, potion)
   return self:getCost() <= value and ((not potion and not self.costsPotion) or potion)
end
