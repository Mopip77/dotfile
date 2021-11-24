-- import ipc (命令行入口)
require("hs.ipc")

stackline = require "stackline"
stackline:init()

-- activate chrome open a new tab
hs.hotkey.bind({'cmd', 'alt', 'ctrl', 'shift'}, 'o', function()
	hs.osascript.applescriptFromFile('openNewEdgeTab.applescript')
end)

clock = require "Aclock"
ac = clock:init()
ac:show()

