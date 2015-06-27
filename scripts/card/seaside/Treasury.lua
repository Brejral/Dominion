-- Treasury class
require "scripts.card.action.Action"

local params = {
   image = "images/Seaside/Treasury.png",
   cost = 5,
   cards = 1,
   actions = 1,
   coins = 1
}

class.Treasury(Action)

function Treasury:__init()
   self.Action:__init(params)    -- the new instance
end

function Treasury:playAction()
   self.Action.playAction(self)
   self:endAction()
end

function Treasury:onDiscardFromPlay(player)
   local boughtVictory = false
   for k,card in pairs(player.cardsBoughtThisTurn) do
      if card:is_a(Victory) then
         boughtVictory = true
         break
      end
   end
   if not boughtVictory then
      local modalParams = {
         title = player.name,
         msg = "Move to top of deck?",
         choices = {"No","Yes"},
         afterSelection = self.handleChoiceModal,
         cards = {self},
         target = self
      }
      gameScreen:showChoiceModal(modalParams)
   else
      player:checkForDiscardFromPlayCards()
   end
end

function Treasury.handleChoiceModal(params)
   local player = game:getCurrentPlayerForTurn()
   if params.selection == "Yes" then
      player:addToDeck(removeFromTable(player.playedCards, params.target))
   end
   player:checkForDiscardFromPlayCards()
end
