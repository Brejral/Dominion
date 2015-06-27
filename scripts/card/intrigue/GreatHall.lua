-- GreatHall class
require "scripts.card.action.Action"
require "scripts.card.victory.Victory"

local params = {
   image = "images/Intrigue/GreatHall.png",
   cost = 3,
   cards = 1,
   actions = 1,
   points = 1
}

class.GreatHall(Action, Victory)

function GreatHall:__init()
   self.Action:__init(params)
   self.Victory:__init(params)
end

function GreatHall:playAction()
   self.Action.playAction(self)
   self:endAction()
end
