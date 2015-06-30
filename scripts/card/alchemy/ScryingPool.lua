-- ScryingPool class
require "scripts.card.action.Attack"

local params = {
   image = "images/Alchemy/ScryingPool.png",
   cost = 2,
   actions = 1,
   costsPotion = true
}

class.ScryingPool(Attack)

function ScryingPool:__init()
   self.Attack:__init(params)    -- the new instance
end

function ScryingPool:playAction()
   local revealedCards = {}
   local player = game:getCurrentPlayerForTurn()
   player:addActions(1)
   player:checkForDeckResupply()
   table.insert(revealedCards, table.remove(player.deck))
   local msg = "Keep card on top of your deck or discard?"
   local modalParams = {
      title = player.name,
      target = self,
      player = player,
      afterSelection = self.handleChoiceModal,
      cards = revealedCards,
      choices = {"Discard", "Keep"},
      isBeforeAttack = true,
      msg = msg
   }
   gameScreen:showChoiceModal(modalParams)
end

function ScryingPool:performAttack(player)
   local revealedCards = {}
   player:checkForDeckResupply()
   table.insert(revealedCards, table.remove(player.deck))
   local msg = "Keep card on top of "..player.name.."'s deck or discard?"
   local modalParams = {
      title = game:getCurrentPlayerForTurn().name,
      target = self,
      player = player,
      afterSelection = self.handleChoiceModal,
      cards = revealedCards,
      choices = {"Discard", "Keep"},
      msg = msg
   }
   gameScreen:showChoiceModal(modalParams)
end

function ScryingPool.handleChoiceModal(params)
   if params.selection == "Keep" then
      params.player:addToDeck(params.cards[1])
   else
      params.player:discardCard(params.cards[1])
   end
   if params.isBeforeAttack then
      params.target.Attack.playAction(params.target)
   else
      game:nextAttackTurn()
   end
end

function ScryingPool:endAction()
   local player = game:getCurrentPlayerForTurn()
   local revealedCards = {}
   local card = player:removeFromDeck()
   table.insert(revealedCards, card)
   while not card:is_a(Action) do
      card = player:removeFromDeck()
      if not card then break end
      table.insert(revealedCards, card)
   end
   player:addCardsToHand(revealedCards)
   self.Action.endAction(self)
end
