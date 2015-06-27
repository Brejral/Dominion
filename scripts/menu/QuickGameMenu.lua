-- QuickGameMenu
local sceneName = "QuickGameMenu"
require "scripts.game.ui.GameScreen"
require "scripts.game.Game"
require "scripts.util.DropDownMenu"
require "scripts.util.RowData"
require "scripts.menu.CardSetPicker"
local scene = composer.newScene(sceneName)
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here
local numPlayers = 2
local cardsets = loadData("cardsets.json")
local expansion = cardsets[9]
local cardset = expansion.sets[3]
---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view

   local titleText = display.newText {
      text = "Quick Game",
      x = sWidth / 2,
      y = 30,
      font = titleFont,
      fontSize = 30
   }

   local playersText = display.newText {
      text = "Players",
      x = 50,
      y = 60,
      font = titleFont,
      fontSize = 15,
      align = "right"
   }

   local function numPlayerSelectionChange(event)
      numPlayers = tonumber(event.target.segmentLabel)
   end

   self.numPlayersSelection = widget.newSegmentedControl {
      segments = { "2", "3", "4"},
      labelSize = 10,
      labelColor = { default = {1, 1, 1}, over = {0, 0, 1} },
      deviderFrame = 10,
      defaultSegment = 1,
      segmentWidth = 30,
      top = 70,
      left = 5,
      onPress = numPlayerSelectionChange
   }

   local function startGameButtonHandler(event)
      local phase = event.phase
      if phase == "ended" then
         local params = {
            numPlayers = numPlayers,
            cardSet = cardset,
            expansion = expansion
         }
         game = Game(params)
         composer.gotoScene("GameScreen", screenDownTransOptions)
      end
   end

   self.startGameButton = Button:new({
      label = "Start Game",
      labelColor = { default = {1, 1, 1}, over = {0, 0, 1} },
      x = 0.85 * sWidth,
      y = 20,
      font = buttonFont,
      onEvent = startGameButtonHandler
   })

   local cardSetData = {}
   for i=1, #cardsets do
      local rowData = RowData.new(cardsets[i].name, {index=i})
      cardSetData[i] = rowData
   end

   self.expansionText = display.newText {
      text = expansion.name .. ":",
      x = 0.65 * sWidth,
      y = 0.2 * sHeight,
      width = 0.35 * sWidth,
      align = "right",
      fontSize = 13
   }
   self.setText = display.newText {
      text = cardset.name,
      x = 0.65 * sWidth,
      y = self.expansionText.y + self.expansionText.height/2 + 0.02 * sHeight,
      width = 0.35 * sWidth,
      align = "right",
      fontSize = 13
   }
   local function setButtonHandler(event)
      if event.phase == "ended" then
         local options = {}
         combine(options, modalOptions)
         options.params = {
            cardsets = cardsets,
            menu = self
         }
         composer.showOverlay("CardSetPicker", options)
      end
   end
   local setButton = Button:new({
      label = "Select",
      x = 0.87 * sWidth,
      y = self.expansionText.y + self.expansionText.height/2,
      font = buttonFont,
      onEvent = setButtonHandler
   })

   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
   sceneGroup:insert(titleText)
   sceneGroup:insert(playersText)
   sceneGroup:insert(self.numPlayersSelection)
   sceneGroup:insert(self.startGameButton)
   sceneGroup:insert(self.expansionText)
   sceneGroup:insert(self.setText)
   sceneGroup:insert(setButton)
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

function scene:updateCardSetText(exp, set)
   expansion = exp
   cardset = set
   self.expansionText.text = expansion.name .. ":"
   self.setText.text = cardset.name
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
