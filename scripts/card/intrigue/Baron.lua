-- Baron class
require "scripts.card.action.Action"

local params = {
   image = "images/Intrigue/Baron.png",
   cost = 4,
   buys = 1
}

class.Baron(Action)

function Baron:__init()
   self.Action:__init(params)    -- the new instance
end

function Baron:playAction()
   self.Action.playAction(self)
   local player = game:getCurrentPlayerForTurn()
   if player:hasTypeInHand(Estate) then
      local modalParams = {
         title = player.name,
         msg = "Discard Estate from hand?",
         cards = {game.cardSupply:getCardObj("Estate")},
         afterSelection = self.handleChoiceModal,
         target = self,
         choices = {"Keep", "Discard"}
      }
      gameScreen:showChoiceModal(modalParams)
   else
      player:gainCardFromSupply("Estate")
      self:endAction()
   end
end

function Baron.handleChoiceModal(params)
   local player = game:getCurrentPlayerForTurn()
   if params.selection == "Discard" then
      for k,card in pairs(player.hand) do
         if card:is_a(Estate) then
            player:discardCard(card)
            break
         end
      end
      player:addCoins(4)
   else
      player:gainCardFromSupply("Estate")
   end
   params.target:endAction()
end
