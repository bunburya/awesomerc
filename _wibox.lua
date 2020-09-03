-- {{{ Wibar

require("_widgets")

bar_sep = wibox.widget.textbox()
bar_sep:set_text(" | ")
space_sep = wibox.widget.textbox()
space_sep:set_text(" ")

-- TOP BAR

-- Tags (used below)

-- Unless there is a compelling reason to do otherwise, add new tags to the end.
-- Otherwise we have to go and change the rules relating to specific apps later on.

local layouts = awful.layout.layouts

-- Main screen (ie, laptop screen)
local main_tag_names = {"general", "email", "music", "prog", "misc"}
local main_tag_layouts = {layouts[1], layouts[10], layouts[10], layouts[3], layouts[3]}

-- Each spare screen (eg, external monitor)
local spare_tag_names = {'spare'}
local spare_tag_layouts = {layouts[1]}

-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = awful.util.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- TODO: Handle change of primary screen.
-- (Related, may need to change xrandr integration to properly set
-- primary screen.)
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)
    
    -- Each screen has its own tag table.
    if s == screen.primary then
        awful.tag(main_tag_names, s, main_tag_layouts)
    else
        awful.tag(spare_tag_names, s, spare_tag_layouts)
    end
    
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            space_sep,
            vol_icon,
            vol_level,
            space_sep,
            batt_icon,
            batt_level,
            mytextclock,
            s.mylayoutbox,
        },
    }
    
    -- BOTTOM BAR

    -- Create the infobar
    
    s.myinfobar = awful.wibar({position = "bottom", screen = s, ontop = true})
    s.myinfobar.visible = info_vis
    
    s.myinfobar:setup {
    layout = wibox.layout.ratio.horizontal,
    spacing_widget = wibox.widget.separator,
    spacing = 10,
    memwidget,
    cpu_widget,
    netwidget,
    hdwidget,
    udwidget
    }
    
end)


-- }}}
