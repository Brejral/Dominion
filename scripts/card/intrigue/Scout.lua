-- Scout class
require "scripts.card.action.Action"

local params = {
   image = "images/Intrigue/Scout.png",
   cost = 4,
   actions = 1
}

class.Scout(Action)

function Scout:__init()
   self.Action:__init(params)    -- the new instance
end

function Scout:playAction()
   self.Action.playAction(self)
   local player = game:getCurrentPlayerForTurn()
   local revealedCards = {}
   for i = 1,4 do
      player:checkForDeckResupply()
      if #player.deck == 0 then break end
      local card = table.remove(player.deck)
      if card:is_a(Victory) then
         table.insert(player.hand, card)
      else
         table.insert(revealedCards, card)
      end
   end
   if #revealedCards > 0 then
      local modalParams = {
         title = player.name,
         target = self,
         player = player,
         afterSelection = self.handleCardSelectionModal,
         cards = revealedCards,
         msg = "Put cards on top of deck in any order (first selected will be last drawn).",
         isOrdering = true
      }
      gameScreen:showCardSelectionModal(modalParams)
   else
      self:endAction()
   end
end

function Scout.handleCardSelectionModal(params)
   local player = game:getCurrentPlayerForTurn()
   for k,card in pairs(params.orderedCards) do
      player:addToDeck(card)
   end
   params.target:endAction()
end
