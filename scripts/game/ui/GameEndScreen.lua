local sceneName = "GameEndScreen"
local scene = composer.newScene(sceneName)

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view
   local params = event.params

   local background = display.newImage("images/Background/DarkWood.png")
   background.x = sWidth / 2
   background.y = sHeight / 2 - 3
   background.width = sWidth
   background.height = sHeight + 6

   local titleText = display.newText {
      text = "Game Over",
      fontSize = 15,
      font = titleFont,
      x = sWidth / 2,
      y = 0.05 * sHeight
   }

   sceneGroup:insert(background)
   sceneGroup:insert(titleText)
   self:setupPlayerStatTables(params)
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
   -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
   -- Called when the scene is now on screen.
   -- Insert code here to make the scene come alive.
   -- Example: start timers, begin animation, play audio, etc.
   end
end

-- "scene:hide()"
function scene:hide( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
   -- Called when the scene is on screen (but is about to go off screen).
   -- Insert code here to "pause" the scene.
   -- Example: stop timers, stop animation, stop audio, etc.
   elseif ( phase == "did" ) then
   -- Called immediately after scene goes off screen.
   end
end

-- "scene:destroy()"
function scene:destroy( event )

   local sceneGroup = self.view

   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
end

function scene:setupPlayerStatTables(params)
   self.statTitles = {
      "Standing",
      "Points",
      "Turns",
      "Avg Coins Per Treasure",
      "Avg Points Per Victory",
      "Avg Actions Per Turn",
      "Avg Coins Per Turn",
      "Avg Cards Per Turn",
      "Avg Buys Per Turn",
      "Actions Played",
      "Attacks Played",
      "Treasures Played",
      "Most Coins In Turn",
      "Most Actions In Turn",
      "Unspent Coins",
      "Avg Card Cost",
      "# Cards",
      "Treasures",
      "Victories",
      "Curses",
      "Attacks",
      "Actions"
   }
   self.statColumns = {}
   self.playerTexts = {}
   self.statsTable = widget.newScrollView {
      top = 0.12 * sHeight,
      left = 0.04 * sWidth,
      width = 0,
      height = 0.88 * sHeight,
      horizontalScrollDisabled = true,
      isBounceEnabled = false,
      backgroundColor = {1, 1, 1},
      hideBackground = true
   }
   self.view:insert(self.statsTable)
   self:setupPlayerStatColumn()
   for k,player in pairs(params.standings) do
      self:setupPlayerStatColumn(player)
   end
   self.statsTable:scrollToPosition({
      x = -self.statsTable.width / 2 + 1,
      y = 0,
      time = 0
   })
end

function scene:getStats(player)
   local stats = {}
   table.insert(stats, player.place)
   table.insert(stats, player.points)
   table.insert(stats, player.stats.turns)
   table.insert(stats, player.stats.avgCoinsPerTreasure)
   table.insert(stats, player.stats.avgPointsPerVictory)
   table.insert(stats, player.stats.avgActionsPerTurn)
   table.insert(stats, player.stats.avgCoinsPerTurn)
   table.insert(stats, player.stats.avgCardsPerTurn)
   table.insert(stats, player.stats.avgBuysPerTurn)
   table.insert(stats, player.stats.actionsPlayed)
   table.insert(stats, player.stats.attacksPlayed)
   table.insert(stats, player.stats.treasuresPlayed)
   table.insert(stats, player.stats.mostCoinsInTurn)
   table.insert(stats, player.stats.mostActionsInTurn)
   table.insert(stats, player.stats.unspentCoins)
   table.insert(stats, player.stats.avgCardCost)
   table.insert(stats, player.stats.deckSize)
   table.insert(stats, player.stats.treasureCards)
   table.insert(stats, player.stats.victoryCards)
   table.insert(stats, player.stats.curseCards)
   table.insert(stats, player.stats.attackCards)
   table.insert(stats, player.stats.actionCards)
   return stats
end

function scene:setupPlayerStatColumn(player)
   local isHeaderRow = player == nil
   local fontSize = isHeaderRow and 10 or 10
   local stats = player and self:getStats(player) or self.statTitles
   local column = display.newGroup()
   local y = 0
   local width = isHeaderRow and 0.3 * sWidth or 0
   local x = width / 2
   if player then
      local playerText = display.newText {
         text = player.name,
         fontSize = fontSize + 2,
         align = "center"
      }
      playerText.y = 0.12 * sHeight - playerText.height / 2 - 0.01 * sHeight
      width = playerText.width
      playerText.x = 1 + self.statColumns[#self.statColumns].width / 2 + self.statColumns[#self.statColumns][1].x + 0.07 * sWidth + width / 2
      x = playerText.x - 0.04 * sWidth
      self.view:insert(playerText)
      table.insert(self.playerTexts, playerText)
   end
   for k,stat in pairs(stats) do
      local text = display.newText {
         text = stat,
         fontSize = fontSize,
         x = x,
         width = width,
         align = isHeaderRow and "right" or "center"
      }
      text.y = y + (#self.statColumns > 0 and self.statColumns[1][k].height or text.height) / 2
      y = y + (#self.statColumns > 0 and self.statColumns[1][k].height or text.height) + 0.01 * sHeight
      column:insert(text)
   end
   self.statsTable:insert(column)
   self.statsTable.width = self.statsTable.width + column.width + 0.03 * sWidth
   table.insert(self.statColumns, column)
   self.statsTable.x = self.statsTable.width / 2 + 0.04 * sWidth
end
---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
