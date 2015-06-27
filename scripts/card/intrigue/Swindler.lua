-- Swindler class
require "scripts.card.action.Attack"

local params = {
   image = "images/Intrigue/Swindler.png",
   cost = 3,
   coins = 2
}

class.Swindler(Attack)

function Swindler:__init()
   self.Attack:__init(params)    -- the new instance
end

function Swindler:playAction()
   self.Attack.playAction(self)
end

function Swindler:performAttack(player)
   player:checkForDeckResupply()
   local card = table.remove(player.deck)
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
end

function Swindler.handleChoiceModal(params)
   local player = game:getCurrentPlayerForTurn()
   player:trashCard(params.cards[1])
   local cost = params.cards[1]:getCost()
   local potion = params.cards[1]:costsPotion()
   local selectionParams = {card = params.target, minCost = cost, minPotion = potion, maxCost = cost, maxPotion = potion}
   gameScreen:setupForSupplySelection(selectionParams)
end

function Swindler:handleSupplySelection(cards)
   if #cards > 0 then
      local card = cards[1]
      local player = game:getCurrentPlayerForAttack()
      player:gainCardFromSupply(card)
   end
   game:nextAttackTurn()
end
