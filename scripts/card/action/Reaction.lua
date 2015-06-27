require "scripts.card.action.Action"

-- Reaction class
class.Reaction(Action)

-- This function creates a new instance of Reaction
--
function Reaction:__init(params)
   self.Action:__init(params)    -- the new instance

   --Properties
   params = params or {}
   self.reaction = params.reaction
end

-- Here are some functions (methods) for Reaction:

function Reaction:performReaction(params)
   gameScreen:showChoiceModal(params)
end

function Reaction:getReactionType()
   return self.reaction
end
