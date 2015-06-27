-- TreasureMap class
require "scripts.card.action.Action"

local params = {
   image = "images/Seaside/TreasureMap.png",
   cost = 4
}

class.TreasureMap(Action)

function TreasureMap:__init()
   self.Action:__init(params)    -- the new instance
end

function TreasureMap:playAction()
   self.Action.playAction(self)
   local player = game:getCurrentPlayerForTurn()
   player:trashCard(self)
   for k,card in pairs(player.hand) do
      if card:is_a(TreasureMap) then
         player:trashCard(card)
         for i = 1,4 do
            player:addToDeck(game.cardSupply:getCard("Gold"))
         end
         break
      end
   end
   self:endAction()
end