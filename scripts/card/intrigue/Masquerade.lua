-- Masquerade class
require "scripts.card.action.Action"

local params = {
   image = "images/Intrigue/Masquerade.png",
   cost = 3,
   cards = 2
}

class.Masquerade(Action)

function Masquerade:__init()
   self.Action:__init(params)    -- the new instance
end

function Masquerade:playAction()
   self.Action.playAction(self)
   self.isPassingPhase = true
   self.passedCards = {}
   game:setupForEachPlayerAction(self)
end

function Masquerade:performEachPlayerAction(player)
   local modalParams = {
      player = player,
      min = 1,
      max = 1,
      afterSelection = self.handleHandSelectionModal,
      msg = msg,
      target = self,
      isNegative = true
   }
   if self.isPassingPhase then
      modalParams.msg = "Select a card to pass to "..game:getNextPlayer(player).name.."."
   else
      modalParams.msg = "You may trash a card from your hand."
      modalParams.min = 0
   end
   gameScreen:showHandSelectionModal(modalParams)
end

function Masquerade.handleHandSelectionModal(params)
   local selectedCard = #params.selectedCards > 0 and params.selectedCards[1] or nil
   if params.target.isPassingPhase then
      table.insert(params.target.passedCards, table.remove(params.player.hand, indexOf(params.player.hand, selectedCard)))
      if #game.eachPlayerActionList == 0 then
         local nextPlayer = game:getCurrentPlayerForTurn()
         while #params.target.passedCards > 0 do
            nextPlayer = game:getNextPlayer(nextPlayer)
            table.insert(nextPlayer.hand, table.remove(params.target.passedCards, 1))
         end
         params.target.isPassingPhase = false
         game:setupForEachPlayerAction(params.target)
      else
         game:performEachPlayerAction()
      end
   else
      if selectedCard then
         params.player:trashCard(selectedCard)
      end
      game:performEachPlayerAction()
   end
end
