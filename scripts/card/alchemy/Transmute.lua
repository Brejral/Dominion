-- Transmute class
require "scripts.card.action.Action"

local params = {
   image = "images/Alchemy/Transmute.png",
   cost = 0,
   costsPotion = true
}

class.Transmute(Action)

function Transmute:__init()
   self.Action:__init(params)    -- the new instance
end

function Transmute:playAction()
   self.Action.playAction(self)
   local selectionParams = {card = self, max = 1, min = 1}
   gameScreen:setupForHandSelection(selectionParams)
end

function Transmute:handleHandSelection(cards)
   local player = game:getCurrentPlayerForTurn()
   local card = cards[1]
   player:trashCard(card)
   if card:is_a(Victory) then
      player:gainCardFromSupply("Gold")
   end
   if card:is_a(Action) then
      player:gainCardFromSupply("Duchy")
   end
   if card:is_a(Treasure) then
      player:gainCardFromSupply("Transmute")
   end
   self:endAction()
end
