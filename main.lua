-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

require "scripts.util.Constants"
require "scripts.util.Util"
require "scripts.menu.MainMenu"

display.setStatusBar(display.HiddenStatusBar)

composer.gotoScene("MainMenu")

--printArray(native.getFontNames())

require "test"