-- ThroneRoom class
require "scripts.card.action.Action"

local params = {
   image = "images/Base/ThroneRoom.png",
   cost = 4
}

class.ThroneRoom(Action)

function ThroneRoom:__init()
   self.Action:__init(params)    -- the new instance
end

function ThroneRoom:playAction()
   self.Action.playAction(self)
   local selectionParams = {card = self, max = 1, min = 0, types = Action}
   gameScreen:setupForHandSelection(selectionParams)
end

function ThroneRoom:handleHandSelection(cards)
   if #cards == 1 then
      local action = cards[1]
      local timesPlayed = 0
      local actionEndFunction = Runtime._functionListeners.actionEnd[1]
      local player = game:getCurrentPlayerForTurn()
      local function actionEndListener(event)
         timesPlayed = timesPlayed + 1
         if timesPlayed == 2 then
            Runtime._functionListeners.actionEnd[1] = nil
            Runtime:addEventListener("actionEnd", actionEndFunction)
            self:endAction()
         else
            player:addActions(1)
            action:playAction()
         end
      end
      Runtime._functionListeners.actionEnd[1] = nil
      Runtime:addEventListener("actionEnd", actionEndListener)
      player:addActions(1)
      player:playCard(action)
   else
      self:endAction()
   end
end
