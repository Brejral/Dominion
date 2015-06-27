-- Transmute class
require "scripts.card.action.Action"

local params = {
   image = "images/Alchemy/Transmute.png",
   cost = 0,
   costsPotion = true
}

class.Transmute(Action)

function Transmute:__init()
   self.Action:__init(params)    -- the new instance
end

function Transmute:playAction()
   self.Action.playAction(self)
   self:endAction()
end