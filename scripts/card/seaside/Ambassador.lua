-- Ambassador class
require "scripts.card.action.Attack"

local params = {
   image = "images/Seaside/Ambassador.png",
   cost = 3
}

class.Ambassador(Attack)

function Ambassador:__init()
   self.Attack:__init(params)    -- the new instance
end

function Ambassador:playAction()
   local selectionParams = {card = self, min = 1, max = 1}
   gameScreen:setupForHandSelection(selectionParams)
end

function Ambassador:handleHandSelection(cards)
   local player = game:getCurrentPlayerForTurn()
   local card = cards[1]
   cards = {}
   self.selectedCardName = classname(card)
   for k,c in pairs(player.hand) do
      if classname(c) == classname(card) then
         table.insert(cards, c)
         if #cards == 2 then break end
      end
   end
   local modalParams = {
      title = game:getCurrentPlayerForTurn().name,
      msg = "Select up to 2 cards to return to supply.",
      cards = {cards},
      afterSelection = self.handleCardSelectionModal,
      target = self,
      min = 0,
      max = 2
   }
   if params.selection == "Attack" then
      player:discardHand()
      player:drawCards(4)
   else
      player:addCoins(2)
   end
   gameScreen:update()
end

function Ambassador.handleCardSelectionModal(params)
   local player = game:getCurrentPlayerForTurn()
   local selectedCards = params.selectedCards
   game.cardSupply:addCardsToSupply(params.target.selectedCardName, #selectedCards)
   for k,card in pairs(selectedCards) do
      table.remove(player.hand, indexOf(player.hand, card))
   end
   params.target.Attack.playAction(params.target)
end

function Ambassador:performAttack(player)
   player:gainCardFromSupply(self.selectedCardName)
   game:nextAttackTurn()
end
