-- PirateShip class
require "scripts.card.action.Attack"

local params = {
   image = "images/Seaside/PirateShip.png",
   cost = 4
}

class.PirateShip(Attack)

function PirateShip:__init()
   self.Attack:__init(params)    -- the new instance
end

function PirateShip:playAction()
   self.tokenGained = false
   local player = game:getCurrentPlayerForTurn()
   local modalParams = {
      title = player.name,
      msg = "Choose one:\n1. Each other player reveals top 2 cards of deck, trashes a revealed Treasure you choose, discards the rest, you get coin token if anyone trashed a card.\n2. +1 Coin per coin token ("..player:getCoinTokens().." Tokens)",
      target = self,
      choices = {"Coins","Attack"},
      afterSelection = self.handleChoiceModal,
      cards = {self}
   }
   gameScreen:showChoiceModal(modalParams)
end

function PirateShip.handleChoiceModal(params)
   if params.selection == "Coins" then
      local player = game:getCurrentPlayerForTurn()
      params.target.Action.playAction(params.target)
      player:addCoins(player:getCoinTokens())
      params.target:endAction()
   else
      params.target.Attack.playAction(params.target)
   end
end

function PirateShip:performAttack(player)
   local currentPlayer = game:getCurrentPlayerForTurn()
   local revealedCards = {}
   local hasTreasure = false
   for i=1,2 do
      player:checkForDeckResupply()
      local card = table.remove(player.deck)
      if card then
         if card:is_a(Treasure) then
            hasTreasure = true
         end
         table.insert(revealedCards, card)
      end
   end
   local modalParams = {
      title = currentPlayer.name,
      msg = hasTreasure and "Select a card for "..player.name.." to discard." or player.name.."'s revealed cards to be discarded.",
      cards = revealedCards,
      target = self,
      min = hasTreasure and 1 or nil,
      max = hasTreasure and 1 or nil,
      types = Treasure,
      afterSelection = self.handleCardSelectionModal,
      isSelection = hasTreasure,
      player = player
   }
   gameScreen:showCardSelectionModal(modalParams)
end

function PirateShip.handleCardSelectionModal(params)
   local selectedCard = params.selectedCards[1]
   local currentPlayer = game:getCurrentPlayerForTurn()
   if selectedCard then
      if not params.target.tokenGained then
         params.target.tokenGained = true
         currentPlayer:addCoinToken()
      end
      params.player:trashCard(removeFromTable(params.cards, selectedCard))
   end
   for k,card in pairs(params.cards) do
      params.player:discardCard(card)
   end
   game:nextAttackTurn()
end
