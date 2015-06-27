-- Nobles class
require "scripts.card.action.Action"
require "scripts.card.victory.Victory"

local params = {
   image = "images/Intrigue/Nobles.png",
   cost = 6,
   points = 2
}

class.Nobles(Action, Victory)

function Nobles:__init()
   self.Action:__init(params)
   self.Victory:__init(params)
end

function Nobles:playAction()
   self.Action.playAction(self)
   local player = game:getCurrentPlayerForTurn()
   local modalParams = {
      title = game:getCurrentPlayerForTurn().name,
      msg = "Choose one:\n1. +3 Cards\n2. +2 Actions",
      cards = {self},
      afterSelection = self.handleChoiceModal,
      target = self,
      choices = {"Actions", "Cards"}
   }
   gameScreen:showChoiceModal(modalParams)
end

function Nobles.handleChoiceModal(params)
   local player = game:getCurrentPlayerForTurn()
   if params.selection == "Cards" then
      player:drawCards(3)
   elseif params.selection == "Actions" then
      player:addActions(2)
   end
   params.target:endAction()
end
