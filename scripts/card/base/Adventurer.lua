-- Adventurer class
require "scripts.card.action.Action"

local params = {
   image = "images/Base/Adventurer.png",
   cost = 6
}

class.Adventurer(Action)

function Adventurer:__init()
   self.Action:__init(params)    -- the new instance
end

function Adventurer:playAction()
   --TODO: Reveal cards
   self.Action.playAction(self)
   local count = 0
   local player = game:getCurrentPlayerForTurn()
   local revealedCards = {}
   while count < 2 do
      player:checkForDeckResupply()
      if #player.deck == 0 then break end
      local card = table.remove(player.deck)
      if card:is_a(Treasure) then
         table.insert(player.hand, card)
         player.stats.totalCards = player.stats.totalCards + 1
         count = count + 1
      else
         table.insert(revealedCards, card)
      end
   end
   for k,card in pairs(revealedCards) do
      player:discardCard(card)
   end
   local modalParams = {
      title = player.name,
      msg = "Revealed cards that were discarded.",
      cards = revealedCards,
      afterSelection = self.handleCardSelectionModal,
      isSelection = false
   }
   gameScreen:showCardSelectionModal(modalParams)
end

function Adventurer:handleCardSelectionModal(params)
   self:endAction()
end
