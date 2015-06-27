-- Button Class
Button = display.newGroup()
Button_mt = { __index = Button }

-- Derived class method new
function Button:new(params)
   local new_inst = display.newGroup()
   setmetatable(new_inst, Button_mt)

   --Properties
   new_inst:setupButton(params)
   
   new_inst:setEnabled(true)

   return new_inst
end

function Button:setupButton(params)
   self.params = params
   self.isSelectionMode = params.isSelectionMode
   self.isSelected = false
   self.x = params.x or 0
   self.y = params.y or 0

   if params.label then
      self.label = display.newText {
         text = params.label,
         x = self.x,
         y = self.y,
         align = params.labelAlign,
         fontSize = params.fontSize or 14,
         font = params.font
      }
      local fontColor = params.labelColor and params.labelColor.default or {1, 1, 1}
      self.label:setFillColor(fontColor[1], fontColor[2], fontColor[3])
   end
   self.width = params.width or self.label and self.label.width + 6 or 0
   self.height = params.height or self.label and self.label.height + 4 or 0

   self.images = {}
   self:setBackground(true)

   self:addEventListener("touch", self.onEvent)

   if self.label then
      self:insert(self.label)
   end
end

function Button.onEvent(event)
   if event.phase == "began" and event.target.isEnabled then
      display.getCurrentStage():setFocus(event.target)
      if event.target.label then
         local overColor = event.target.params.labelColor and event.target.params.labelColor.over or {0, 0, 1}
         event.target.label:setFillColor(overColor[1], overColor[2], overColor[3])
      end
      event.target:setBackground(false)
   elseif (event.phase == "ended" or event.phase == "cancelled") and event.target.isEnabled then
      display.getCurrentStage():setFocus(nil)
      if event.target.isSelectionMode then
         event.target.isSelected = not event.target.isSelected
      end
      if event.target.label and (not event.target.isSelectionMode or not event.target.isSelected) then
         local fontColor = event.target.params.labelColor and event.target.params.labelColor.default or {1, 1, 1}
         event.target.label:setFillColor(fontColor[1], fontColor[2], fontColor[3])
      end
      event.target:setBackground(not event.target.isSelected)
   end
   if event.target.params.onEvent and event.target.isEnabled then
      event.target.params.onEvent(event)
   end
end

function Button:setEnabled(enabled)
self.isEnabled = enabled
   if enabled then
      for k,image in pairs(self.images) do
         image:setFillColor(1, 1)
      end
      self.label:setFillColor(1, 1)
   else
      for k,image in pairs(self.images) do
         image:setFillColor(.6, .6)
      end
      self.label:setFillColor(.6, .6)
   end
end

function Button:setLabel(text)
   if self.label then
      self.label.text = text
   end
end

function Button:setBackground(isDefault)
   local params = self.params
   local x = {}
   local y = {}
   table.insert(x, (isDefault and params.defaultX and params.defaultX[1] or params.overX and params.overX[1]) or 75)
   table.insert(x, (isDefault and params.defaultX and params.defaultX[2] or params.overX and params.overX[2]) or 565)
   table.insert(x, (isDefault and params.defaultX and params.defaultX[3] or params.overX and params.overX[3]) or 640)
   table.insert(y, (isDefault and params.defaultX and params.defaultY[1] or params.overX and params.overY[1]) or 75)
   table.insert(y, (isDefault and params.defaultX and params.defaultY[2] or params.overX and params.overY[2]) or 325)
   table.insert(y, (isDefault and params.defaultX and params.defaultY[3] or params.overX and params.overY[3]) or 400)
   local options = {
      frames = {
         { x = 0, y = 0, width = x[1], height = y[1]},
         { x = x[1], y = 0, width = x[2] - x[1], height = y[1]},
         { x = x[2], y = 0, width = x[3] - x[2], height = y[1]},
         { x = 0, y = y[1], width = x[1], height = y[2] - y[1]},
         { x = x[1], y = y[1], width = x[2] - x[1], height = y[2] - y[1]},
         { x = x[2], y = y[1], width = x[3] - x[2], height = y[2] - y[1]},
         { x = 0, y = y[2], width = x[1], height = y[3] - y[2]},
         { x = x[1], y = y[2], width = x[2] - x[1], height = y[3] - y[2]},
         { x = x[2], y = y[2], width = x[3] - x[2], height = y[3] - y[2]}
      },
      sheetContentWidth = x[3],
      sheetContentHeight = y[3]
   }
   local fileName = ""
   if isDefault then
      fileName = params.defaultFile or "images/UI/ButtonDefault.png"
   else
      fileName = params.overFile or "images/UI/ButtonPressed.png"
   end
   local imageSheet = graphics.newImageSheet(fileName, options)
   for k,image in pairs(self.images) do
      image:removeSelf()
   end
   self.images = {}
   local xRatio = self.width / x[3]
   local yRatio = self.height / y[3]
   local sliceX, sliceY = {}, {}
   table.insert(sliceY, self.y - self.height / 2)
   table.insert(sliceY, y[1] * yRatio + sliceY[1])
   table.insert(sliceY, self.y + self.height / 2 - (y[3] - y[2]) * yRatio)
   table.insert(sliceY, self.y + self.height / 2)
   table.insert(sliceX, self.x - self.width / 2)
   table.insert(sliceX, x[1] / y[1] * (sliceY[2] - sliceY[1]) + sliceX[1])
   table.insert(sliceX, self.x + self.width / 2 - (x[3] - x[2]) / y[1] * (sliceY[2] - sliceY[1]))
   table.insert(sliceX, self.x + self.width / 2)
   for j = 2, 4 do
      for i = 2, 4 do
         local x1 = sliceX[i - 1]
         local y1 = sliceY[j - 1]
         local x2 = sliceX[i]
         local y2 = sliceY[j]
         local image = display.newImage(imageSheet, (i - 1) + (j - 2) * 3)
         image.x = (x2 - x1) / 2 + x1
         image.y = (y2 - y1) / 2 + y1
         image.width = x2 - x1
         image.height = y2 - y1
         table.insert(self.images, image)
         self:insert(1, image)
      end
   end
end

function Button:setX(x)
   self.x = x
   self.label.x = x
   self:setBackground(true)
end
