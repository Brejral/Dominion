-- NativeVillage class
require "scripts.card.action.Action"

local params = {
   image = "images/Seaside/NativeVillage.png",
   cost = 2,
   actions = 2
}

class.NativeVillage(Action)

function NativeVillage:__init()
   self.Action:__init(params)    -- the new instance
end

function NativeVillage:playAction()
   self.Action.playAction(self)
   local player = game:getCurrentPlayerForTurn()
   local modalParams = {
      title = player.name,
      msg = "Choose one:\n1. Set aside top card of deck face down on Native Village mat.\n2. Put all cards from mat into hand. (Cards on mat shown below)",
      choices = {"Mat To Hand", "Deck To Mat"},
      cards = player.nativeVillageMat,
      afterSelection = self.handleChoiceModal,
      target = self
   }
   gameScreen:showChoiceModal(modalParams)
end

function NativeVillage.handleChoiceModal(params)
   local player = game:getCurrentPlayerForTurn()
   if params.selection == "Mat To Hand" then
      while #player.nativeVillageMat > 0 do
         table.insert(player.hand, table.remove(player.nativeVillageMat))
      end
   else
      table.insert(player.nativeVillageMat, table.remove(player.deck))
   end
   params.target:endAction()
end
