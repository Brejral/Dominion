-- GameInfoDisplay Class
require "scripts.card.treasure.Treasure"
require "scripts.card.victory.Victory"
require "scripts.game.ui.PlayedCardsModal"
GameInfoDisplay = display.newGroup()
GameInfoDisplay_mt = { __index = GameInfoDisplay }

-- Derived class method new
function GameInfoDisplay:new(params)
   local self = display.newGroup()
   setmetatable(self, GameInfoDisplay_mt)

   --Properties
   self:setupInfo()

   self:update()

   return self
end

function GameInfoDisplay:setupInfo()
   local y = 0.03 * sHeight

   self.playerTables = {}
   for k,player in pairs(game.players) do
      if k ~= 1 then
         y = y + 0.15 * sHeight
      end
      local playerTable = display.newGroup()
      playerTable.playerText = display.newText {
         text = player.name,
         fontSize = 12,
         width = 0.2 * sWidth,
         x = 0.9 * sWidth,
         y = y,
         align = "center"
      }
      playerTable:insert(playerTable.playerText)
      playerTable.actionsText = display.newText {
         text = "Actions: " .. player:getActions(),
         fontSize = 8,
         width = 0.1 * sWidth,
         x = 0.85 * sWidth,
         y = y + 0.04 * sHeight,
         align = "right"
      }
      playerTable:insert(playerTable.actionsText)
      playerTable.buysText = display.newText {
         text = "Buys: " .. player:getBuys(),
         fontSize = 8,
         width = 0.1 * sWidth,
         x = 0.85 * sWidth,
         y = y + 0.07 *sHeight,
         align = "right"
      }
      playerTable:insert(playerTable.buysText)
      playerTable.coinsText = display.newText {
         text = "Coins: " .. player:getCoins(),
         fontSize = 8,
         width = 0.1 * sWidth,
         x = 0.94 * sWidth,
         y = y + 0.04 * sHeight,
         align = "right"
      }
      playerTable:insert(playerTable.coinsText)
      playerTable.pointsText = display.newText {
         text = "Points: " .. player:getPoints(),
         fontSize = 8,
         width = 0.1 * sWidth,
         x = 0.94 * sWidth,
         y = y + 0.07 * sHeight,
         align = "right"
      }
      playerTable:insert(playerTable.pointsText)
      self:insert(playerTable)
      table.insert(self.playerTables, playerTable)
   end
   local function endButtonHandler(event)
      if event.phase == "ended" then
         if gameScreen.playerHandDisplay.isSelection then
            local cards = gameScreen.playerHandDisplay:getSelectedCards()
            local card = gameScreen.playerHandDisplay.selectionParams.card
            gameScreen:setupForDefault()
            card:handleHandSelection(cards)
         elseif gameScreen.cardSupplyDisplay.isSelection then
            local cards = gameScreen.cardSupplyDisplay:getSelectedCards()
            local card = gameScreen.cardSupplyDisplay.selectionParams.card
            gameScreen:setupForDefault()
            card:handleSupplySelection(cards)
         else
            game:nextPhase()
         end
         gameScreen:update()
      end
   end
   self.endButton = Button:new({
      label = "End Actions",
      labelColor = { default = {1, 1, 1}, over = {0, 0, 1} },
      font = buttonFont,
      fontSize = 10,
      x = 0.9 * sWidth,
      y = y + 0.2 * sHeight,
      onEvent = endButtonHandler
   })
   self:insert(self.endButton)

   local function playedCardsButtonHandler(event)
      if event.phase == "ended" then
         local options = {}
         combine(options, modalOptions)
         options.params = {
            player = game:getCurrentPlayerForTurn()
         }
         composer.showOverlay("PlayedCardsModal", options)
      end
   end
   self.playedCardsButton = Button:new({
      label = "Played Cards",
      labelColor = {default = {1, 1, 1}, over = {0, 0, 1}},
      font = buttonFont,
      fontSize = 10,
      x = 0.9 * sWidth,
      y = y + 0.3 * sHeight,
      onEvent = playedCardsButtonHandler
   })
   self:insert(self.playedCardsButton)

   local line1 = display.newLine(0.8 * sWidth - 3, 0, 0.8 * sWidth - 3, 0.8 * sHeight - 10)
   local line2 = display.newLine(0.8 * sWidth - 3, 0.8 * sHeight - 10, sWidth, 0.8 * sHeight - 10)

   self:insert(line1)
   self:insert(line2)
end

function GameInfoDisplay:update()
   for k,player in pairs(game.players) do
      local playerTable = self.playerTables[k]
      if player.isTurn then
         playerTable.playerText:setFillColor(1, 1, 0)
         playerTable.actionsText:setFillColor(1, 1, 0)
         playerTable.buysText:setFillColor(1, 1, 0)
         playerTable.coinsText:setFillColor(1, 1, 0)
         playerTable.pointsText:setFillColor(1, 1, 0)
      elseif player.isAttackTurn then
         playerTable.playerText:setFillColor(1, 0, 0)
         playerTable.actionsText:setFillColor(1, 0, 0)
         playerTable.buysText:setFillColor(1, 0, 0)
         playerTable.coinsText:setFillColor(1, 0, 0)
         playerTable.pointsText:setFillColor(1, 0, 0)
      else
         playerTable.playerText:setFillColor(1, 1, 1)
         playerTable.actionsText:setFillColor(1, 1, 1)
         playerTable.buysText:setFillColor(1, 1, 1)
         playerTable.coinsText:setFillColor(1, 1, 1)
         playerTable.pointsText:setFillColor(1, 1, 1)
      end
      playerTable.playerText.text = player.name .. (player:isPossessed() and "(Possessed)" or "")
      playerTable.actionsText.text = "Actions: " .. player:getActions()
      playerTable.buysText.text = "Buys: " .. player:getBuys()
      playerTable.coinsText.text = "Coins: " .. player:getCoins()
      playerTable.pointsText.text = "Points: ".. player:getPoints()
   end
   local isDisabled = (gameScreen.playerHandDisplay.isSelection and
      #gameScreen.playerHandDisplay:getSelectedCards() < (gameScreen.playerHandDisplay.selectionParams.min or 0)) or
      (gameScreen.cardSupplyDisplay.isSelection and
      #gameScreen.cardSupplyDisplay:getSelectedCards() < (gameScreen.cardSupplyDisplay.selectionParams.min or 0))
   self.endButton:setEnabled(not isDisabled)
   self.endButton:setLabel((gameScreen.playerHandDisplay.isSelection or gameScreen.cardSupplyDisplay.isSelection) and "Select" or
      game.phase == "Action" and "End Actions" or
      "End Turn")
end
