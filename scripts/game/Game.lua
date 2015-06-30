-- Game Class
require "scripts.player.Player"
require "scripts.game.CardSupply"
require "scripts.game.ui.GameEndScreen"

class.Game()

-- Derived class method new
function Game:__init(params)
   game = self
   --Properties
   params = params or {}
   self.phase = "Action"
   self.cardSupply = CardSupply(params)
   self:setupPlayers(params)
   self.trash = {}
   self.extraTurns = {}
   self.endOfTurnCards = {}
   self.nextStandardTurnPlayer = nil
   self.consecutiveTurns = 0
   self.costDiscount = 0
   self.copperBonus = 0
   self.isExtraTurn = false

   Runtime:addEventListener("actionEnd", self.actionEndListener)
end

-- Derived class methods
function Game:setupPlayers(params)
   self.players = {}
   local num = params.numPlayers
   local playerNames = loadData("playernames.json")
   for i=1,num do
      self.players[i] = Player({name= playerNames[i]})
   end
   shuffle(self.players)

   self.players[1]:startTurn()
end

function Game:getCurrentPlayerForTurn()
   for k,v in pairs(self.players) do
      if v.isTurn then
         return v
      end
   end
end

function Game:getCurrentPlayerForAttack()
   for k,v in pairs(self.players) do
      if v.isAttackTurn then
         return v
      end
   end
   return nil
end

function Game:nextPlayer(player)
   local player = player or self:getCurrentPlayerForTurn()
   local index = indexOf(self.players, player)
   if (index == #self.players) then
      return self.players[1]
   end
   return self.players[index + 1]
end

function Game:endGame()
   for k,player in pairs(self.players) do
      player:setupForEndGame()
   end
   local options = {
      effect = "fade",
      time = 200,
      params = {
         standings = self:getStandings()
      }
   }
   composer.gotoScene("GameEndScreen", options)
end

function Game:checkForEndOfGame()
   local cardSupply = game.cardSupply.cardSupply
   local emptyPiles = 0
   for k,v in pairs(cardSupply) do
      if v == 0 then
         emptyPiles = emptyPiles + 1
      end
   end
   if cardSupply.Province == 0 or emptyPiles >= 3 then
      self:endGame()
   end
end

function Game:nextPhase()
   if self.phase == "Action" then
      self.phase = "Buy"
   elseif self.phase == "Buy" then
      self.phase = "Action"
      self:cleanupPhase()
   end
   gameScreen:update()
end

function Game:cleanupPhase()
   local player = self:getCurrentPlayerForTurn()
   for k,card in pairs(player.playedCards) do
      if card.onDiscardFromPlay then
         table.insert(player.discardFromPlayCards, card)
      end
      if card.onEndOfTurn then
         table.insert(player.endOfTurnCards, card)
      end
   end
   player:checkForDiscardFromPlayCards()
end

function Game:nextTurn()
   local player = self:getCurrentPlayerForTurn()
   local nextPlayer = self:getNextPlayer(player)
   self.costDiscount = 0
   self.copperBonus = 0
   player:endTurn()
   self:checkForEndOfGame()
   if #self.extraTurns > 0 then
      print("ExtraTurn")
      self.nextStandardTurnPlayer = nextPlayer
      self.isExtraTurn = true
      local extraTurn = table.remove(self.extraTurns)
      if extraTurn.isPossession then extraTurn.player:setPossessor(extraTurn.possessor) end
      self.consecutiveTurns = extraTurn.player == player and self.consecutiveTurns + 1 or 1
      extraTurn.player:startTurn()
   else
      self.isExtraTurn = false
      nextPlayer = self.nextStandardTurnPlayer or nextPlayer
      self.consecutiveTurns = nextPlayer == player and self.consecutiveTurns + 1 or 1
      nextPlayer:startTurn()
   end
   gameScreen:update()
end

function Game:checkForEndOfTurnCards()
   local player = game:getCurrentPlayerForTurn()
   if #player.endOfTurnCards > 0 then
      table.remove(player.endOfTurnCards):onEndOfTurn(player)
   else
      self:nextTurn()
   end
end

function Game:nextAttackTurn()
   local player = table.remove(self.attackedPlayers, 1)
   player.isAttackTurn = false
   if #self.attackedPlayers > 0 then
      local nextPlayer = self.attackedPlayers[1]
      nextPlayer.isAttackTurn = true
      self.reactions = nextPlayer:getReactions("Attack")
      self.performAttack = true
      self:specialAttackChecks()
      self:performAttackChecks()
      gameScreen:update()
   else
      local attack = self.attack
      self.attack = nil
      self.attackedPlayers = nil
      self.reactions = nil
      self.performAttack = nil
      attack:endAction()
   end
end

function Game:isAttackTurn()
   for k,player in pairs(self.players) do
      if player.isAttackTurn then
         return true
      end
   end
   return false
end

function Game:getNextPlayer(player)
   local index = 0
   for k,v in pairs(self.players) do
      if player == v then
         index = k
         break
      end
   end
   if index == #self.players then
      return self.players[1]
   end
   return self.players[index + 1]
end

function Game:getPrevPlayer(player)
   local index = 0
   for k,v in pairs(self.players) do
      if player == v then
         index = k
         break
      end
   end
   if index == 1 then
      return self.players[#self.players]
   end
   return self.players[index - 1]
end

function Game.actionEndListener(event)
   local player = game:getCurrentPlayerForTurn()
   gameScreen:update()
   if player.actions == 0 or not player:hasTypeInHand(Action) then
      game:nextPhase()
   end
end

function Game:setupAttackAction(attack)
   self.attack = attack
   self.attackedPlayers = {}
   local player = self:getCurrentPlayerForTurn()
   local nextPlayer = self:nextPlayer(player)
   nextPlayer.isAttackTurn = true
   self.performAttack = true
   self.reactions = nextPlayer:getReactions("Attack")
   while nextPlayer ~= player do
      table.insert(self.attackedPlayers, nextPlayer)
      nextPlayer = self:nextPlayer(nextPlayer)
   end
   self:specialAttackChecks()
   self:performAttackChecks()
end

function Game:specialAttackChecks()
   local player = game:getCurrentPlayerForAttack()
   for k,card in pairs(player.playedCards) do
      if card:is_a(Lighthouse) then
         self.performAttack = false
      end
   end
   for k,card in pairs(player.durations) do
      if card:is_a(Lighthouse) then
         self.performAttack = false
      end
   end
end

function Game:performAttackChecks()
   if self.reactions and #self.reactions > 0 then
      table.remove(self.reactions, 1):performReaction()
   elseif self.performAttack then
      self.attack:performAttack(self.attackedPlayers[1])
   else
      self:nextAttackTurn()
   end
end

function Game:setupForEachPlayerAction(action)
   self.eachPlayerAction = action
   self.eachPlayerActionList = {}
   local player = self:getCurrentPlayerForTurn()
   table.insert(self.eachPlayerActionList, player)
   local nextPlayer = self:getNextPlayer(player)
   while nextPlayer ~= player do
      table.insert(self.eachPlayerActionList, nextPlayer)
      nextPlayer = self:nextPlayer(nextPlayer)
   end
   self:performEachPlayerAction()
end

function Game:performEachPlayerAction()
   if #self.eachPlayerActionList > 0 then
      self.eachPlayerAction:performEachPlayerAction(table.remove(self.eachPlayerActionList, 1))
   else
      self.eachPlayerAction:endAction()
      self.eachPlayerAction = nil
      gameScreen:update()
   end
end

function Game:getStandings()
   local function sorterFunc(a, b)
      if a.points == b.points then
         return a.stats.turns < b.stats.turns
      end
      return a.points > b.points
   end
   local standings = {}
   for k,player in pairs(self.players) do
      table.insert(standings, player)
   end
   table.sort(standings, sorterFunc)
   local place = 1
   for k,player in pairs(standings) do
      player.place = ""
      local compPlayer = nil
      if k == 1 then
         compPlayer = standings[k + 1]
      else
         compPlayer = standings[k - 1]
      end
      if compPlayer.points == player.points and compPlayer.stats.turns == player.stats.turns then
         player.place = player.place .. place .. "(T)"
      else
         player.place = player.place .. place
         place = place + 1
      end
   end
   return standings
end

function Game:addExtraTurn(extraTurn)
   table.insert(self.extraTurns, extraTurn)
end

function Game:hasExtraPossessedTurnForPlayer(player)
   local nextExtraTurn = self.extraTurns[#self.extraTurns]
   return nextExtraTurn.player == player and nextExtraTurn.isPossession
end
