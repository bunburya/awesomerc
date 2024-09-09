-- {{{ Rules

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
                     } },
    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer",
          "Mplayer",
          "Tilda",
          "pinentry",
          "gimp"
          },

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},
    { rule = { class = "URxvt" },
      properties = { size_hints_honor = false } },
    { rule = { class = "thunderbird" },
      properties = { screen = screen.primary, tag = "email" } },
    { rule = { class = "Spotify" },
      properties = { screen = screen.primary, tag = "music" } },
    { rule_any = { class = { "jetbrains-pycharm-ce", "jetbrains-studio", "jetbrains-idea-ce" } },
      properties = { screen = screen.primary, tag= "prog" } },
    { rule = { class = "Steam" },
      properties = { screen = screen.primary, tag = "general" } }
      
      
      
    -- Add titlebars to normal clients and dialogs
    -- { rule_any = {type = { "normal", "dialog" }},
    --   properties = { titlebars_enabled = true }},

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}

-- }}}
