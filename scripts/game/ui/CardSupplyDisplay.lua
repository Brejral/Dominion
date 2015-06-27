-- CardSupplyDisplay Class
require "scripts.card.treasure.Treasure"
require "scripts.card.victory.Victory"
require "scripts.card.victory.Curse"
CardSupplyDisplay = display.newGroup()
CardSupplyDisplay_mt = { __index = CardSupplyDisplay }

-- Derived class method new
function CardSupplyDisplay:new(params)
   local self = display.newGroup()
   setmetatable(self, CardSupplyDisplay_mt)

   --Properties
   self.cards = {}
   self.tableCount = 0
   self:setupCards()

   self:update()

   return self
end

function CardSupplyDisplay:setupCards()
   local supply = game.cardSupply
   for i=2,8 do
      local cards = supply:getCardsOfCost(i)
      if #cards > 4 then
         local cards1 = {}
         local cards2 = {}
         for k,card in pairs(cards) do
            if k <= math.floor(#cards / 2) then
               table.insert(cards1, card)
            else
               table.insert(cards2, card)
            end
         end
         self:addTable(cards1)
         self:addTable(cards2)
      elseif #cards > 0 then
         self:addTable(cards)
      end
   end
   self:addTable(supply:getCardsOfType(Treasure))
   self:addTable(supply:getCardsOfType(Victory))
   self:addTable(supply:getCardsOfType(Curse))
end

function CardSupplyDisplay:addTable(cards)
   local cScale = {}
   cScale.width = cardScale.width
   cScale.height = cardScale.height
   while cScale.height * #cards > 0.76 * sHeight do
      cScale.height = cScale.height - 0.01 * sHeight
   end
   cScale.width = cScale.height / card_ar
   local x = (#self.cards > 0 and self.cards[#self.cards].x + self.cards[#self.cards].width / 2 or 0) + cScale.width / 2 --+ 2 * self.tableCount
   local y = 0.4 * sHeight - (#cards / 2 - 0.5) * cScale.height
   for k,card in pairs(cards) do
      local cardImage = display.newImage(card:getImage())
      combine(cardImage, cScale)
      cardImage.x = x
      cardImage.y = y + cardImage.height * (k - 1) --+ 2
      cardImage.card = card
      cardImage:addEventListener("touch", supplyTouchListener)
      cardImage.numText = display.newText {
         text = "",
         x = cardImage.x + 0.3 * cardImage.width,
         y = cardImage.y + 0.4 * cardImage.height,
         fontSize = 0.2 * cardImage.height
      }
      cardImage.embargoTokenGroup = display.newGroup()
      local tokenImg = display.newImage("images/Token/EmbargoToken.png")
      tokenImg.x = cardImage.x - 0.35 * cardImage.width
      tokenImg.y = cardImage.y - 0.29 * cardImage.height
      tokenImg.width = 0.2 * cardImage.width
      tokenImg.height = tokenImg.width
      cardImage.embargoTokenGroup.tokenImg = tokenImg
      cardImage.embargoTokenGroup:insert(tokenImg)
      local tokenNumText = display.newText {
         text = "x"..game.cardSupply:getNumberOfEmbargoTokens(classname(card)),
         x = tokenImg.x + tokenImg.width / 2 + 0.01 * cardImage.width + 0.3 * cardImage.width/2,
         y = tokenImg.y,
         width = 0.3 * cardImage.width,
         fontSize = 0.1 * cardImage.height,
         align = "left"
      }
      tokenNumText:setFillColor(1, 0, 0)
      cardImage.embargoTokenGroup.numText = tokenNumText
      cardImage.embargoTokenGroup:insert(tokenNumText)
      cardImage.embargoTokenGroup.isVisible = false
      cardImage.numText:setFillColor(1, 0, 0)
      table.insert(self.cards, cardImage)
      self:insert(cardImage)
      self:insert(cardImage.numText)
      self:insert(cardImage.embargoTokenGroup)
   end
   self.tableCount = self.tableCount + 1
end

function CardSupplyDisplay:update()
   if self.isSelection then
      self:updateForSelection()
   else
      local player = game:getCurrentPlayerForTurn()
      for k,card in pairs(self.cards) do
         card.numText.text = game.cardSupply:getNumberOfCards(classname(card.card))
         local embargoTokens = game.cardSupply:getNumberOfEmbargoTokens(classname(card.card))
         if embargoTokens > 0 then
            card.embargoTokenGroup.isVisible = true
            card.embargoTokenGroup.numText.text = "x"..embargoTokens
         end
         card.isEnabled = game.phase == "Buy" and player:getBuys() > 0 and card.card:costLessThan(player:getCoins(), player:getPotions() > 0) and
            game.cardSupply:getNumberOfCards(classname(card.card)) > 0
         if card.isEnabled then
            card:setFillColor(1)
         else
            card:setFillColor(.3)
         end
      end
   end
end

function CardSupplyDisplay:setupForDefault()
   self.isSelection = false
   self.selectionParams = nil
   for k,card in pairs(self.cards) do
      card.isSelected = false
      card:removeEventListener("touch", selectionTouchListener)
      card:removeEventListener("touch", supplyTouchListener)
      card:addEventListener("touch", supplyTouchListener)
   end
   self:update()
end

function CardSupplyDisplay:setupForSelection(params)
   self.isSelection = true
   self.selectionParams = params or {}
   self.selectionParams.min = params.min == nil and 1 or params.min
   self:updateForSelection()
   for k,card in pairs(self.cards) do
      card:removeEventListener("touch", supplyTouchListener)
      card:addEventListener("touch", selectionTouchListener)
   end
end

function CardSupplyDisplay:updateForSelection()
   local params = self.selectionParams
   local selectedCards = self:getSelectedCards()
   for k,card in pairs(self.cards) do
      card.isEnabled = game.cardSupply:getNumberOfCards(classname(card.card)) > 0
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
      if params.maxCost then
         card.isEnabled = card.isEnabled and card.card:costLessThan(params.maxCost, params.maxPotion)
      end
      if params.minCost then
         card.isEnabled = card.isEnabled and card.card:costGreaterThan(params.minCost, params.minPotion)
      end
      if #selectedCards == 1 then
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
   if (self:getNumEnabledCards() == 0) then
      self.selectionParams.min = 0
   end
end

function CardSupplyDisplay:getSelectedCards()
   local cards = {}
   for k,card in pairs(self.cards) do
      if card.isSelected then
         table.insert(cards, card.card)
      end
   end
   return cards
end

function CardSupplyDisplay:getNumEnabledCards()
   local numEnabled = 0
   for k,card in pairs(self.cards) do
      if card.isEnabled then
         numEnabled = numEnabled + 1
      end
   end
   return numEnabled
end
