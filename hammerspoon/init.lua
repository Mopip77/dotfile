-- import ipc (命令行入口)
require("hs.ipc")

-- stackline (yabai stack展示图标)
stackline = require "stackline"
stackline:init()

-- activate chrome open a new tab
hs.hotkey.bind({'cmd', 'alt', 'ctrl', 'shift'}, 'o', function()
	hs.osascript.applescriptFromFile('openNewChromeTab.applescript')
end)

-- aclock
--clock = require "Aclock"
--clock:init()


--------------------------------
-- START VIM CONFIG
--------------------------------
local VimMode = hs.loadSpoon("VimMode")
local vim = VimMode:new()

-- Configure apps you do *not* want Vim mode enabled in
-- For example, you don't want this plugin overriding your control of Terminal
-- vim
vim
  :disableForApp('Code')
  :disableForApp('zoom.us')
  :disableForApp('iTerm')
  :disableForApp('iTerm2')
  :disableForApp('Terminal')
  :disableForApp('IntelliJ IDEA')

-- If you want the screen to dim (a la Flux) when you enter normal mode
-- flip this to true.
vim:shouldDimScreenInNormalMode(false)

-- If you want to show an on-screen alert when you enter normal mode, set
-- this to true
vim:shouldShowAlertInNormalMode(true)

-- You can configure your on-screen alert font
vim:setAlertFont("HarmonyOS Sans SC")

-- Enter normal mode by typing a key sequence
-- vim:enterWithSequence('jk')

-- 在karabiner中重载为 caps + u
vim:bindHotKeys({ enter = { {'ctrl', 'shift', 'alt'}, '8' } })

--------------------------------
-- END VIM CONFIG
--------------------------------
--

-- local SkyRocket = hs.loadSpoon("SkyRocket")

-- sky = SkyRocket:new({
  -- Which modifiers to hold to move a window?
--  moveModifiers = {'alt', 'cmd', 'ctrl'},

  -- Which modifiers to hold to resize a window?
--  resizeModifiers = {'ctrl', 'alt', 'cmd', 'fn' },
-- })
