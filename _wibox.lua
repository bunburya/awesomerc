require("_widgets")

-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create separators
space_sep = widget({ type = "textbox" })
space_sep.text = ' '
bar_sep = widget({type = "textbox" })
bar_sep.text = ' | '

-- Create a taskbar, infobar and related widgets for each screen and add them
mytaskbar = {}

-- aha, this code never gets executed. find out why.
-- once we figure this out, maybe we can move the toggle function in bindings
-- back to definitions
myinfobar = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the taskbar
    mytaskbar[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the taskbar - order matters
    mytaskbar[s].widgets = {
        {
        mylauncher,
        mytaglist[s],
        space_sep,
        mypromptbox[s],
        layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
        vol_level,
        vol_icon,
        batt_level,
        batt_icon,
        s == 1 and space_sep, mysystray or nil,
        space_sep,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
    -- Create the infobar
    myinfobar[s] = awful.wibox({position = "bottom", screen = s, ontop = true})
    myinfobar[s].visible = info_vis
    
    -- Add widgets to the infobar
    myinfobar[s].widgets = {
        memwidget,
        bar_sep,
        cpuwidget,
        bar_sep,
        tempwidget,
        bar_sep,
        netwidget,
        bar_sep,
        hdwidget,
        bar_sep,
        udwidget,
        layout = awful.widget.layout.horizontal.leftright
    }
    
end
-- }}}
