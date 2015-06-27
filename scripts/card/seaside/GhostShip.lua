-- GhostShip class
require "scripts.card.action.Attack"

local params = {
   image = "images/Seaside/GhostShip.png",
   cost = 5,
   cards = 2
}

class.GhostShip(Attack)

function GhostShip:__init()
   self.Attack:__init(params)    -- the new instance
end

function GhostShip:playAction()
   self.Attack.playAction(self)
end

function GhostShip:performAttack(player)
   local selectionParams = {
      player = player,
      msg = "Put cards from your hand on top of your deck until you have 3 cards in hand. (First selected will be last drawn)",
      min = #player.hand - 3,
      max = #player.hand - 3,
      afterSelection = self.handleHandSelectionModal,
      isNegative = true,
      target = self,
      isOrdering = true
   }
   gameScreen:showHandSelectionModal(selectionParams)
end

function GhostShip.handleHandSelectionModal(params)
   local player = params.player
   for k,card in pairs(params.orderedCards) do
      player:addToDeck(card)
   end
   params.target:endAction()
end