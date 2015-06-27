-- Smugglers class
require "scripts.card.action.Action"

local params = {
   image = "images/Seaside/Smugglers.png",
   cost = 3
}

class.Smugglers(Action)

function Smugglers:__init()
   self.Action:__init(params)    -- the new instance
end

function Smugglers:playAction()
   self.Action.playAction(self)
   local types = {}
   local player = game:getCurrentPlayerForTurn()
   local prevPlayer = game:getPrevPlayer(player)
   if #prevPlayer.cardsGainedThisTurn > 0 then
      for k,card in pairs(prevPlayer.cardsGainedThisTurn) do
         if not contains(types, classof(card)) then
            table.insert(types, classof(card))
         end
      end
      local selectionParams = {card = self, types = types, maxCost = 6}
      gameScreen:setupForSupplySelection(selectionParams)
   else
      self:endAction()
   end
end

function Smugglers:handleSupplySelection(cards)
   local player = game:getCurrentPlayerForTurn()
   local card = cards[1]
   player:gainCardFromSupply(card)
   self:endAction()
end
