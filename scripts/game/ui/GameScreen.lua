local sceneName = "GameScreen"
require "scripts.game.ui.PlayerHandDisplay"
require "scripts.game.ui.CardSupplyDisplay"
require "scripts.game.ui.GameInfoDisplay"
require "scripts.game.ui.HandSelectionModal"
require "scripts.game.ui.CardSelectionModal"
require "scripts.game.ui.ChoiceModal"
local scene = composer.newScene(sceneName)
gameScreen = scene

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view

   local background = display.newImage("images/Background/DarkWood.png")
   background.x = sWidth / 2
   background.y = sHeight / 2 - 3
   background.width = sWidth
   background.height = sHeight + 6

   self.playerHandDisplay = PlayerHandDisplay:new()
   self.cardSupplyDisplay = CardSupplyDisplay:new()
   self.gameInfoDisplay = GameInfoDisplay:new()

   sceneGroup:insert(background)
   sceneGroup:insert(self.playerHandDisplay)
   sceneGroup:insert(self.cardSupplyDisplay)
   sceneGroup:insert(self.gameInfoDisplay)
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

function scene:update()
   if self.playerHandDisplay ~= nil then
      self.playerHandDisplay:update()
      self.cardSupplyDisplay:update()
      self.gameInfoDisplay:update()
   end
end

function scene:setupForSupplySelection(params)
   self.cardSupplyDisplay:setupForSelection(params)
   self.playerHandDisplay:update()
   self.gameInfoDisplay:update()
end

function scene:setupForHandSelection(params)
   self.playerHandDisplay:setupForSelection(params)
   self.cardSupplyDisplay:update()
   self.gameInfoDisplay:update()
end

function scene:setupForDefault()
   self.playerHandDisplay:setupForDefault()
   self.cardSupplyDisplay:setupForDefault()
   self.gameInfoDisplay:update()
end

function scene:showHandSelectionModal(params)
   local options = {}
   combine(options, modalOptions)
   options.params = params
   composer.showOverlay("HandSelectionModal", options)
end

function scene:showCardSelectionModal(params)
   local options = {}
   combine(options, modalOptions)
   options.params = params
   composer.showOverlay("CardSelectionModal", options)
end

function scene:showChoiceModal(params)
   local options = {}
   combine(options, modalOptions)
   options.params = params
   composer.showOverlay("ChoiceModal", options)
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
