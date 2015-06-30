local sceneName = "ChoiceModal"
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
   self.params.numSelections = self.params.numSelections or 1
   local isButtonSelectionMode = self.params.numSelections > 1
   self.width = math.max(cardScale.width * math.min(#self.params.cards, 10) + 0.04 * sWidth, 0.35 * sWidth)
   self.height = 0.2 * sHeight + math.ceil(#self.params.cards / 10) * cardScale.height
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

   local titleText = display.newText {
      text = self.params.title,
      fontSize = 15,
      x = sWidth / 2,
      y = self.top + 0.03 * sHeight,
   }

   self.buttons = {}
   for k,choice in pairs(self.params.choices) do
      local function buttonHandler(event)
         if event.phase == "ended" then
            if self.params.numSelections > 1 then
               self.params.selections = {}
               for k,button in pairs(self.buttons) do
                  if button.isSelected then
                     table.insert(self.params.selections, button.label.text)
                  end
               end
            else
               self.params.selection = event.target.label.text
            end
            if self.params.numSelections == 1 or #self.params.selections == self.params.numSelections then
               composer.hideOverlay(true, "fade")
            end
         end
      end
      local button = Button:new({
         label = choice,
         font = buttonFont,
         labelColor = {default = {1, 1, 1}, over = {0, 0, 1}},
         onEvent = buttonHandler,
         fontSize = 12,
         isSelectionMode = isButtonSelectionMode,
         y = self.top + self.height - 0.03 * sHeight
      })
      local lastButton = #self.buttons > 0 and self.buttons[#self.buttons] or nil
      button:setX((lastButton and lastButton.x - lastButton.width / 2 or self.left + self.width) - 0.02 * sWidth - button.width / 2)
      table.insert(self.buttons, button)
   end

   sceneGroup:insert(modalLayer)
   sceneGroup:insert(background)
   sceneGroup:insert(titleText)
   sceneGroup:insert(self.msgText)
   for k,button in pairs(self.buttons) do
      sceneGroup:insert(button)
   end
   self:setupCards(self.params.cards)

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
   for k,card in pairs(cards) do
      local cardImg = display.newImage(card:getImage())
      cardImg.card = card
      cardImg.x = x + (((k - 1) % 10 + 1)  - 0.5) * cardScale.width
      cardImg.y = y + math.floor((k - 1)/10) * cardScale.height
      cardImg:addEventListener("touch", cardTouchListener)
      combine(cardImg, cardScale)
      table.insert(self.cards, cardImg)
      self.view:insert(cardImg)
   end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
