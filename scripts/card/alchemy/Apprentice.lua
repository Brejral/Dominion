-- Apprentice class
require "scripts.card.action.Action"

local params = {
   image = "images/Alchemy/Apprentice.png",
   cost = 5,
   actions = 1
}

class.Apprentice(Action)

function Apprentice:__init()
   self.Action:__init(params)    -- the new instance
end

function Apprentice:playAction()
   self.Action.playAction(self)
   local selectionParams = {card = self, min = 1, max = 1}
   gameScreen:setupForHandSelection(selectionParams)
end

function Apprentice:handleHandSelection(cards)
   local card = cards[1]
   if card then
      local player = game:getCurrentPlayerForTurn()
      player:trashCard(card)
      player:addCoins(card:getCost() + (card:costsPotion() and 2 or 0))
   end
   self:endAction()
end
