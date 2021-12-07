-- This is my AwesomeWM configuration. Other than custom keybindings, etc,
-- the main difference to the standard configuration is that I have split it
-- out into different files for ease of maintenance. This file mostly just
-- imports the other files.

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")


-- Some of the below imports cannot be local, as they are required
-- by the modules we import

-- Standard awesome library
gears = require("gears")
awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
wibox = require("wibox")
-- Theme handling library
beautiful = require("beautiful")
-- Notification library
naughty = require("naughty")
menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Script to handle external monitor
xrandr = require("_xrandr")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions

require("_definitions")

-- Themes define colours, icons, font and wallpapers.
beautiful.init(themerc)

-- }}}

-- {{{ Helper functions
function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- {{{ Menu

require("_menu")

-- }}}


-- {{{ Wibar

require("_wibox")

-- }}}

-- {{{ Keyboard and mouse bindings

require("_bindings")

-- }}}

-- {{{ Rules

require("_rules")

-- }}}

-- {{{ Signals

require("_signals")

-- }}}
