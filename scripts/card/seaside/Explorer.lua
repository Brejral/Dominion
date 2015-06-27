-- Explorer class
require "scripts.card.action.Action"

local params = {
   image = "images/Seaside/Explorer.png",
   cost = 5
}

class.Explorer(Action)

function Explorer:__init()
   self.Action:__init(params)    -- the new instance
end

function Explorer:playAction()
   self.Action.playAction(self)
   local player = game:getCurrentPlayerForTurn()
   local hasProvince = false
   for k,card in pairs(player.hand) do
      if card:is_a(Province) then
         hasProvince = true
         break
      end
   end
   if not hasProvince then
      player:addCardToHandFromSupply("Silver")
      self:endAction()
   else
      local modalParams = {
         title = player.name,
         msg = "Reveal a Province from hand to gain a Gold?",
         cards = {self},
         afterSelection = self.handleChoiceModal,
         target = self,
         choices = {"No", "Yes"}
      }
      gameScreen:showChoiceModal(modalParams)
   end
end

function Explorer.handleChoiceModal(params)
   local player = game:getCurrentPlayerForTurn()
   player:addCardToHandFromSupply(params.selection == "Yes" and "Gold" or "Silver")
   params.target:endAction()
end
