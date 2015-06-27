-- CardSupply Class
require "scripts.card.victory.Victory"
require "scripts.card.victory.Estate"
require "scripts.card.victory.Duchy"
require "scripts.card.victory.Province"
require "scripts.card.treasure.Copper"
require "scripts.card.treasure.Silver"
require "scripts.card.treasure.Gold"

class.CardSupply()

-- Derived class method new
function CardSupply:__init(params)
   --Properties
   params = params or {}
   self:setupCardSupply(params)
end

function CardSupply:setupCardSupply(params)
   local kingdomCards = params.cardSet.cards
   local additionalCards = params.cardSet.additionalCards
   local paths = params.expansion.paths
   local numVictories = params.numPlayers > 2 and 12 or 8
   local numCurses = params.numPlayers == 2 and 10 or params.numPlayers == 3 and 20 or 30
   self.cardSupply = {}
   self.kingdomCards = {}
   self.supplyCards = {}
   self.embargoTokens = {}
   for k,card in pairs(kingdomCards) do
      require(getRequireString(card, paths))
      self.kingdomCards[card] = eval(card)
      self.cardSupply[card] = self.kingdomCards[card]:is_a(Victory) and numVictories or 10
   end
   self.supplyCards.Copper = Copper
   self.supplyCards.Silver = Silver
   self.supplyCards.Gold = Gold
   self.cardSupply.Copper = 60 - params.numPlayers * 7
   self.cardSupply.Silver = 40
   self.cardSupply.Gold = 30
   self.supplyCards.Estate = Estate
   self.supplyCards.Duchy = Duchy
   self.supplyCards.Province = Province
   self.cardSupply.Estate = numVictories
   self.cardSupply.Duchy = numVictories
   self.cardSupply.Province = numVictories
   if additionalCards ~= nil then
      for k,card in pairs(additionalCards) do
         require(getRequireString(card, paths))
         self.supplyCards[card] = eval(card)
         self.cardSupply[card] = self.supplyCards[card]:is_a(Victory) and numVictories or self.supplyCards[card]:is_a(Curse) and numCurses or 10
      end
   end
end

function CardSupply:getNumberOfCards(card)
   return self.cardSupply[card]
end

function CardSupply:addCardToSupply(cardStr)
   self.cardSupply[cardStr] = self.cardSupply[cardStr] + 1
end

function CardSupply:addCardsToSupply(cardStr, val)
   self.cardSupply[cardStr] = self.cardSupply[cardStr] + val
end

function CardSupply:getCard(cardStr)
   if not cardStr then return nil end
   if type(cardStr) ~= "string" then cardStr = classname(cardStr) end
   if self.cardSupply[cardStr] > 0 then
      self.cardSupply[cardStr] = self.cardSupply[cardStr] - 1
      local card = self.kingdomCards[cardStr]
      if card == nil then
         card = self.supplyCards[cardStr]
      end
      return card()
   end
end

function CardSupply:getCardObj(cardStr)
   local card = self.kingdomCards[cardStr]
   if not card then
      card = self.supplyCards[cardStr]
   end
   return card and card() or nil
end

function CardSupply:getCardsOfCost(cost)
   local cards = {}
   for k,card in pairs(self.kingdomCards) do
      local cardInst = card()
      if cardInst:getCost() == cost then
         table.insert(cards, cardInst)
      end
   end
   return cards
end

function CardSupply:getCardsOfType(type)
   local cards = {}
   for k,card in pairs(self.supplyCards) do
      local cardInst = card()
      if cardInst:is_a(type) then
         table.insert(cards, cardInst)
      end
   end
   if type:is_a(Treasure) then
      local function sorter (a, b)
         return a:getCoins() > b:getCoins()
      end
      table.sort(cards, sorter)
   elseif type:is_a(Victory) then
      local function sorter (a, b)
         return a:getPoints() > b:getPoints()
      end
      table.sort(cards, sorter)
   end
   return cards
end

function CardSupply:addEmbargoToken(cardStr)
   if type(cardStr) ~= "string" then cardStr = classname(cardStr) end
   local tokens = self.embargoTokens[cardStr]
   self.embargoTokens[cardStr] = (tokens or 0) + 1
end

function CardSupply:getNumberOfEmbargoTokens(cardStr)
   if type(cardStr) ~= "string" then cardStr = classname(cardStr) end
   return self.embargoTokens[cardStr] or 0
end

function CardSupply:hasType(type)
   local hasType = false
   for k,card in pairs(self.kingdomCards) do
      if card:is_a(type) then
         hasType = true
         break
      end
   end
   if not hasType then
      for k,card in pairs(self.supplyCards) do
         if card:is_a(type) then
            hasType = true
            break
         end
      end
   end
   return hasType
end
