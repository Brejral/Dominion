-- Golem class
require "scripts.card.action.Action"

local params = {
   image = "images/Alchemy/Golem.png",
   cost = 4,
   costsPotion = true
}

class.Golem(Action)

function Golem:__init()
   self.Action:__init(params)    -- the new instance
end

function Golem:playAction()
   self.Action.playAction(self)
   local count = 0
   local player = game:getCurrentPlayerForTurn()
   local revealedCards = {}
   self.actionCards = {}
   while count < 2 do
      player:checkForDeckResupply()
      if #player.deck == 0 then break end
      local card = table.remove(player.deck)
      if card:is_a(Action) then
         table.insert(self.actionCards, card)
         player.stats.totalCards = player.stats.totalCards + 1
         count = count + 1
      else
         table.insert(revealedCards, card)
      end
   end
   for k,card in pairs(revealedCards) do
      player:discardCard(card)
   end
   local modalParams = {
      title = player.name,
      msg = "Revealed cards that were discarded.",
      cards = revealedCards,
      afterSelection = self.handleCardSelectionModalDiscard,
      target = self,
      isSelection = false
   }
   gameScreen:showCardSelectionModal(modalParams)
end

function Golem.handleCardSelectionModalDiscard(params)
   local player = game:getCurrentPlayerForTurn()
   local isSelection = #params.target.actionCards == 2
   local modalParams = {
      title = player.name,
      msg = isSelection and "Choose which action to play first. (the other will be played second)" or
      #params.target.actionCards > 0 and "This card will be played." or "No action cards found.",
      cards = params.target.actionCards,
      afterSelection = params.target.handleCardSelectionModalAction,
      target = params.target,
      min = 1,
      max = 1,
      isSelection = isSelection
   }
   if #params.target.actionCards == 1 then
      modalParams.selectedCards = params.target.actionCards
   end
   gameScreen:showCardSelectionModal(modalParams)
end

function Golem.handleCardSelectionModalAction(params)
   local action = removeFromTable(params.target.actionCards, params.selectedCards[1])
   if action then
      local otherAction = #params.target.actionCards > 0 and params.target.actionCards[1] or nil
      local player = game:getCurrentPlayerForTurn()
      local otherActionPlayed = false
      local actionEndFunction = Runtime._functionListeners.actionEnd[1]
      local function actionEndListener(event)
         if not otherAction or otherActionPlayed then
            Runtime._functionListeners.actionEnd[1] = nil
            Runtime:addEventListener("actionEnd", actionEndFunction)
            params.target:endAction()
         else
            otherActionPlayed = true
            player:addActions(1)
            otherAction:playAction()
         end
      end
      Runtime._functionListeners.actionEnd[1] = nil
      Runtime:addEventListener("actionEnd", actionEndListener)
      player:addActions(1)
      player:playCard(action)
   else
      params.target:endAction()
   end
end
