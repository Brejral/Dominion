-- Possession class
require "scripts.card.action.Action"

local params = {
   image = "images/Alchemy/Possession.png",
   cost = 6,
   costsPotion = true
}

class.Possession(Action)

function Possession:__init()
   self.Action:__init(params)    -- the new instance
end

function Possession:playAction()
   self.Action.playAction(self)
   self:endAction()
end