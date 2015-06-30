-- PearlDiver class
require "scripts.card.action.Action"

local params = {
   image = "images/Seaside/PearlDiver.png",
   cost = 2,
   cards = 1,
   actions = 1
}

class.PearlDiver(Action)

function PearlDiver:__init()
   self.Action:__init(params)    -- the new instance
end

function PearlDiver:playAction()
   self.Action.playAction(self)
   local player = game:getCurrentPlayerForTurn()
   player:checkForDeckResupply()
   local revealedCard = table.remove(player.deck, 1)
   local modalParams = {
      title = player.name,
      msg = "You may move the bottom card of the deck to the top.",
      target = self,
      cards = {revealedCard},
      choices = {"Keep on Bottom", "Move to Top"},
      afterSelection = self.handleChoiceModal
   }
   gameScreen:showChoiceModal(modalParams)
end

function PearlDiver.handleChoiceModal(params)
   local player = game:getCurrentPlayerForTurn()
   if params.selection == "Move to Top" then
      player:addToDeck(params.cards[1])
   else
      player:addToDeck(params.cards[1], 1)
   end
   params.target:endAction()
end
