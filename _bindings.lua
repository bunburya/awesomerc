-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings

local hotkeys_popup = require("awful.hotkeys_popup")

globalkeys = awful.util.table.join(

    -- Think of a key for this that isn't already taken...
    awful.key({ modkey, "Control" }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ "Control",        }, "Menu", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    --awful.key({ modkey }, "p", function() menubar.show() end,
    --          {description = "show the menubar", group = "launcher"}),
    
    
    -- Custom keybindings mostly begin here
    
    -- Volume control
    -- NOTE: When using PulseAudio, need to use the pactl command to toggle mute, as unmuting
    -- doesn't work properly when using amixer. But changing volume with amixer seems to work fine
    -- and is more responsive than the pactl equivalent.
    awful.key({                   }, "XF86AudioLowerVolume", function () awful.spawn("amixer -D pulse -c 0 sset Master playback 5%-") end,
                {description = "decrease volume 5%", group = "audio"}),
    awful.key({                   }, "XF86AudioRaiseVolume", function () awful.spawn("amixer -D pulse -c 0 sset Master playback 5%+") end,
                {description = "increase volume 5%", group = "audio"}),
    awful.key({                   }, "XF86AudioMute", function () awful.spawn("pactl set-sink-mute 0 toggle") end,
                {description = "mute audio", group = "audio"}),
    
    -- Music control, assumes Spotify handles music with playerctl installed.
    awful.key({ modkey, "Control" }, "p", function() awful.util.spawn("playerctl play-pause") end,
                {description = "play/pause music", group="audio"}), 
    awful.key({ modkey, "Control" }, ",", function() awful.util.spawn("playerctl previous") end,
                {description = "play previous song", group="audio"}),
    awful.key({ modkey, "Control" }, ".", function() awful.util.spawn("playerctl next") end,
                {description = "play next song", group="audio"}),
    
    -- Brightness control
    awful.key({                   }, "XF86MonBrightnessDown", function () awful.spawn ("light -U 10") end,
                {description = "decrease brightness 10%", group = "screen"}),
    awful.key({                   }, "XF86MonBrightnessUp", function () awful.spawn ("light -A 10") end,
                {description = "increase brightness 10%", group = "screen"}),
    
    -- Common applications
    awful.key({ modkey,           }, "b",     function() awful.spawn(browser) end,
                {description = "launch browser", group = "applications"}),
    awful.key({                   }, "XF86Calculator",     function() awful.spawn(python) end,
                {description = "launch python interpreter", group = "applications"}),
    awful.key({ modkey,           }, "Prior", function() awful.spawn(fm) end, -- Prior = PgUp
                {description = "launch file manager", group = "applications"}),
    awful.key({ modkey,           }, "g",     function() awful.spawn("geany") end,
                {description = "launch geany", group = "applications"}),
    awful.key({ modkey,           }, "w",     function() awful.spawn("libreoffice -writer") end,
                {description = "launch libreoffice writer", group = "applications"}),
    awful.key({ modkey, "Control" }, "v", function() awful.util.spawn("mullvad") end,
                {description = "toggle wireguard (choose interface)", group = "network"}),
                
    awful.key({ modkey,           }, "v", function() awful.util.spawn("mullvad default") end,
                {description = "toggle wireguard (default interface)", group = "network"}),
    
    -- System monitoring / maintenance
    awful.key({ modkey,           }, "i",     function()
                                                  info_vis = not info_vis
                                                  awful.screen.connect_for_each_screen(function (s)
                                                      s.myinfobar.visible = info_vis end)
                                              end,
                {description = "toggle infobar", group = "system"}),
    awful.key({ modkey,           }, "u",     function() awful.util.spawn(terminal .. " -e trizen -Syu") end,
                {description = "update", group = "system"}),
                
    -- Screenshots
    -- sleep() is required in these functions to give awesome time to hand control of the keyboard over to scrot
    awful.key({                   }, "Print",     function() sleep(0.5); awful.util.spawn("screenshot") end,
                {description = "take screenshot and save locally (selection)", group = "screen"}),
    awful.key({ "Shift",          }, "Print",     function() sleep(0.5); awful.util.spawn("screenshot fs") end,
                {description = "take screenshot and save locally (fullscreen)", group = "screen"}),
    awful.key({ modkey,           }, "Print",     function() sleep(0.5); awful.util.spawn("screenshot cloud") end,
                {description = "take screenshot and upload to remote server (selection)", group = "screen"}),
    awful.key({ modkey, "Shift"   }, "Print",     function() awful.util.spawn("screenshot cloud fs") end,
                {description = "take screenshot and upload to remote server (fullscreen)", group = "screen"}),
    
    -- Toggle screen configurations
    -- Note: Dell Latitude 5520 has a screen switch button (at F8 key) but this
    -- seems to be interpreted by system as modkey+p.
    -- see https://bbs.archlinux.org/viewtopic.php?id=188599
    awful.key({ modkey,           }, "p", function() xrandr.xrandr() end,
                {description = "Switch video mode", group="screen"})
    

)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}
