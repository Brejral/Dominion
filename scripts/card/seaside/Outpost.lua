-- Outpost class
require "scripts.card.action.Duration"

local params = {
   image = "images/Seaside/Outpost.png",
   cost = 5
}

class.Outpost(Duration)

function Outpost:__init()
   self.Duration:__init(params)    -- the new instance
end

function Outpost:playAction()
   self.Duration.playAction(self)
   game.outpostPlayed = true
   self:endAction()
end