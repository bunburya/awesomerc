-- {{{ Variable definitions

-- Path to theme.lua, the script governing our custom theme.
themerc = "/home/alan/.config/awesome/themes/custom/theme.lua"

-- Path to directory where the background images are stored
wallpaper_dir = ('/home/alan/pics/backgrounds/')

-- Shutdown, suspend and restart
shutdown = "shutdown -h now"
reboot = "reboot"
reboot_bios = "systemctl reboot --firmware-setup"
suspend = "pm-suspend"


-- Browser
browser = "firefox"

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
python = terminal .. " -e ipython"

-- File manager
fm = "pcmanfm"

-- Directory to which screenshots are to be saved
scrn_dir = "/home/alan/pics/screenshots"

-- Whether the info bar at the bottom is visible
info_vis = false

-- Useful functions
function splitstr(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end

function sleep (n)
    os.execute("sleep " .. tonumber(n))
end


function run_once(prg)
    -- Run a program only if it is not already running.
    awful.util.spawn_with_shell("pgrep -u $USER -x " .. prg .. " || (" .. prg .. ")")
end

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

