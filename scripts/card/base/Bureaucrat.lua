-- Bureaucrat class
require "scripts.card.action.Attack"

local params = {
   image = "images/Base/Bureaucrat.png",
   cost = 4
}

class.Bureaucrat(Attack)

function Bureaucrat:__init()
   self.Attack:__init(params)    -- the new instance
end

function Bureaucrat:playAction()
   local player = game:getCurrentPlayerForTurn()
   player:addToDeck(game.cardSupply:getCard("Silver"))
   self.Attack.playAction(self)
end

function Bureaucrat:performAttack(player)
   if not player:hasTypeInHand(Victory) then
      game:nextAttackTurn()
   else
      local msg = "Select a victory card to place on top of deck."
      local modalParams = {
         player = player,
         min = 1,
         max = 1,
         types = Victory,
         afterSelection = self.handleHandSelectionModal,
         msg = msg,
         isNegative = true
      }
      gameScreen:showHandSelectionModal(modalParams)
   end
end

function Bureaucrat.handleHandSelectionModal(params)
   local player = params.player
   local selectedCards = params.selectedCards
   for k,card in pairs(selectedCards) do
      player:addToDeck(removeFromTable(player.hand, card))
   end
   game:nextAttackTurn()
end
