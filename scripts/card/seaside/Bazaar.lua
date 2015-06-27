-- Bazaar class
require "scripts.card.action.Action"

local params = {
   image = "images/Seaside/Bazaar.png",
   cost = 5,
   actions = 2,
   cards = 1,
   coins = 1
}

class.Bazaar(Action)

function Bazaar:__init()
   self.Action:__init(params)    -- the new instance
end

function Bazaar:playAction()
   self.Action.playAction(self)
   self:endAction()
end