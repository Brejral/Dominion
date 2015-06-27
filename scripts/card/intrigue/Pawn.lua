-- Pawn class
require "scripts.card.action.Action"

local params = {
   image = "images/Intrigue/Pawn.png",
   cost = 2
}

class.Pawn(Action)

function Pawn:__init()
   self.Action:__init(params)    -- the new instance
end

function Pawn:playAction()
   self.Action.playAction(self)
   local player = game:getCurrentPlayerForTurn()
   local modalParams = {
      title = player.name,
      msg = "Choose two:\n1. +1 Card\n2. +1 Action\n3. +1 Buy\n4. +1 Coin",
      cards = {self},
      afterSelection = self.handleChoiceModal,
      target = self,
      numSelections = 2,
      choices = {"Coin","Buy","Action","Card"}
   }
   gameScreen:showChoiceModal(modalParams)
end

function Pawn.handleChoiceModal(params)
   local player = game:getCurrentPlayerForTurn()
   for k,selection in pairs(params.selections) do
      if selection == "Card" then
         player:drawCard()
      elseif selection == "Buy" then
         player:addBuys(1)
      elseif selection == "Action" then
         player:addActions(1)
      elseif selection == "Coin" then
         player:addCoins(1)
      end
   end
   params.target:endAction()
end
