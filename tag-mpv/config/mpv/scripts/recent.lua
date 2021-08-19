local o = {
    -- Automatically save to log, otherwise only saves when requested
    -- you need to bind a save key if you disable it
    auto_save = true,
    save_bind = "",
    -- Runs automatically when --idle
    auto_run_idle = true,
    -- Write watch later for current file when switching
    write_watch_later = true,
    -- Display menu bind
    display_bind = "`",
    -- Middle click: Select; Right click: Exit;
    -- Scroll wheel: Up/Down
    mouse_controls = true,
    -- Reads from config directory or an absolute path
    log_path = "history.log",
    -- Reads from config directory or an absolute path
    -- date_format = "%d/%m/%y %X",
    date_format = "%Y-%m-%d %X",
    -- Font settings
    font_scale = 50,
    border_size = 0.7,
    -- Highlight color in BGR hexadecimal
    hi_color = "H46CFFF",
    -- Draw ellipsis at start/end denoting ommited entries
    ellipsis = false
}
(require "mp.options").read_options(o)
local utils = require("mp.utils")
o.log_path = utils.join_path(mp.find_config_file("."), o.log_path)

local cur_title, cur_path
local list_drawn = false

function esc_string(str)
    return str:gsub("([%p])", "%%%1")
end

function get_path()
    local path = mp.get_property("path")
    local title = mp.get_property("media-title"):gsub("\"", "")
    if not path then return end
    --if path:find("http.?://") then
        --return title, path
    --else
        --return title, utils.join_path(mp.get_property("working-directory"), path)
    --end
    return title, utils.join_path(mp.get_property("working-directory"), path)
end

function unbind()
    if o.mouse_controls then
        mp.remove_key_binding("recent-WUP")
        mp.remove_key_binding("recent-WDOWN")
        mp.remove_key_binding("recent-MMID")
        mp.remove_key_binding("recent-MRIGHT")
    end
    mp.remove_key_binding("recent-j")
    mp.remove_key_binding("recent-k")
    mp.remove_key_binding("recent-l")
    mp.remove_key_binding("recent-d")
    mp.remove_key_binding("recent-UP")
    mp.remove_key_binding("recent-DOWN")
    mp.remove_key_binding("recent-ENTER")
    mp.remove_key_binding("recent-1")
    mp.remove_key_binding("recent-2")
    mp.remove_key_binding("recent-3")
    mp.remove_key_binding("recent-4")
    mp.remove_key_binding("recent-5")
    mp.remove_key_binding("recent-6")
    mp.remove_key_binding("recent-7")
    mp.remove_key_binding("recent-8")
    mp.remove_key_binding("recent-9")
    mp.remove_key_binding("recent-0")
    mp.remove_key_binding("recent-ESC")
    mp.remove_key_binding("recent-DEL")
    mp.set_osd_ass(0, 0, "")
    list_drawn = false
end

function read_log(func)
    local f = io.open(o.log_path, "r")
    if not f then return end
    local list = {}
    for line in f:lines() do
        table.insert(list, (func(line)))
    end
    f:close()
    return list
end

function read_log_table()
    return read_log(function(line)
        local t, p
        -- for compatibility with old log format
        if line:find("^.-%] \".-\" |") then
            t, p = line:match("^.-\"(.-)\" | (.*)$")
        else
            p = line:match("^%[.-%] (.*)$")
            t = p
        end
        return {title = t, path = p}
    end)
end

-- Write path to log on file end
-- removing duplicates along the way
function write_log(delete)
    if not cur_path then return end
    -- 自己加的,网络流不添加log
    if string.sub(cur_path, 1, 4) == "http" then
        return
    end
    local content = read_log(function(line)
        if line:find(esc_string(cur_path)) then
            return nil
        else
            return line
        end
    end)
    f = io.open(o.log_path, "w+")
    if content then
        for i=1, #content do
            f:write(("%s\n"):format(content[i]))
        end
    end
    if not delete then
        f:write(("[%s] \"%s\" | %s\n"):format(os.date(o.date_format), cur_title, cur_path))
    end
    f:close()
end

-- Display list on OSD and terminal
function draw_list(list, start, choice)
    local msg = string.format("{\\fscx%f}{\\fscy%f}{\\bord%f}",
                o.font_scale, o.font_scale, o.border_size)
    local hi_start = string.format("{\\1c&H%s}", o.hi_color)
    local hi_end = "{\\1c&HFFFFFF}"
    if o.ellipsis then
        if start ~= 0 then
            msg = msg.."..."
        end
        msg = msg.."\\N\\N"
    end
    local size = #list
    for i=1, math.min(10, size-start), 1 do
        local key
        if i < 10 then
            key = i
        elseif i == 10 then
            key = 0
        end
        local p = list[size-start-i+1].title or list[size-start-i+1].path or ""
        if i == choice+1 then
            msg = msg..hi_start.."("..key..")  "..p.."\\N\\N"..hi_end
        else
            msg = msg.."("..key..")  "..p.."\\N\\N"
        end
        if not list_drawn then
            print("("..key..") "..p)
        end
    end
    if o.ellipsis and start+10 < size then
        msg = msg .."..."
    end
    mp.set_osd_ass(0, 0, msg)
end

-- Handle up/down keys
function select(list, start, choice, inc)
    choice = choice + inc
    if choice < 0 then
        choice = choice + 1
        start = start + inc
    elseif choice >=  math.min(#list, 10) then
        choice = choice - 1
        start = start + inc
    end
    if start > math.max(#list-10, 0) then
        start = start - 1
    elseif start < 0 then
        start = start + 1
    end
    draw_list(list, start, choice)
    return start, choice
end

-- Delete selected entry from the log
function delete(list, start, choice)
    local playing_path = cur_path
    cur_path = list[#list-start-choice].path
    if not cur_path then
        print("Failed to delete")
        return
    end
    write_log(true)
    print("Deleted \""..cur_path.."\"")
    cur_path = playing_path
end

-- Load file and remove binds
function load(list, start, choice)
    unbind()
    if start+choice >= #list then return end
    if o.write_watch_later then
        mp.command("write-watch-later-config")
    end
    mp.commandv("loadfile", list[#list-start-choice].path, "replace")
end

-- Display list and add keybinds
function display_list()
    if list_drawn then
        unbind()
        return
    end
    local list = read_log_table()
    if not list or not list[1] then
        mp.osd_message("Log empty")
        return
    end
    local choice = 0
    local start = 0
    draw_list(list, start, choice)
    list_drawn = true

    mp.add_forced_key_binding("UP", "recent-UP", function()
        start, choice = select(list, start, choice, -1)
    end, {repeatable=true})
    mp.add_forced_key_binding("k", "recent-k", function()
        start, choice = select(list, start, choice, -1)
    end, {repeatable=true})
    mp.add_forced_key_binding("DOWN", "recent-DOWN", function()
        start, choice = select(list, start, choice, 1)
    end, {repeatable=true})
    mp.add_forced_key_binding("j", "recent-j", function()
        start, choice = select(list, start, choice, 1)
    end, {repeatable=true})
    mp.add_forced_key_binding("ENTER", "recent-ENTER", function()
        load(list, start, choice)
    end)
    mp.add_forced_key_binding("l", "recent-l", function()
        load(list, start, choice)
    end)
    mp.add_forced_key_binding("BS", "recent-DEL", function()
        delete(list, start, choice)
        list = read_log_table()
        if not list or not list[1] then
            unbind()
            return
        end
        start, choice = select(list, start, choice, 0)
    end)
    mp.add_forced_key_binding("d", "recent-d", function()
        delete(list, start, choice)
        list = read_log_table()
        if not list or not list[1] then
            unbind()
            return
        end
        start, choice = select(list, start, choice, 0)
    end)
    if o.mouse_controls then
        mp.add_forced_key_binding("WHEEL_UP", "recent-WUP", function()
            start, choice = select(list, start, choice, -1)
        end)
        mp.add_forced_key_binding("WHEEL_DOWN", "recent-WDOWN", function()
            start, choice = select(list, start, choice, 1)
        end)
        mp.add_forced_key_binding("MBTN_MID", "recent-MMID", function()
            load(list, start, choice)
        end)
        mp.add_forced_key_binding("MBTN_RIGHT", "recent-MRIGHT", function()
            unbind()
        end)
    end
    mp.add_forced_key_binding("1", "recent-1", function() load(list, start, 0) end)
    mp.add_forced_key_binding("2", "recent-2", function() load(list, start, 1) end)
    mp.add_forced_key_binding("3", "recent-3", function() load(list, start, 2) end)
    mp.add_forced_key_binding("4", "recent-4", function() load(list, start, 3) end)
    mp.add_forced_key_binding("5", "recent-5", function() load(list, start, 4) end)
    mp.add_forced_key_binding("6", "recent-6", function() load(list, start, 5) end)
    mp.add_forced_key_binding("7", "recent-7", function() load(list, start, 6) end)
    mp.add_forced_key_binding("8", "recent-8", function() load(list, start, 7) end)
    mp.add_forced_key_binding("9", "recent-9", function() load(list, start, 8) end)
    mp.add_forced_key_binding("0", "recent-0", function() load(list, start, 9) end)
    mp.add_forced_key_binding("ESC", "recent-ESC", function() unbind() end)
end

if o.auto_save then
    mp.register_event("end-file", function() write_log(false) end)
else
    mp.add_key_binding(o.save_bind, "recent-save", function()
        write_log(false)
        mp.osd_message("Saved entry to log")
    end)
end

if o.auto_run_idle then
    mp.register_event("idle", display_list)
end

mp.register_event("file-loaded", function()
    unbind()
    cur_title, cur_path = get_path()
end)

mp.add_key_binding(o.display_bind, "display-recent", display_list)
