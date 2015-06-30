-- Herbalist class
require "scripts.card.action.Action"

local params = {
   image = "images/Alchemy/Herbalist.png",
   cost = 2,
   buys = 1,
   coins = 1
}

class.Herbalist(Action)

function Herbalist:__init()
   self.Action:__init(params)    -- the new instance
end

function Herbalist:playAction()
   self.Action.playAction(self)
   self:endAction()
end

function Herbalist:onDiscardFromPlay(player)
   local treasures = player:getCardsPlayedOfType(Treasure)
   local modalParams = {
      title = player.name,
      msg = "You may put a played Treasure back on top of your deck.",
      cards = treasures,
      afterSelection = self.handleCardSelectionModal,
      max = 1,
      target = self,
      player = player
   }
   gameScreen:showCardSelectionModal(modalParams)
end

function Herbalist.handleCardSelectionModal(params)
   if params.selectedCards > 0 then
      local treasure = removeFromTable(params.player.playedCards, params.selectedCards[1])
      params.player:addToDeck(treasure)
   end
   params.target:endAction()
end
