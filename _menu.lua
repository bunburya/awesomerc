-- {{{ Menu

gamesmenu = {
    { "armagetron", "armagetronad" },
    { "biniax-2", "biniax2" },
    { "corsix-th", "CorsixTH" },
    { "et", "et" },
    { "gweled", "gweled" },
    { "openttd", "openttd"},
    { "sauerbraten", "sauerbraten-client" },
    { "supertuxkart", "supertuxkart" },
    { "warzone 2100", "warzone2100" },
    { "wesnoth", "wesnoth" }
}

netmenu = {
    { "wicd", "wicd-client" },
    { "firefox", browser },
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
    { "xpdf", "xpdf -cont" }
}

mediamenu = {
    { "mplayer", "/home/alan/bin/mplay" },
    { "spotify", "spotify" },
    { "vlc", "vlc" }
}

progmenu = {
    { "cmake", "cmake-gui" },
    { "geany", "geany" },
    { "vim", terminal .. " -e vim" },
    { "python", terminal .. " -e python" },
    { "tutorials", fm .. " /home/alan/tutorials" }
}

sysmenu = {
    { "home", fm },
    { "terminal", terminal },
    { "manual", terminal .. " -e man awesome" },
    { "configure", "geany " .. awful.util.getdir("config") .. "/rc.lua" },
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
