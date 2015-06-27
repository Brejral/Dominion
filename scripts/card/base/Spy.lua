-- Spy class
require "scripts.card.action.Attack"

local params = {
   image = "images/Base/Spy.png",
   cost = 4
}

class.Spy(Attack)

function Spy:__init()
   self.Attack:__init(params)    -- the new instance
end

function Spy:playAction()
   local revealedCards = {}
   local player = game:getCurrentPlayerForTurn()
   player:addActions(1)
   player:drawCard()
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

function Spy:performAttack(player)
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

function Spy.handleChoiceModal(params)
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
