-- ScryingPool class
require "scripts.card.action.Attack"

local params = {
   image = "images/Alchemy/ScryingPool.png",
   cost = 2,
   actions = 1,
   costsPotion = true
}

class.ScryingPool(Attack)

function ScryingPool:__init()
   self.Attack:__init(params)    -- the new instance
end

function ScryingPool:playAction()
   self.Attack.playAction(self)
   self:endAction()
end