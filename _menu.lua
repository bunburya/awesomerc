-- {{{ Menu

gamesmenu = {
    { "AoE 2", "/home/alan/games/wine/aoe2" },
    { "armagetron", "armagetronad" },
    { "biniax-2", "biniax2" },
    { "CM 5", "/home/alan/games/wine/cm5" }, 
    { "corsix-th", "CorsixTH" },
    { "dopewars", "dopewars" },
    { "et", "et" },
    { "freeciv", "freeciv" },
    { "gweled", "gweled" },
    { "openttd", "openttd"},
    { "sauerbraten", "sauerbraten-client" },
    { "supertuxkart", "supertuxkart" },
    { "warzone", "warzone2100" },
    { "wesnoth", "wesnoth" }
}

netmenu = {
    { "nm-applet", "nm-applet" },
    { "firefox", browser },
    { "elinks", terminal.." -e elinks" },
    { "thunderbird", "thunderbird" },
    { "liferea", "liferea" },
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
    { "ncmpcpp", terminal .. "-e ncmpcpp" },
    { "mpd", "/home/alan/bin/mpdstart" },
}

progmenu = {
    { "cmake", "cmake-gui" },
    { "geany", "geany" },
    { "nano", "nano" },
    { "python", python },
    { "tutorials", "pcmanfm /home/alan/Tutorials" }
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
 
mylauncher = awful.widget.launcher({ image = image(beautiful.arch_icon),
                                     menu = mymainmenu })
-- }}}
