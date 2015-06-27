-- Player class
require "scripts.card.victory.Estate"
require "scripts.card.treasure.Copper"

class.Player()

function Player:__init(params)
   -- Properties
   params = params or {}
   self.points = 0
   self.name = params.name or ""
   self.actions = 0
   self.buys = 0
   self.coins = 0
   self.coinTokens = 0
   self.potions = 0
   self:setStartingDeck()
   self.discardPile = {}
   self.hand = {}
   self.playedCards = {}
   self.durations = {}
   self.setAsideCards = {}
   self.nativeVillageMat = {}
   self.cardsGainedThisTurn = {}
   self.cardsBoughtThisTurn = {}
   self.discardFromPlayCards = {}
   self.isTurn = false
   self.isAction = false
   self.isAttackTurn = false
   self:setupStats()

   self:drawNewHand()
end

function Player:setStartingDeck()
   self.deck = {}
   for i=1,10 do
      if i < 8 then
         table.insert(self.deck, Copper())
      else
         table.insert(self.deck, Estate())
      end
   end
   self:shuffleDeck()
end

function Player:shuffleDeck()
   shuffle(self.deck)
end

function Player:drawCard()
   self:checkForDeckResupply()
   if #self.deck > 0 then
      table.insert(self.hand, table.remove(self.deck))
      self.stats.totalCards = self.stats.totalCards + 1
   end
end

function Player:checkForDeckResupply()
   if #self.deck == 0 then
      while #self.discardPile > 0 do
         table.insert(self.deck, table.remove(self.discardPile))
      end
      self:shuffleDeck()
      return true
   end
end

function Player:drawCards(numCards)
   if numCards and numCards > 0 then
      for i=1,numCards do
         self:drawCard()
      end
   end
end

function Player:gainCard(card)
   if card then
      table.insert(self.cardsGainedThisTurn, card)
      table.insert(self.discardPile, card)
   end
end

function Player:gainCardFromSupply(card)
   self:gainCard(game.cardSupply:getCard(card))
end

function Player:addCardToHand(card)
   if card then
      table.insert(self.hand, card)
   end
end

function Player:addCardToHandFromSupply(card)
   self:addCardToHand(game.cardSupply:getCard(card))
end

function Player:addCardToHandFromSupply(card)
   self:addCardToHand(game.cardSupply:getCard(card))
end

function Player:discardCards(cards)
   for k,card in pairs(cards) do
      self:discardCard(card)
   end
end

function Player:discardCard(card)
   if card then
      if contains(self.hand, card) then
         removeFromTable(self.hand, card)
      elseif contains(self.deck, card) then
         removeFromTable(self.deck, card)
      end
      table.insert(self.discardPile, card)
   end
end

function Player:discardHand()
   while #self.hand > 0 do
      table.insert(self.discardPile, table.remove(self.hand))
   end
end

function Player:drawNewHand()
   self:discardHand()
   self:drawCards(game.outpostPlayed and not game.secondOutpostTurn and 3 or 5)
end

function Player:addActions(actions)
   self.actions = self.actions + actions
end

function Player:addBuys(buys)
   self.buys = self.buys + buys
end

function Player:addCoins(coins)
   self.coins = self.coins + coins
   self.stats.totalCoins = self.stats.totalCoins + coins
   if self.coins > self.stats.mostCoinsInTurn then
      self.stats.mostCoinsInTurn = self.coins
   end
end

function Player:addPoints(points)
   self.points = self.points + points
end

function Player:trashCard(card)
   if card then
      if contains(self.hand, card) then
         table.remove(self.hand, indexOf(self.hand, card))
      elseif contains(self.playedCards, card) then
         table.remove(self.playedCards, indexOf(self.playedCards, card))
      elseif contains(self.deck, card) then
         table.remove(self.deck, indexOf(self.deck, card))
      elseif contains(self.discardPile, card) then
         table.remove(self.discardPile, indexOf(self.discardPile, card))
      end
      table.insert(game.trash, card)
   end
end

function Player:trashCards(cards)
   for k,card in pairs(cards) do
      self:trashCard(card)
   end
end

function Player:startTurn()
   self.isTurn = true
   self.stats.turns = self.stats.turns + 1
   self.actions = 1
   self.buys = 1
   self.cardsGainedThisTurn = {}
   self.cardsBoughtThisTurn = {}
   for k,card in pairs(self.durations) do
      card:performDuration()
   end
   local hasAction = false
   for k,card in pairs(self.hand) do
      if card:is_a(Action) then
         hasAction = true
         break
      end
   end
   if not hasAction then
      game:nextPhase()
   end
end

function Player:endTurn()
   self:cleanupPhase()
   self.isTurn = false
end

function Player:cleanupPhase()
   while #self.durations > 0 do
      table.insert(self.discardPile, table.remove(self.durations))
   end
   local actionsPlayed = 0
   for k,card in pairs(self.playedCards) do
      if card:is_a(Action) then
         actionsPlayed = actionsPlayed + 1
      end
   end
   self.stats.unspentCoins = self.stats.unspentCoins + self.coins
   for k,card in pairs(self.hand) do
      if card:is_a(Treasure) then
         self.stats.unspentCoins = self.stats.unspentCoins + card:getCoins()
      end
   end
   if actionsPlayed > self.stats.mostActionsInTurn then
      self.stats.mostActionsInTurn = actionsPlayed
   end
   while #self.playedCards > 0 do
      local card = table.remove(self.playedCards)
      if card:is_a(Duration) then
         table.insert(self.durations, card)
      else

         table.insert(self.discardPile, card)
      end
   end
   self:drawNewHand()
   self.actions = 0
   self.buys = 0
   self.coins = 0
   self.potions = 0
end

function Player:checkForDiscardFromPlayCards()
   if #self.discardFromPlayCards > 0 then
      local card = table.remove(self.discardFromPlayCards)
      card:onDiscardFromPlay(self)
   else
      game:nextTurn()
   end
end

function Player:playCard(card)
   table.insert(self.playedCards, table.remove(self.hand, indexOf(self.hand, card)))
   if card:is_a(Treasure) then
      local coins = card:getCoins() + (card:is_a(Copper) and game.copperBonus or 0)
      self.coins = self.coins + coins
      if card:is_a(Potion) then
         self.potions = self.potions + 1
      end
      self.stats.totalCoins = self.stats.totalCoins + coins
      self.stats.treasuresPlayed = self.stats.treasuresPlayed + 1
      if self.coins > self.stats.mostCoinsInTurn then
         self.stats.mostCoinsInTurn = self.coins
      end
   elseif card:is_a(Action) then
      card:playAction()
      self.stats.actionsPlayed = self.stats.actionsPlayed + 1
      if card:is_a(Attack) then
         self.stats.attacksPlayed = self.stats.attacksPlayed + 1
      end
   end
end

function Player:getNumOfTypePlayed(type)
   local numPlayed = 0
   for k,card in pairs(self.playedCards) do
      if card:is_a(type) then
         numPlayed = numPlayed + 1
      end
   end
   return numPlayed
end

function Player:getCardsPlayedOfType(type)
   local cards = {}
   for k,card in pairs(self.playedCards) do
      if card:is_a(type) then
         table.insert(cards, card)
      end
   end
   return cards
end

function Player:buyCard(card)
   local embargoTokens = game.cardSupply:getNumberOfEmbargoTokens(classname(card))
   if embargoTokens > 0 then
      for i=1,embargoTokens do
         self:gainCardFromSupply("Curse")
      end
   end
   self.buys = self.buys - 1
   self.coins = self.coins - card:getCost()
   if card:costsPotion() then
      self.potions = self.potions - 1
   end
   self.stats.totalBuys = self.stats.totalBuys + 1
   table.insert(self.cardsBoughtThisTurn, card)
   self:gainCardFromSupply(card)
   if self.buys == 0 then
      game:nextPhase()
   end
end

function Player:hasTypeInHand(type)
   for k,card in pairs(self.hand) do
      if card:is_a(type) then
         return true
      end
   end
   return false
end

function Player:getReactions(reaction)
   local cards = {}
   for k,card in pairs(self.hand) do
      if card:is_a(Reaction) and card:getReactionType() == reaction then
         table.insert(cards, card)
      end
   end
   return cards
end

function Player:setupForEndGame()
   while #self.discardPile > 0 do
      table.insert(self.deck, table.remove(self.discardPile))
   end
   while #self.hand > 0 do
      table.insert(self.deck, table.remove(self.hand))
   end
   while #self.playedCards > 0 do
      table.insert(self.deck, table.remove(self.playedCards))
   end
   while #self.durations > 0 do
      table.insert(self.deck, table.remove(self.durations))
   end
   while #self.setAsideCards > 0 do
      table.insert(self.deck, table.remove(self.setAsideCards))
   end
   while #self.nativeVillageMat > 0 do
      table.insert(self.deck, table.remove(self.nativeVillageMat))
   end
   for k,card in pairs(self.deck) do
      if card:is_a(Victory) or card:is_a(Curse) then
         self.points = self.points + card:getPoints(self)
      end
   end
   self:setEndGameStats()
end

function Player:getPoints()
   local points = 0
   for k,card in pairs(self:getAllCards()) do
      if card:is_a(Victory) or card:is_a(Curse) then
         points = points + card:getPoints(self)
      end
   end
   return points
end

function Player:setupStats()
   self.stats = {}
   self.stats.turns = 0
   self.stats.treasuresPlayed = 0
   self.stats.actionsPlayed = 0
   self.stats.attacksPlayed = 0
   self.stats.totalCoins = 0
   self.stats.totalBuys = 0
   self.stats.totalCards = 0
   self.stats.unspentCoins = 0
   self.stats.mostCoinsInTurn = 0
   self.stats.mostActionsInTurn = 0
end

function Player:setEndGameStats()
   self.stats.deckSize = #self.deck
   self.stats.treasureCards = 0
   self.stats.totalTreasureCoins = 0
   self.stats.totalVictoryPoints = 0
   self.stats.victoryCards = 0
   self.stats.actionCards = 0
   self.stats.attackCards = 0
   self.stats.curseCards = 0
   self.stats.totalCardCost = 0
   for k,card in pairs(self.deck) do
      if card:is_a(Treasure) then
         self.stats.treasureCards = self.stats.treasureCards + 1
         self.stats.totalTreasureCoins = self.stats.totalTreasureCoins + card:getCoins()
      elseif card:is_a(Attack) then
         self.stats.attackCards = self.stats.attackCards + 1
         self.stats.actionCards = self.stats.actionCards + 1
      elseif card:is_a(Action) then
         self.stats.actionCards = self.stats.actionCards + 1
      elseif card:is_a(Victory) then
         self.stats.victoryCards = self.stats.victoryCards + 1
         self.stats.totalVictoryPoints = self.stats.totalVictoryPoints + card:getPoints(self)
      elseif card:is_a(Curse) then
         self.stats.curseCards = self.stats.curseCards + 1
      end
      self.stats.totalCardCost = self.stats.totalCardCost + card:getCost()
   end
   self.stats.avgCardCost = string.format("%.2f", self.stats.totalCardCost / self.stats.deckSize)
   self.stats.avgCoinsPerTreasure = string.format("%.2f", self.stats.totalTreasureCoins / self.stats.treasureCards)
   self.stats.avgCoinsPerTurn = string.format("%.2f", self.stats.totalCoins / self.stats.turns)
   self.stats.avgPointsPerVictory = string.format("%.2f", self.stats.totalVictoryPoints / self.stats.victoryCards)
   self.stats.avgActionsPerTurn = string.format("%.2f", self.stats.actionsPlayed / self.stats.turns)
   self.stats.avgCoinsPerTurn = string.format("%.2f", self.stats.totalCoins / self.stats.turns)
   self.stats.avgCardsPerTurn = string.format("%.2f", self.stats.totalCards / self.stats.turns)
   self.stats.avgBuysPerTurn = string.format("%.2f", self.stats.totalBuys / self.stats.turns)
end

function Player:getBuys()
   return self.buys
end

function Player:getActions()
   return self.actions
end

function Player:getCoins()
   return self.coins
end

function Player:getCoinTokens()
   return self.coinTokens
end

function Player:addCoinToken()
   self.coinTokens = self.coinTokens + 1
end

function Player:getPotions()
   return self.potions
end

function Player:getAllCards()
   local allCards = {}
   for k,card in pairs(self.hand) do
      table.insert(allCards, card)
   end
   for k,card in pairs(self.deck) do
      table.insert(allCards, card)
   end
   for k,card in pairs(self.discardPile) do
      table.insert(allCards, card)
   end
   for k,card in pairs(self.playedCards) do
      table.insert(allCards, card)
   end
   for k,card in pairs(self.durations) do
      table.insert(allCards, card)
   end
   for k,card in pairs(self.setAsideCards) do
      table.insert(allCards, card)
   end
   for k,card in pairs(self.nativeVillageMat) do
      table.insert(allCards, card)
   end
   return allCards
end

function Player:addToDeck(card, index)
   if card then
      if index then
         table.insert(self.deck, index, card)
      else
         table.insert(self.deck, card)
      end
   end
end
