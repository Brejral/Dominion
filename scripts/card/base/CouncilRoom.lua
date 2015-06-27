-- CouncilRoom class
require "scripts.card.action.Action"

local params = {
   image = "images/Base/CouncilRoom.png",
   cost = 5,
   cards = 4,
   buys = 1
}

class.CouncilRoom(Action)

function CouncilRoom:__init()
   self.Action:__init(params)    -- the new instance
end

function CouncilRoom:playAction()
   self.Action.playAction(self)
   for k,player in pairs(game.players) do
      if not player.isTurn then
         player:drawCard()
      end
   end
   self:endAction()
end