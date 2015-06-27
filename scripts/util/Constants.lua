--Global constants
composer = require "composer"
json = require "json"
timer = require "timer"
transition = require "transition"
widget = require "widget"
graphics = require "graphics"
require "scripts.util.classlib"
require "scripts.util.Button"

sWidth = display.contentWidth
sHeight = display.contentHeight
titleFont = "Javanese Text"
buttonFont = "Nyala"
modalBackground = "images/Background/LightWood.png"
screenDownTransOptions = {
   effect = "slideLeft",
   time = 500
}
card_ar = 473/296
cardScale = {width = 0.2 * sHeight / card_ar, height = 0.2 * sHeight}
modalOptions = {isModal = true, effect = "fade"}

function holdListener(event)
   event = event.source.params
   event.target.held = true
   event.target.zoomCard = display.newImage(event.target.card:getImage())
   event.target.zoomCard.height = 0.5 * sHeight
   event.target.zoomCard.width = 0.5 * sHeight / card_ar
   event.target.zoomCard.x = event.x + (event.x > sWidth / 2 and -0.25 or 0.25) * sHeight / card_ar
   event.target.zoomCard.y = event.y + (event.y < sHeight / 2 and 0.25 or -0.25) * sHeight
end

function cardTouchListener(event)
   if event.phase == "began" then
      display.getCurrentStage():setFocus(event.target)
      event.target.holdTimer = timer.performWithDelay(1000, holdListener)
      event.target.holdTimer.params = event
   elseif event.phase == "moved" and event.target.held then
      event.target.zoomCard.x = event.x + (event.x > sWidth / 2 and -0.25 or 0.25) * sHeight / card_ar
      event.target.zoomCard.y = event.y + (event.y < sHeight / 2 and 0.25 or -0.25) * sHeight
   elseif event.phase == "ended" or event.phase == "cancelled" then
      event.target.held = false
      if event.target.holdTimer then
         timer.cancel(event.target.holdTimer)
      end
      display.getCurrentStage():setFocus(nil)
      if event.target.zoomCard ~= nil then
         event.target.zoomCard:removeSelf()
         event.target.zoomCard = nil
      end
   end
end

function supplyTouchListener(event)
   if event.phase == "ended" and not event.target.held and event.target.isEnabled then
      local player = game:getCurrentPlayerForTurn()
      player:buyCard(event.target.card)
      gameScreen:update()
   end
   cardTouchListener(event)
end

function selectionTouchListener(event)
   if event.phase == "ended" and not event.target.held and event.target.isEnabled then
      event.target.isSelected = not event.target.isSelected
      gameScreen:update()
   end
   cardTouchListener(event)
end

function handTouchListener(event)
   if event.phase == "ended" and not event.target.held and event.target.isEnabled then
      local player = game:getCurrentPlayerForTurn()
      player:playCard(event.target.card)
      gameScreen:update()
   end
   cardTouchListener(event)
end