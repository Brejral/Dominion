local sceneName = "PlayedCardsModal"
local scene = composer.newScene(sceneName)

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

   self.tabs = {}
   local sceneGroup = self.view
   self.params = event.params
   self.width = cardScale.width * 5 + 0.33 * sWidth
   local player = self.params.player
   local numCards = math.max(#player:getCardsPlayedOfType(Action), math.max(#player:getCardsPlayedOfType(Treasure), math.max(#player.setAsideCards, #player.nativeVillageMat)))
   self.height = 0.08 * sHeight + math.max(math.ceil(numCards / 5), 1) * cardScale.height
   self.left = sWidth / 2 - self.width / 2
   self.top = sHeight / 2 - self.height / 2

   local modalLayer = display.newRect(sWidth / 2, sHeight / 2, sWidth, sHeight)
   modalLayer:setFillColor(.5, .5, .5, .5)

   local background = display.newImage(modalBackground)
   background.x = sWidth / 2
   background.y = sHeight / 2
   background.width = self.width
   background.height = self.height

   local function closeButtonHandler(event)
      if event.phase == "ended" then
         composer.hideOverlay(true, "fade")
      end
   end

   self.closeButton = Button:new({
      label = "Close",
      font = buttonFont,
      labelColor = {default = {1, 1, 1}, over = {0, 0, 1}},
      onEvent = closeButtonHandler,
      fontSize = 12,
      x = self.left + self.width - 0.06 * sWidth,
      y = self.top + 0.03 * sHeight
   })

   sceneGroup:insert(modalLayer)
   sceneGroup:insert(background)
   sceneGroup:insert(self.closeButton)
   self:setupTabs()
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
-- Called prior to the removal of scene's view ("sceneGroup").
-- Insert code here to clean up the scene.
-- Example: remove display objects, save state, etc.
end

function scene:setupTabs()
   local player = self.params.player
   self:setupTab("Played Actions", player:getCardsPlayedOfType(Action))
   self:setupTab("Played Treasures", player:getCardsPlayedOfType(Treasure))
   if game.cardSupply:hasType(Duration) then
      self:setupTab("Durations", player.durations)
   end
   if #player.setAsideCards > 0 then
      self:setupTab("Set Aide Cards", player.setAsideCards)
   end
   if game.cardSupply:getCardObj("NativeVillage") then
      self:setupTab("Native Village Mat", player.nativeVillageMat)
   end
   self:setupTabBar()
end

function scene:setupTabBar()
   local tabBar = display:newGroup()
   tabBar.tabs = {}
   local tHeight = self.height / #self.tabs
   for k,tab in pairs(self.tabs) do
      local tabGroup = display.newGroup()
      tabGroup.isSelected = k == 1
      tabGroup.background = display.newRect(self.left + 0.15 * sWidth, self.top + (k - 0.5) * tHeight, 0.3 * sWidth, tHeight)
      tabGroup.background:setFillColor(1, 1, 1, tabGroup.isSelected and 0 or 0.3)
      tabGroup.tabText = display.newText {
         text = tab.name,
         fontSize = 12,
         x = self.left + 0.155 * sWidth,
         y = self.top + (k - 0.5) * tHeight,
         width = 0.29 * sWidth
      }
      local topLine = display.newLine(self.left, self.top + (k - 1) * tHeight, self.left + 0.3 * sWidth, self.top + (k - 1) * tHeight)
      topLine.isVisible = k ~= 1
      tabGroup.rightLine = display.newLine(self.left + 0.3 * sWidth, self.top + (k - 1) * tHeight, self.left + 0.3 * sWidth, self.top + k * tHeight)
      local bottomLine = display.newLine(self.left + 0.3 * sWidth, self.top + k * tHeight, self.left, self.top + k * tHeight)
      bottomLine.isVisible = k ~= #self.tabs
      tabGroup.leftLine = display.newLine(self.left, self.top + k * tHeight, self.left, self.top + (k - 1) * tHeight)
      tabGroup.rightLine.isVisible = not tabGroup.isSelected
      tabGroup.leftLine.isVisible = tabGroup.isSelected
      tabGroup.tabText:setFillColor(k == 1 and 0 or 1, k == 1 and 0 or 1, 1)
      tabGroup:insert(tabGroup.background)
      tabGroup:insert(topLine)
      tabGroup:insert(bottomLine)
      tabGroup:insert(tabGroup.leftLine)
      tabGroup:insert(tabGroup.rightLine)
      tabGroup:insert(tabGroup.tabText)
      local function tabGroupHandler(event)
         if event.phase == "ended" then
            for k,tabG in pairs(tabBar.tabs) do
               tabG.isSelected = tabG == event.target
               tabG.tabViewGroup.isVisible = tabG.isSelected
               tabG.background:setFillColor(1, 1, 1, tabG.isSelected and 0 or 0.3)
               tabG.tabText:setFillColor(tabG.isSelected and 0 or 1, tabG.isSelected and 0 or 1, 1)
               tabG.rightLine.isVisible = not tabG.isSelected
               tabG.leftLine.isVisible = tabG.isSelected
               tabG.background:setFillColor(1, 1, 1, tabG.isSelected and 0 or 0.3)
            end
         end
      end
      tabGroup.tabViewGroup = tab
      tabGroup.tabViewGroup.isVisible = tabGroup.isSelected
      tabGroup:addEventListener("touch", tabGroupHandler)
      table.insert(tabBar.tabs, tabGroup)
      tabBar:insert(tabGroup)
   end
   self.view:insert(tabBar)
end

function scene:setupTab(name, cards)
   local group = display.newGroup()
   group.name = name
   self:setupCards(group, cards)
   table.insert(self.tabs, group)
   self.view:insert(group)
end

function scene:setupCards(group, cards)
   local x = self.left + self.width / 2 - #cards / 2 * cardScale.width + 0.15 * sWidth
   local y = self.top + 0.07 * sHeight + cardScale.height / 2
   group.cards = {}
   for k,card in pairs(cards) do
      local cardImg = display.newImage(card:getImage())
      cardImg.card = card
      cardImg.x = x + ((k % 5)  - 0.5) * cardScale.width
      cardImg.y = y + math.floor(k/5) * cardScale.height
      cardImg:addEventListener("touch", cardTouchListener)
      combine(cardImg, cardScale)
      table.insert(group.cards, cardImg)
      group:insert(cardImg)
   end
   self.view:insert(group)
end

function scene:getSelectedCards()
   local cards = {}
   for k,card in pairs(self.cards) do
      if card.isSelected then
         table.insert(cards, card.card)
      end
   end
   return cards
end

function scene:getOrderedCards()
   local cardImgs = {}
   for k,card in pairs(self.cards) do
      if card.order then
         table.insert(cardImgs, card)
      end
   end
   local function sorter(a, b)
      return a.order < b.order
   end
   table.sort(cardImgs, sorter)
   local cards = {}
   for k,cardImg in pairs(cardImgs) do
      table.insert(cards, cardImg.card)
   end
   return cards
end

function scene:getNextOrderNum()
   local orderNum
   for i=1,#self.cards do
      local orderUsed = false
      for k,card in pairs(self.cards) do
         if card.order and card.order == i then
            orderUsed = true
            break
         end
      end
      if not orderUsed then
         orderNum = i
         break
      end
   end
   return orderNum
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
