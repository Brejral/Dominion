-- Tribute class
require "scripts.card.action.Action"

local params = {
   image = "images/Intrigue/Tribute.png",
   cost = 5
}

class.Tribute(Action)

function Tribute:__init()
   self.Action:__init(params)    -- the new instance
end

function Tribute:playAction()
   self.Action.playAction(self)
   local player = game:getCurrentPlayerForTurn()
   local nextPlayer = game:nextPlayer(player)
   local revealedCards = {}
   local actions, treasures, victories = 0, 0, 0
   for i = 1,2 do
      player:checkForDeckResupply()
      local card = table.remove(nextPlayer.deck)
      if card then
         if #revealedCards == 0 or classname(revealedCards[1]) ~= classname(card) then
            if card:is_a(Action) then
               actions = actions + 1
            end
            if card:is_a(Treasure) then
               treasures = treasures + 1
            end
            if card:is_a(Victory) then
               victories = victories + 1
            end
         end
         table.insert(revealedCards, card)
         nextPlayer:discardCard(card)
      end
   end
   local msg = nextPlayer.name.."'s revealed cards:\n("
   if actions > 0 then
      player:addActions(2 * actions)
      msg = msg.."+"..(2 * actions).." Actions"
   end
   if treasures > 0 then
      player:addCoins(2 * treasures)
      msg = msg..(actions > 0 and ", " or "").."+"..(2 * treasures).." Coins"
   end
   if victories > 0 then
      player:drawCards(2 * victories)
      msg = msg..((actions > 0 or treasures > 0) and ", " or "").."+"..(2 * victories).." Cards"
   end
   msg = msg..")"
   local modalParams = {
      title = player.name,
      cards = revealedCards,
      msg = msg,
      target = self,
      afterSelection = self.handleCardSelectionModal,
      isSelection = false
   }
   gameScreen:showCardSelectionModal(modalParams)
end

function Tribute.handleCardSelectionModal(params)
   params.target:endAction()
end
