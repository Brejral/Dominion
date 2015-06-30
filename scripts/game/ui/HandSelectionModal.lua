local sceneName = "HandSelectionModal"
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
   self.params = event.params
   self.width = math.max(cardScale.width * math.min(#self.params.player.hand, 10) + 0.04 * sWidth, 0.35 * sWidth)
   self.height = 0.2 * sHeight + math.ceil(#self.params.player.hand / 10) * cardScale.height
   self.left = sWidth / 2 - self.width / 2

   self.msgText = display.newText {
      text = self.params.msg,
      fontSize = 12,
      x = sWidth / 2,
      width = self.width - 0.04 * sWidth,
   }
   self.height = self.height + self.msgText.height
   self.top = sHeight / 2 - self.height / 2
   self.msgText.y = self.top + 0.09 * sHeight + self.msgText.height / 2

   local modalLayer = display.newRect(sWidth / 2, sHeight / 2, sWidth, sHeight)
   modalLayer:setFillColor(.5, .5, .5, .5)

   local background = display.newImage(modalBackground)
   background.x = sWidth / 2
   background.y = sHeight / 2
   background.width = self.width
   background.height = self.height

   local playerText = display.newText {
      text = self.params.player.name,
      fontSize = 15,
      x = sWidth / 2,
      y = self.top + 0.03 * sHeight,
   }

   local function selectButtonHandler(event)
      if event.phase == "ended" then
         composer.hideOverlay(true, "fade")
      end
   end

   self.selectButton = Button:new({
      label = "Select",
      font = buttonFont,
      labelColor = {default = {1, 1, 1}, over = {0, 0, 1}},
      onEvent = selectButtonHandler,
      fontSize = 12,
      x = self.left + self.width - 0.06 * sWidth,
      y = self.top + self.height - 0.03 * sHeight
   })

   sceneGroup:insert(modalLayer)
   sceneGroup:insert(background)
   sceneGroup:insert(playerText)
   sceneGroup:insert(self.msgText)
   sceneGroup:insert(self.selectButton)
   self:setupCards(self.params.player.hand)

   self:update()
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
   local function delayedFunction()
      self.params.selectedCards = self:getSelectedCards()
      if self.params.isOrdering then
         self.params.orderedCards = self:getOrderedCards()
      end
      self.params.afterSelection(self.params)
   end
   local sceneGroup = self.view
   timer.performWithDelay(100, delayedFunction)
   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
end

function scene:setupCards(cards)
   local x = self.left + self.width / 2 - ((#cards - 1) % 10 + 1) / 2 * cardScale.width
   local y = self.msgText.y + self.msgText.height/2 + 0.05 * sHeight + cardScale.height / 2
   self.cards = {}
   local function touchListener(event)
      if event.phase == "ended" and not event.target.held and event.target.isEnabled then
         event.target.isSelected = not event.target.isSelected
         if self.params.isOrdering then
            if event.target.isSelected then
               local orderNum = self:getNextOrderNum()
               event.target.order = orderNum
               event.target.orderText = display.newText {
                  text = orderNum,
                  fontSize = 40,
                  x = event.target.x,
                  y = event.target.y
               }
               event.target.orderText:setFillColor(1, 1, 1, .6)
               self.view:insert(event.target.orderText)
            else
               event.target.order = nil
               event.target.orderText:removeSelf()
               event.target.orderText = nil
            end
         end
         self:update()
      end
      cardTouchListener(event)
   end
   for k,card in pairs(cards) do
      local cardImg = display.newImage(card:getImage())
      cardImg.card = card
      cardImg.x = x + (((k - 1) % 10 + 1)  - 0.5) * cardScale.width
      cardImg.y = y + math.floor((k - 1)/10) * cardScale.height
      cardImg:addEventListener("touch", touchListener)
      combine(cardImg, cardScale)
      table.insert(self.cards, cardImg)
      self.view:insert(cardImg)
   end
end

function scene:update()
   local params = self.params
   local selectedCards = self:getSelectedCards()
   if (params.min or 0) > #selectedCards then
      self.selectButton:setEnabled(false)
   else
      self.selectButton:setEnabled(true)
   end
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
         if params.isNegative then
            card:setFillColor(1, 0, 0)
         else
            card:setFillColor(0, 1, 0)
         end
      elseif card.isEnabled then
         card:setFillColor(1, 1, 1)
      else
         card:setFillColor(.3)
      end
   end
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
