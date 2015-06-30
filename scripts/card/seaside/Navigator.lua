-- Navigator class
require "scripts.card.action.Action"

local params = {
   image = "images/Seaside/Navigator.png",
   cost = 4,
   coins = 2
}

class.Navigator(Action)

function Navigator:__init()
   self.Action:__init(params)    -- the new instance
end

function Navigator:playAction()
   self.Action.playAction(self)
   local player = game:getCurrentPlayerForTurn()
   local revealedCards = {}
   for i = 1,5 do
      player:checkForDeckResupply()
      if #player.deck > 0 then
         table.insert(revealedCards, table.remove(player.deck))
      end
   end
   local modalParams = {
      title = player.name,
      msg = "Discard these cards or place them back on deck in any order.",
      choices = {"On Deck", "Discard"},
      target = self,
      afterSelection = self.handleChoiceModal,
      cards = revealedCards
   }
   gameScreen:showChoiceModal(modalParams)
end

function Navigator.handleChoiceModal(params)
   local player = game:getCurrentPlayerForTurn()
   if params.selection == "Discard" then
      for k,card in pairs(params.cards) do
         player.discardCard(card)
      end
      params.target:endAction()
   else
      local modalParams = {
         title = player.name,
         msg = "Put these cards back on top of your deck in any order. (First selected will be last drawn)",
         target = params.target,
         cards = params.cards,
         afterSelection = params.target.handleCardSelectionModal,
         isOrdering = true
      }
      gameScreen:showCardSelectionModal(modalParams)
   end
end

function Navigator.handleCardSelectionModal(params)
   local orderedCards = params.orderedCards
   local player = game:getCurrentPlayerForTurn()
   for k,card in pairs(orderedCards) do
      player:addToDeck(card)
   end
   params.target:endAction()
end
