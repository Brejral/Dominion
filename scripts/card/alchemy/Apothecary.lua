-- Apothecary class
require "scripts.card.action.Action"

local params = {
   image = "images/Alchemy/Apothecary.png",
   cost = 2,
   actions = 1,
   cards = 1,
   costsPotion = true
}

class.Apothecary(Action)

function Apothecary:__init()
   self.Action:__init(params)    -- the new instance
end

function Apothecary:playAction()
   self.Action.playAction(self)
   self:endAction()
end