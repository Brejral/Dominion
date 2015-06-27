-- MainMenu
require "scripts.menu.QuickGameMenu"
local sceneName = "MainMenu"
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

   local titleText = display.newText {
      text = "Dominion",
      x = sWidth / 2,
      y = .15 * sHeight,
      font = titleFont,
      fontSize = 0.15 * sHeight
   }

   local function menuBtnHandler(event)
      local phase = event.phase
      if phase == "ended" then
         composer.gotoScene(event.target.sceneId, screenDownTransOptions)
      end
   end

   local quickGameBtn = widget.newButton {
      id = "QuickGameBtn",
      label = "Quick Game",
      labelAlign = "right",
      labelColor = { default = {1, 1, 1}, over = {0, 0, 1} },
      x = 0.05 * sWidth,
      y = 0.25 * sHeight,
      font = buttonFont,
      fontSize = 0.05 * sHeight,
      onEvent = menuBtnHandler
   }
   quickGameBtn.sceneId = "QuickGameMenu"

   -- Insert objects into sceneGroup
   sceneGroup:insert(titleText)
   sceneGroup:insert(quickGameBtn)

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

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
