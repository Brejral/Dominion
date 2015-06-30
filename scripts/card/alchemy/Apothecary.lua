-- Apothecary class
require "scripts.card.action.Action"

local params = {
   image = "images/Alchemy/Apothecary.png",
   cost = 2,
   actions = 1,
   cards = 1,
   costsPotion = true
}

class.Apothecary(Action)

function Apothecary:__init()
   self.Action:__init(params)    -- the new instance
end

function Apothecary:playAction()
   self.Action.playAction(self)
   local player = game:getCurrentPlayerForTurn()
   local revealedCards = {}
   for i = 1,4 do
      player:checkForDeckResupply()
      if #player.deck == 0 then break end
      local card = table.remove(player.deck)
      if card:is_a(Copper) or card:is_a(Potion) then
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

function Apothecary.handleCardSelectionModal(params)
   local player = game:getCurrentPlayerForTurn()
   for k,card in pairs(params.orderedCards) do
      player:addToDeck(card)
   end
   params.target:endAction()
end