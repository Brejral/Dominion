-- Minion class
require "scripts.card.action.Attack"

local params = {
   image = "images/Intrigue/Minion.png",
   cost = 5,
   actions = 1
}

class.Minion(Attack)

function Minion:__init()
   self.Attack:__init(params)    -- the new instance
end

function Minion:playAction()
   local modalParams = {
      title = game:getCurrentPlayerForTurn().name,
      msg = "Choose one:\n1. +2 coins\n2. Discard hand, +4 cards and each other player with at least 5 cards in hand discards hand and draws 4 cards.",
      cards = {self},
      afterSelection = self.handleChoiceModal,
      target = self,
      choices = {"Attack", "Coins"}
   }
   gameScreen:showChoiceModal(modalParams)
end

function Minion.handleChoiceModal(params)
   local player = game:getCurrentPlayerForTurn()
   params.target.isAttack = params.selection == "Attack"
   if params.selection == "Attack" then
      params.target.Attack:playAction()
      player:discardHand()
      player:drawCards(4)
   else
      params.target.Action:playAction()
      player:addCoins(2)
   end
   gameScreen:update()
end

function Minion:performAttack(player)
   if self.isAttack and #player.hand >= 5 then
      player:discardHand()
      player:drawCards(4)
   end
   game:nextAttackTurn()
end
