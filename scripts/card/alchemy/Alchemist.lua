-- Alchemist class
require "scripts.card.action.Action"

local params = {
   image = "images/Alchemy/Alchemist.png",
   cost = 3,
   actions = 1,
   cards = 2,
   costsPotion = true
}

class.Alchemist(Action)

function Alchemist:__init()
   self.Action:__init(params)    -- the new instance
end

function Alchemist:playAction()
   self.Action.playAction(self)
   self:endAction()
end

function Alchemist:onDiscardFromPlay(player)
   local hasPotion = false
   for k,card in pairs(player.playedCards) do
      if card:is_a(Potion) then
         hasPotion = true
         break
      end
   end
   if hasPotion then
      local modalParams = {
         title = player.name,
         msg = "Move this to top of the deck?",
         afterSelection = self.handleChoiceSelection,
         choices = {"No", "Yes"},
         cards = {self},
         target = self
      }
      gameScreen:showChoiceModal(modalParams)
   else
      player:checkForDiscardFromPlayCards()
   end
end

function Alchemist.handleChoiceSelection(params)
   local player = game:getCurrentPlayerForTurn()
   if params.selection == "Yes" then
      player:addToDeck(removeFromTable(player.playedCards, params.target))
   end
   player:checkForDiscardFromPlayCards()
end
