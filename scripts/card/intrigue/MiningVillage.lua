-- MiningVillage class
require "scripts.card.action.Action"

local params = {
   image = "images/Intrigue/MiningVillage.png",
   cost = 4,
   actions = 2,
   cards = 1
}

class.MiningVillage(Action)

function MiningVillage:__init()
   self.Action:__init(params)    -- the new instance
end

function MiningVillage:playAction()
   self.Action.playAction(self)
   local player = game:getCurrentPlayerForTurn()
   local modalParams = {
      title = player.name,
      msg = "Trash this card?",
      cards = {self},
      afterSelection = self.handleChoiceModal,
      target = self,
      choices = {"Keep", "Trash"}
   }
   gameScreen:showChoiceModal(modalParams)
end

function MiningVillage.handleChoiceModal(params)
   if params.selection == "Trash" then
      local player = game:getCurrentPlayerForTurn()
      player:trashCard(params.target)
      player:addCoins(2)
   end
   params.target:endAction()
end
