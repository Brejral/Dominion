-- Thief class
require "scripts.card.action.Attack"

local params = {
   image = "images/Base/Thief.png",
   cost = 4
}

class.Thief(Attack)

function Thief:__init()
   self.Attack:__init(params)    -- the new instance
end

function Thief:playAction()
   self.Attack.playAction(self)
end

function Thief:performAttack(player)
   local revealedCards = {}
   local hasTreasure = false
   while #revealedCards < 2 do
      player:checkForDeckResupply()
      table.insert(revealedCards, table.remove(player.deck))
      hasTreasure = hasTreasure or revealedCards[#revealedCards]:is_a(Treasure)
   end
   local msg = hasTreasure and "Select card for "..player.name.." to trash."
      or player.name.."'s revealed cards to be discarded."
   local modalParams = {
      title = game:getCurrentPlayerForTurn().name,
      target = self,
      player = player,
      max = 1,
      afterSelection = self.handleCardSelectionModal,
      cards = revealedCards,
      types = Treasure,
      msg = msg,
      isSelection = hasTreasure,
      isNegative = true
   }
   gameScreen:showCardSelectionModal(modalParams)
end

function Thief.handleCardSelectionModal(params)
   local player = params.player
   local selectedCards = params.selectedCards
   for k,card in pairs(selectedCards) do
      removeFromTable(params.cards, card)
   end
   for k,card in pairs(params.cards) do
      player:discardCard(card)
   end
   if #selectedCards == 0 then
      game:nextAttackTurn()
   else
      local modalParams = {
         title = game:getCurrentPlayerForTurn().name,
         msg = "Gain this card, or move to trash?",
         cards = selectedCards,
         afterSelection = params.target.handleChoiceModal,
         target = params.target,
         choices = {"Trash", "Gain"}
      }
      gameScreen:showChoiceModal(modalParams)
   end
end

function Thief.handleChoiceModal(params)
   local player = game:getCurrentPlayerForTurn()
   if params.selection == "Gain" then
      player:discardCard(params.cards[1])
   else
      player:trashCard(params.cards[1])
   end
   game:nextAttackTurn()
end
