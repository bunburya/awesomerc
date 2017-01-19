-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),

    -- Custom keybindings mostly begin here
    
    -- Volume control
    awful.key({ modkey, }, "XF86AudioLowerVolume", function () awful.util.spawn("amixer -c 1 sset Master playback 5%-")
                                                       get_volume(vol_level) end),
    awful.key({ modkey, }, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer -c 1 sset Master playback 5%+")
                                                       get_volume(vol_level) end),
    awful.key({ modkey, }, "XF86AudioMute", function () awful.util.spawn("amixer -c 1 sset Master playback toggle")
                                                get_volume(vol_level) end),
    
    -- Music control, assumes MPD handles music with MPC installed.
    -- Also assumes there is a graphical MPD client (eg gmpc) open, to provide notification on song changes.
    -- NOTE: We won't be using mpd so find a way to make these control spotify
    --awful.key({ }, "XF86AudioStop", function() awful.util.spawn("mpc stop") end),
    --awful.key({ }, "XF86AudioPlay", function() awful.util.spawn("mpc toggle") end), 
    --awful.key({ }, "XF86AudioPrev", function() awful.util.spawn("mpc prev") end),
    --awful.key({ }, "XF86AudioNext", function() awful.util.spawn("mpc next") end),
    --awful.key({ modkey,           }, "XF86AudioPlay", function() naughty.notify({ text = io.popen("mpc"):read("*all"), title = "MPD status" }) end),
    
    -- Brightness control
    awful.key({ modkey, }, "XF86MonBrightnessDown", function () awful.util.spawn ("xbacklight -dec 10") end),
    awful.key({ modkey, }, "XF86MonBrightnessUp", function () awful.util.spawn ("xbacklight -inc 10") end),
    
    -- Common applications
    awful.key({ modkey,           }, "b",     function() awful.util.spawn(browser) end),
    awful.key({ modkey,           }, "p",     function() awful.util.spawn(terminal .. " -e python") end),
    awful.key({ modkey,           }, "Prior", function() awful.util.spawn(fm) end),
    awful.key({ modkey, "Shift"   }, "t",     function() awful.util.spawn("tilda") end),
    awful.key({ modkey,           }, "g",     function() awful.util.spawn("geany") end),
    awful.key({ modkey, "Shift"   }, "w",     function() awful.util.spawn("libreoffice -writer") end),
    awful.key({ modkey,           }, "i",     function()
                                                  info_vis = not info_vis
                                                  for s = 1, screen.count() do
                                                      myinfobar[s].visible = info_vis
                                                  end
                                              end),
    awful.key({ modkey,           }, "u",     function() awful.util.spawn(terminal .. " -e yaourt -Syua && exit || read") end),
    -- sleep() is required in this next line to give awesome time to hand control of the keyboard over to scrot
    awful.key({ modkey,           }, "s",     function() sleep(0.5); awful.util.spawn("sshost") end),
    awful.key({ modkey, "Shift"   }, "s",     function() awful.util.spawn("sshost fs") end),
    awful.key({ modkey, "Shift"	  }, "m",	  function() awful.util.spawn("spotify") end)
    
    -- Suspend on pressing the button to the right of power button
    --awful.key({ }, "XF86Launch1", function () awful.util.spawn(suspend) end)
    

)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}
