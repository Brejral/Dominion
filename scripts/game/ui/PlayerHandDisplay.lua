-- PlayerHandDisplay Class
PlayerHandDisplay = display.newGroup()
PlayerHandDisplay_mt = { __index = PlayerHandDisplay }

local cardScale = {height = 0.2 * sHeight, width = 0.2 * sHeight / card_ar}

-- Derived class method new
function PlayerHandDisplay:new(params)
   local self = display.newGroup()
   setmetatable(self, PlayerHandDisplay_mt)

   --Properties
   self.cards = {}
   local handText = display.newText {
      text = "Hand",
      font = titleFont,
      fontSize = 12,
      x = 54,
      y = 0.8 * sHeight - 3,
      width = 100,
      height = 0,
      align = "left"
   }

   local line1 = display.newLine (
      35,
      0.8 * sHeight - 5,
      sWidth - 5,
      0.8 * sHeight - 5
   )
   --line1.strokeWidth = 2

   local line2 = display.newLine (
      sWidth - 5,
      0.8 * sHeight - 5,
      sWidth - 5,
      sHeight
   )
   --line2.strokeWidth = 2

   self:insert(handText)
   self:insert(line1)
   self:insert(line2)

   self:update()

   return self
end

function PlayerHandDisplay:update()
   if self.isSelection then
      self:updateForSelection()
   else
      self:updateCardsInHand()
      for k,card in pairs(self.cards) do
         card:addEventListener("touch", handTouchListener)
         card.isEnabled = (game.phase == "Action" and card.card:is_a(Action) or
            game.phase == "Buy" and card.card:is_a(Treasure)) and
            (not gameScreen.cardSupplyDisplay or not gameScreen.cardSupplyDisplay.isSelection)
         if card.isEnabled then
            card:setFillColor(1)
         else
            card:setFillColor(.3)
         end
      end
   end
end

function PlayerHandDisplay:updateCardsInHand()
   local player = game:getCurrentPlayerForTurn()
   self:removeCards()
   for k,v in pairs(player.hand) do
      local image = display.newImage(v:getImage())
      image.card = v
      table.insert(self.cards, image)
      self:insert(image)
      combine(image, cardScale)
      image.x = (k - .5) * image.contentWidth
      image.y = sHeight - image.contentHeight / 2
   end
end

function PlayerHandDisplay:removeCards()
   while #self.cards > 0 do
      table.remove(self.cards, 1):removeSelf()
   end
   self.cards = {}
end

function PlayerHandDisplay:setupForDefault()
   self.isSelection = false
   self.selectionParams = nil
   self:update()
end

function PlayerHandDisplay:setupForSelection(params)
   self.isSelection = true
   self.selectionParams = params or {}
   self:updateCardsInHand()
   self:updateForSelection()
   for k,card in pairs(self.cards) do
      card:addEventListener("touch", selectionTouchListener)
   end
end

function PlayerHandDisplay:updateForSelection()
   local params = self.selectionParams
   local selectedCards = self:getSelectedCards()
   for k,card in pairs(self.cards) do
      card.isEnabled = true
      if params.types ~= nil and not card.isSelected then
         local isType = false
         if params.types[1] ~= nil then
            for k,v in pairs(params.types) do
               if card.card:is_a(v) then
                  isType = true
               end
            end
         else
            isType = card.card:is_a(params.types)
         end
         card.isEnabled = isType
      end
      if params.max and #selectedCards == params.max then
         card.isEnabled = card.isSelected
      end
      if card.isSelected then
         card:setFillColor(0, 1, 0)
      elseif card.isEnabled then
         card:setFillColor(1, 1, 1)
      else
         card:setFillColor(.3)
      end
   end
end

function PlayerHandDisplay:getSelectedCards()
   local cards = {}
   for k,card in pairs(self.cards) do
      if card.isSelected then
         table.insert(cards, card.card)
      end
   end
   return cards
end
