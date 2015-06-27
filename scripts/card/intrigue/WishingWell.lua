-- WishingWell class
require "scripts.card.action.Action"

local params = {
   image = "images/Intrigue/WishingWell.png",
   cost = 3,
   cards = 1,
   actions = 1
}

class.WishingWell(Action)

function WishingWell:__init()
   self.Action:__init(params)    -- the new instance
end

function WishingWell:playAction()
   self.Action.playAction(self)
   local selectionParams = {card = self, min = 1, max = 1}
   gameScreen:setupForSupplySelection(selectionParams)
end

function WishingWell:handleSupplySelection(cards)
   local player = game:getCurrentPlayerForTurn()
   local cardName = classname(cards[1])
   local revealedCard = player.deck[#player.deck]
   if classname(revealedCard) == cardName then
      player:drawCard()
   end
   local modalParams = {
      title = player.name,
      target = self,
      afterSelection = self.handleCardSelectionModal,
      cards = {revealedCard},
      msg = "Revealed card:",
      isSelection = false
   }
   gameScreen:showCardSelectionModal(modalParams)
end

function WishingWell.handleCardSelectionModal(params)
   params.target:endAction()
end
