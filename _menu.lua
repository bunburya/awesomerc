-- {{{ Menu

gamesmenu = {
    { "armagetron", "armagetronad" },
    { "corsix-th", "CorsixTH" },
    { "openttd", "openttd"},
    { "supertuxkart", "supertuxkart" },
    { "warzone 2100", "warzone2100" },
    { "wesnoth", "wesnoth" },
    { "morrowind", "openmw"},
    { "nethack", terminal.." -e nethack" },
    { "steam", "steam" }
}

netmenu = {
    { "firefox", "firefox" },
    { "surf", "surf" },
    { "elinks", terminal.." -e elinks" },
    { "thunderbird", "thunderbird" },
}

officemenu = {
    { "libreoffice", "libreoffice" },
    { "-base", "libreoffice -base" },
    { "-calc", "libreoffice -calc" },
    { "-impress", "libreoffice -impress" },
    { "-writer", "libreoffice -writer" },
    { "zathura (pdf)", "zathopen" }
}

mediamenu = {
    { "spotify", "spotify" },
    { "vlc", "vlc" },
    { "mirage (imgs)", "mirage" },
    { "gimp", "gimp" }
}

progmenu = {
    { "geany", "geany" },
    { "vim", terminal .. " -e vim" },
    { "python", terminal .. " -e python" }
}

sysmenu = {
    { "home", fm },
    { "terminal", terminal },
    { "manual", terminal .. " -e man awesome" },
    { "configure", "geany " .. awesome.conffile },
    { "tasks", terminal .. " -e top" },
    { "restart", awesome.restart },
    { "logout", awesome.quit },
    { "reboot", reboot },
    { "reboot (bios)", reboot_bios },
    { "suspend", suspend },
    { "shutdown", shutdown }
}
 
mymainmenu = awful.menu({ items = { 
                                    { "games", gamesmenu },
                                    { "internet", netmenu },
                                    { "office", officemenu },
                                    { "media", mediamenu },
                                    { "prog", progmenu },
                                    { "system", sysmenu },
                                  }
                        })
 
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- }}}
