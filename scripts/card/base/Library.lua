-- Library class
require "scripts.card.action.Action"

local params = {
   image = "images/Base/Library.png",
   cost = 5
}

class.Library(Action)

function Library:__init()
   self.Action:__init(params)    -- the new instance
end

function Library:playAction()
   self.Action.playAction(self)
   self.setAsideCards = {}
   self:drawCards()
end

function Library:drawCards()
   local player = game:getCurrentPlayerForTurn()
   while #player.hand < 7 do
      player:checkForDeckResupply()
      if #player.deck == 0 then
         break
      else
         table.insert(player.hand, table.remove(player.deck))
         player.stats.totalCards = player.stats.totalCards + 1
         if player.hand[#player.hand]:is_a(Action) then
            local msg = "Keep card in hand or set aside?"
            local modalParams = {
               title = game:getCurrentPlayerForTurn().name,
               target = self,
               player = player,
               afterSelection = self.handleChoiceModal,
               cards = {player.hand[#player.hand]},
               choices = {"Set Aside", "Keep"},
               msg = msg
            }
            gameScreen:showChoiceModal(modalParams)
            return
         end
         gameScreen:update()
      end
   end
   for k,card in pairs(self.setAsideCards) do
      player:discardCard(card)
   end
   self:endAction()
end

function Library.handleChoiceModal(params)
   if params.selection == "Set Aside" then
      table.insert(params.target.setAsideCards, table.remove(params.player.hand))
   end
   params.target:drawCards()
end
