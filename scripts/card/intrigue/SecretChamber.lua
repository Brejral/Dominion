-- SecretChamber class
require "scripts.card.action.Reaction"

local params = {
   image = "images/Intrigue/SecretChamber.png",
   cost = 2,
   reaction = "Attack"
}

class.SecretChamber(Reaction)

function SecretChamber:__init()
   self.Reaction:__init(params)    -- the new instance
end

function SecretChamber:playAction()
   self.Action.playAction(self)
   local selectionParams = {card = self}
   gameScreen:setupForHandSelection(selectionParams)
end

function SecretChamber:handleHandSelection(cards)
   local player = game:getCurrentPlayerForTurn()
   player:discardCards(cards)
   player:addCoins(#cards)
   self:endAction()
end

function SecretChamber:performReaction()
   local reactionParams = {
      title = game:getCurrentPlayerForAttack().name,
      msg = "Reveal this card from hand to get +2 Cards and put 2 cards from hand on top of deck?",
      cards = {self},
      target = self,
      afterSelection = self.handleChoiceModal,
      choices = {"No", "Yes"}
   }
   self.Reaction:performReaction(reactionParams)
end

function SecretChamber.handleChoiceModal(params)
   if params.selection == "Yes" then
      local player = game:getCurrentPlayerForAttack()
      player:drawCards(2)
      local selectionParams = {
         player = player,
         msg = "Put 2 cards from your hand on top of your deck. (First selected will be last drawn)",
         min = 2,
         max = 2,
         afterSelection = params.target.handleHandSelectionModal,
         isNegative = true,
         target = params.target,
         isOrdering = true
      }
      gameScreen:showHandSelectionModal(selectionParams)
   else
      game:performAttackChecks()
   end
end

function SecretChamber.handleHandSelectionModal(params)
   local player = game:getCurrentPlayerForAttack()
   for k,card in pairs(params.orderedCards) do
      player:addToDeck(table.remove(player.hand, indexOf(player.hand, card)))
   end
   game:performAttackChecks()
end
