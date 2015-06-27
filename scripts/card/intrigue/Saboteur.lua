-- Saboteur class
require "scripts.card.action.Attack"

local params = {
   image = "images/Intrigue/Saboteur.png",
   cost = 5
}

class.Saboteur(Attack)

function Saboteur:__init()
   self.Attack:__init(params)    -- the new instance
end

function Saboteur:playAction()
   self.Attack.playAction(self)
end

function Saboteur:performAttack(player)
   local revealedCards = {}
   player:checkForDeckResupply()
   local card = table.remove(player.deck)
   while card:getCost() < 3 do
      table.insert(revealedCards, card)
      player:checkForDeckResupply()
      if #player.deck == 0 then
         card = nil
         break
      end
      card = table.remove(player.deck)
   end
   while #revealedCards > 0 do
      player:discardCard(table.remove(revealedCards))
   end
   if card then
      local modalParams = {
         title = game:getCurrentPlayerForTurn().name,
         msg = "This card was trashed.",
         cards = {card},
         afterSelection = self.handleChoiceModal,
         target = self,
         player = player,
         choices = {"OK"}
      }
      gameScreen:showChoiceModal(modalParams)
   else
      game:nextAttackTurn()
   end
end

function Saboteur.handleChoiceModal(params)
   local player = game:getCurrentPlayerForTurn()
   local card = params.card[1]
   player:trashCard(card)
   local selectionParams = {card = params.target, maxCost = card:getCost() - 2, maxPotion = card:costsPotion(), min = 0}
   gameScreen:setupForSupplySelection(selectionParams)
end

function Saboteur:handleSupplySelection(cards)
   if #cards > 0 then
      local card = cards[1]
      local player = game:getCurrentPlayerForAttack()
      player:gainCardFromSupply(card)
   end
   game:nextAttackTurn()
end
