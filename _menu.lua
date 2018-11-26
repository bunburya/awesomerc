-- {{{ Menu

gamesmenu = {
    { "armagetron", "armagetronad" },
    { "corsix-th", "CorsixTH" },
    { "openttd", "openttd"},
    { "supertuxkart", "supertuxkart" },
    { "warzone 2100", "warzone2100" },
    { "wesnoth", "wesnoth" },
    { "morrowind", "openmw"},
    { "nethack", terminal.." nethack" }
}

netmenu = {
    { "wicd", "wicd-client" },
    { "firefox", "firefox" },
    { "surf", "surf" },
    { "elinks", terminal.." -e elinks" },
    { "thunderbird", "thunderbird" },
    { "chat", terminal.." -e irssi" }
}

officemenu = {
    { "libreoffice", "libreoffice" },
    { "-base", "libreoffice -base" },
    { "-calc", "libreoffice -calc" },
    { "-impress", "libreoffice -impress" },
    { "-writer", "libreoffice -writer" },
    { "evince (pdf)", "evince" }
}

mediamenu = {
    { "spotify", "spotify" },
    { "vlc", "vlc" },
    { "mirage (images)", "mirage" }
}

progmenu = {
    { "cmake", "cmake-gui" },
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
