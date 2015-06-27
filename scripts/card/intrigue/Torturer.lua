-- Torturer class
require "scripts.card.action.Attack"

local params = {
   image = "images/Intrigue/Torturer.png",
   cost = 5,
   cards = 3
}

class.Torturer(Attack)

function Torturer:__init()
   self.Attack:__init(params)    -- the new instance
end

function Torturer:playAction()
   self.Attack.playAction(self)
end

function Torturer:performAttack(player)
   local modalParams = {
      title = player.name,
      msg = "Choose one:\n1. Discard 2 cards.\n2. Gain a Curse.",
      cards = player.hand,
      afterSelection = self.handleAttackChoiceModal,
      target = self,
      player = player,
      choices = {"Curse","Discard"}
   }
   gameScreen:showChoiceModal(modalParams)
end

function Torturer.handleAttackChoiceModal(params)
   if params.selection == "Curse" then
      table.insert(params.player.hand, game.cardSupply:getCard("Curse"))
      game:nextAttackTurn()
   elseif params.selection == "Discard" then
      local modalParams = {
         player = params.player,
         min = 2,
         max = 2,
         afterSelection = params.target.handleHandSelectionModal,
         msg = "Discard 2 cards.",
         isNegative = true
      }
      gameScreen:showHandSelectionModal(modalParams)
   end
end

function Torturer.handleHandSelectionModal(params)
   local selectedCards = params.selectedCards
   local player = game:getCurrentPlayerForAttack()
   while #selectedCards > 0 do
      player:discardCard(table.remove(selectedCards))
   end
   game:nextAttackTurn()
end
