-- Steward class
require "scripts.card.action.Action"

local params = {
   image = "images/Intrigue/Steward.png",
   cost = 3
}

class.Steward(Action)

function Steward:__init()
   self.Action:__init(params)    -- the new instance
end

function Steward:playAction()
   self.Action.playAction(self)
   local player = game:getCurrentPlayerForTurn()
   local modalParams = {
      title = game:getCurrentPlayerForTurn().name,
      msg = "Choose one:\n1. +2 Cards\n2. +2 Coins\n3. Trash 2 cards in hand.",
      cards = {self},
      afterSelection = self.handleChoiceModal,
      target = self,
      choices = {"Trash", "Coins", "Cards"}
   }
   gameScreen:showChoiceModal(modalParams)
end

function Steward.handleChoiceModal(params)
   local player = game:getCurrentPlayerForTurn()
   if params.selection == "Cards" then
      player:drawCards(2)
      params.target:endAction()
   elseif params.selection == "Coins" then
      player:addCoins(2)
      params.target:endAction()
   elseif params.selection == "Trash" then
      local selectionParams = {card = params.target, max = 2, min = 2}
      gameScreen:setupForHandSelection(selectionParams)
   end
end

function Steward:handleHandSeletion(cards)
   local player = game:getCurrentPlayerForTurn()
   for k,card in pairs(cards) do
      player:trashCard(card)
   end
   self:endAction()
end
