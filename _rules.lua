-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons }  },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "Tilda" },
      properties = { floating = true } },

    -- Set certain programs to open on specific tags.
    -- NB tags start at 1, not 0.
--    { rule = { class = "Firefox" },
--      properties = { tag = tags[1][1] } },
    { rule = { class = "Thunderbird" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "Liferea" },
      properties = { tag = tags[1][3] } },
    { rule = { class = "Sonata" },
      properties = { tag = tags[1][4] } },
    { rule = { name = "ncmpc++ ver. 0.5.6" },
      properties = { tag = tags[1][5] } }
}
-- }}}
