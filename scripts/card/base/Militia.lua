-- Militia class
require "scripts.card.action.Attack"

local params = {
   image = "images/Base/Militia.png",
   cost = 4,
   coins = 2
}

class.Militia(Attack)

function Militia:__init()
   self.Attack:__init(params)    -- the new instance
end

function Militia:playAction()
   self.Attack.playAction(self)
end

function Militia:performAttack(player)
   if #player.hand <= 3 then
      game:nextAttackTurn()
   else
      local msg = "Discard down to 3 cards in hand. Select cards to discard."
      local modalParams = {
         player = player,
         min = #player.hand - 3,
         max = #player.hand - 3,
         afterSelection = self.handleHandSelectionModal,
         msg = msg,
         isNegative = true
      }
      gameScreen:showHandSelectionModal(modalParams)
   end
end

function Militia.handleHandSelectionModal(params)
   local player = params.player
   local selectedCards = params.selectedCards
   for k,card in pairs(selectedCards) do
      player:discardCard(card)
   end
   game:nextAttackTurn()
end
