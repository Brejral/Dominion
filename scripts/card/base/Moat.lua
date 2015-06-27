-- Moat class
require "scripts.card.action.Reaction"

local params = {
   image = "images/Base/Moat.png",
   cost = 2,
   cards = 2,
   reaction = "Attack"
}

class.Moat(Reaction)

function Moat:__init()
   self.Reaction:__init(params)    -- the new instance
end

function Moat:playAction()
   self.Action.playAction(self)
   self:endAction()
end

function Moat:performReaction()
   local reactionParams = {
      title = game:getCurrentPlayerForAttack().name,
      msg = "Reveal this card from hand to prevent the attack?",
      cards = {self},
      afterSelection = self.handleChoiceModal,
      choices = {"No", "Yes"}
   }
   self.Reaction:performReaction(reactionParams)
end

function Moat.handleChoiceModal(params)
   if params.selection == "Yes" then
      game.performAttack = false
   end
   game:performAttackChecks()
end