-- Chancellor class
require "scripts.card.action.Action"

local params = {
   image = "images/Base/Chancellor.png",
   cost = 3,
   coins = 2
}

class.Chancellor(Action)

function Chancellor:__init()
   self.Action:__init(params)    -- the new instance
end

function Chancellor:playAction()
   self.Action.playAction(self)
   local modalParams = {
      title = game:getCurrentPlayerForTurn().name,
      msg = "Move deck to discard pile?",
      cards = {self},
      afterSelection = self.handleChoiceModal,
      target = self,
      choices = {"No", "Yes"}
   }
   gameScreen:showChoiceModal(modalParams)
end

function Chancellor.handleChoiceModal(params)
   if params.selection == "Yes" then
      local player = game:getCurrentPlayerForTurn()
      while #player.deck > 0 do
         player:discardCard(table.remove(player.deck))
      end
   end
   params.target:endAction()
end