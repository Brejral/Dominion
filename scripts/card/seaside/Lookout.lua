-- Lookout class
require "scripts.card.action.Action"

local params = {
   image = "images/Seaside/Lookout.png",
   cost = 3,
   actions = 1
}

class.Lookout(Action)

function Lookout:__init()
   self.Action:__init(params)    -- the new instance
end

function Lookout:playAction()
   self.Action.playAction(self)
   local player = game:getCurrentPlayerForTurn()
   self.revealedCards = {}
   for i=1,3 do
      player:checkForDeckResupply()
      table.insert(self.revealedCards, table.remove(player.deck))
   end
   local modalParams = {
      title = player.name,
      msg = "Trash a card.",
      min = 1,
      max = 1,
      cards = self.revealedCards,
      afterSelection = self.handleCardSelectionModalForTrash,
      target = self
   }
   gameScreen:showCardSelectionModal(modalParams)
end

function Lookout.handleCardSelectionModalForTrash(params)
   local player = game:getCurrentPlayerForTurn()
   local card = params.selectedCards[1]
   player:trashCard(removeFromTable(params.target.revealedCards, card))
   local modalParams = {
      title = player.name,
      msg = "Discard a card. (The unselected card will be put on top of your deck)",
      min = 1,
      max = 1,
      cards = params.target.revealedCards,
      afterSelection = params.target.handleCardSelectionModalForDiscard,
      target = params.target
   }
   gameScreen:showCardSelectionModal(modalParams)
end

function Lookout.handleCardSelectionModalForDiscard(params)
   local card = params.selectedCards[1]
   local player = game:getCurrentPlayerForTurn()
   player:discardCard(removeFromTable(params.target.revealedCards, card))
   player:addToDeck(table.remove(params.target.revealedCards))
   params.target:endAction()
end
