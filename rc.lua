-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

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
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- Variable definitions
require("_definitions")

-- Initialise theme, set wallpaper
beautiful.init(themerc)

-- {{{ Tags
-- Define tags table.
tags = {}
-- Unless there is a compelling reason to do otherwise, add new tags to the end.
-- Otherwise we have to go and change the rules relating to specific apps later on.
names = { "general", "email", "study", "prog", "misc" }
tag_layouts = { 1, 10, 10, 3, 3 }
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = {}
    -- For each screen, create tag for each name
    for tagnumber = 1, #names do
        tags[s][tagnumber] = tag(tagnumber)
        tags[s][tagnumber].name = names[tagnumber]
        -- Add tags to screen one by one
        tags[s][tagnumber].screen = s
        awful.layout.set(layouts[tag_layouts[tagnumber]], tags[s][tagnumber])
    end
    -- Starting tag
    tags[s][1].selected = true
end
-- }}}

-- Menu
require("_menu")

-- Wibox
require("_wibox")

-- Mouse bindings
-- Key bindings
require("_bindings")

-- Rules
require("_rules")

-- Signals
require("_signals")

-- Autostart applications
require("_autostart")
