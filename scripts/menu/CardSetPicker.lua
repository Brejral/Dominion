local sceneName = "CardSetPicker"
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
   self.menu = self.params.menu

   local modalLayer = display.newRect(sWidth / 2, sHeight / 2, sWidth, sHeight)
   modalLayer:setFillColor(.5, .5, .5, .5)

   local background = display.newImage("images/Background/LightWood.png")
   background.x = sWidth / 2
   background.y = sHeight / 2
   background.width = sWidth / 2
   background.height = sHeight / 2

   local function scrollListener(event)
      if event.phase == "began" then

      elseif event.phase == "ended" then

      end
   end
   self.scrollView = widget.newScrollView {
      x = sWidth / 2,
      y = sHeight / 2,
      width = sWidth / 2,
      height = sHeight / 2,
      scrollWidth = sWidth,
      horizontalScrollDisabled = true,
      hideBackground = true,
      isBounceEnabled = false,
      listener = scrollListener
   }

   self:setupList()

   sceneGroup:insert(modalLayer)
   sceneGroup:insert(background)
   sceneGroup:insert(self.scrollView)
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

function scene:setupList()
   local params = self.params
   local expansions = params.cardsets
   local h = 0.1 * sHeight
   self:setupBackButton()
   local function tapHandler(event)
      self:setupSubLevel(event.target.expansion)
      self.scrollView:scrollToPosition({x = -240, y = 0})
      
   end
   for k,expansion in pairs(expansions) do
      local group = display.newGroup()
      group.expansion = expansion
      local bg = display.newRect(sWidth / 4, (k - 0.5) * h, sWidth / 2, h)
      bg:setFillColor(1, 1, 1, .3)
      local line1 = display.newLine(0, (k - 1) * h, sWidth / 2, (k - 1) * h)
      line1:setStrokeColor(.8, .5)
      local line2 = display.newLine(sWidth / 2, (k - 1) * h, sWidth / 2, k * h)
      line2:setStrokeColor(.8, .5)
      local line4 = display.newLine(0, k * h, 0, (k - 1) * h)
      line4:setStrokeColor(.8, .5)

      group.text = display.newText {
         text = expansion.name,
         x = 0.245 * sWidth,
         y = (k - 0.5) * h,
         width = 0.45 * sWidth,
         align = "left",
         fontSize = 20
      }

      local arrowLine1 = display.newLine(0.49 * sWidth, (k - 0.5) * h, 0.48 * sWidth, (k - 0.35) * h)
      arrowLine1:setStrokeColor(.8)
      local arrowLine2 = display.newLine(0.49 * sWidth, (k - 0.5) * h, 0.48 * sWidth, (k - 0.65) * h)
      arrowLine2:setStrokeColor(.8)

      group:insert(bg)
      group:insert(line1)
      group:insert(line2)
      if k == #expansions then
         local line3 = display.newLine(sWidth / 2, k * h, 0, k * h)
         line3:setStrokeColor(.8, .5)
         group:insert(line3)
      end
      group:insert(line4)
      group:insert(arrowLine1)
      group:insert(arrowLine2)
      group:insert(group.text)

      group:addEventListener("tap", tapHandler)

      self.scrollView:insert(group)
   end
end

function scene:setupSubLevel(expansion)
   local h = 0.1 * sHeight
   self.subGroup = display.newGroup()
   local function tapHandler(event)
      self.menu:updateCardSetText(event.target.expansion, event.target.set)
      composer.hideOverlay(true, "fade")
   end
   for k,set in pairs(expansion.sets) do
      k = k + 1
      local group = display.newGroup()
      group.expansion = expansion
      group.set = set
      local bg = display.newRect(3 * sWidth / 4, (k - 0.5) * h, sWidth / 2, h)
      bg:setFillColor(1, 1, 1, .3)
      local line1 = display.newLine(sWidth / 2, (k - 1) * h, sWidth, (k - 1) * h)
      line1:setStrokeColor(.8, .5)
      local line2 = display.newLine(sWidth, (k - 1) * h, sWidth, k * h)
      line2:setStrokeColor(.8, .5)
      local line4 = display.newLine(sWidth / 2, k * h, sWidth / 2, (k - 1) * h)
      line4:setStrokeColor(.8, .5)

      group.text = display.newText {
         text = set.name,
         x = 0.76 * sWidth,
         y = (k - 0.5) * h,
         width = 0.4 * sWidth,
         align = "left",
         fontSize = 20
      }

      group:insert(bg)
      group:insert(line1)
      group:insert(line2)
      if k == #expansion.sets then
         local line3 = display.newLine(sWidth, k * h, sWidth / 2, k * h)
         line3:setStrokeColor(.8, .5)
         group:insert(line3)
      end
      group:insert(line4)
      group:insert(group.text)

      group:addEventListener("tap", tapHandler)

      self.subGroup:insert(group)
   end
   self.scrollView:insert(self.subGroup)
end

function scene:setupBackButton()
   local h = 0.1 * sHeight
   local function tapHandler(event)
      local function onComplete()
         self.subGroup:removeSelf()
      end
      self.scrollView:scrollToPosition({x = 0, y = 0, onComplete = onComplete})
      
   end
   local group = display.newGroup()
   local bg = display.newRect(3 * sWidth / 4, 0.5 * h, sWidth / 2, h)
   bg:setFillColor(1, 1, 1, .3)
   local line1 = display.newLine(sWidth / 2, 0, sWidth, 0)
   line1:setStrokeColor(.8, .5)
   local line2 = display.newLine(sWidth, 0, sWidth, h)
   line2:setStrokeColor(.8, .5)
   local line4 = display.newLine(sWidth / 2, h, sWidth / 2, 0)
   line4:setStrokeColor(.8, .5)

   group.text = display.newText {
      text = "Back",
      x = 0.76 * sWidth,
      y = 0.5 * h,
      width = 0.4 * sWidth,
      align = "left",
      fontSize = 20
   }

   local arrowLine1 = display.newLine(0.51 * sWidth, 0.5 * h, 0.52 * sWidth, 0.65 * h)
   arrowLine1:setStrokeColor(.8)
   local arrowLine2 = display.newLine(0.51 * sWidth, 0.5 * h, 0.52 * sWidth, 0.35 * h)
   arrowLine2:setStrokeColor(.8)

   group:insert(bg)
   group:insert(line1)
   group:insert(line2)
   group:insert(line4)
   group:insert(arrowLine1)
   group:insert(arrowLine2)
   group:insert(group.text)

   group:addEventListener("tap", tapHandler)

   self.scrollView:insert(group)

end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
