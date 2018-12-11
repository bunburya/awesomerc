-- Define custom widgets and behaviour relating to them.

vicious = require("vicious")

-- Volume, temperature and power widgets are old and don't use vicious,
-- the rest are newer and do use vicious.
-- Volume and power use certain functionality (coloured output depending on
-- volume/power level) which I can't replicate in vicious yet, so until I find
-- better docs for vicious they stay that way.
-- Temperature widget seems to have broken in vicious so I went back to
-- a sensors-based approach.

-- {{{ Volume textbox
function update_volume()
    -- Takes a widget which has a text value as an arg. Gets the current
    -- audio volume, formats it and sets it as the text value of the widget.
    -- TODO: Maybe switch from io.popen to some asynchrous function with
    -- a callback that updates the widget.
	awful.spawn.easy_async("amixer -c 1 -D pulse sget Master", update_snd_widget)
end

function update_snd_widget(stdout, stderr, exitreason, exitcode)
	-- stdout here is the output of calling amixer -c 1 -D pulse sget Master

	-- Calling amixer with -D pulse actually returns separate values for each speaker;
	-- we just take the value for the first one as they should all be the same 
	local level, sound_status = string.match(stdout, "%[(%d+%%)%] %[(%a+)%]")
	text = " <b>" .. level .. "</b>"
    if sound_status == "off" then
        text = "<span color=\"red\">" .. text .. "</span>"
    end
	vol_level:set_markup(text)
end

pactl_status = { in_event = false }
function handle_pactl_event(stdout)
	if pactl_status.in_event then
		if string.find(stdout, "Event 'change' on sink #0") then
			update_volume(vol_level)
			pactl_status.in_event = false
		end
	else
		if string.find(stdout, "Event 'new' on client #") then
			pactl_status.in_event = true
		end
	end
end

awful.spawn.with_line_callback("pactl subscribe", { stdout = handle_pactl_event })	

vol_level = wibox.widget.textbox()
update_volume(vol_level)
vol_icon = wibox.widget.imagebox()
vol_icon:set_image("/home/alan/.config/awesome/themes/custom/speaker.png")
vol_widget = {vol_icon, vol_level}

-- }}}

-- {{{ Battery textbox

-- Displays battery charge as %, and indicates charging/discharging
-- status with +/- after the battery level.
-- Color coding and notifications alert user if battery is reaching
-- very low levels.
-- work in progress tbh
function get_batt(widget)
	local info = io.popen("acpi -b"):read("*all")
	if info == ""
	then
		text = " <b>removed</b> "
	else
		local dis_charge, level = string.match(info, "(%a+), (%d+)%%")
		local lev_num = tonumber(level)
		
		if dis_charge == "Discharging" then
			if lev_num <= 10 then
				text = ' <b><span color="red">' .. level .. '%-</span></b> '
				naughty.notify({ text = "Battery is running low.\n" .. level .. "% remaining.", title = "Low battery" })
			else
				text = " <b>" .. level .. "%-</b> "
			end
		elseif dis_charge == "Charging" then
			text = " <b>" .. level .. "%+</b> "
		elseif dis_charge == "Full" then     -- Battery is full, and AC plugged in.
			text = ' <b><span color="green">' .. level .. '%</span></b> '
		end
	end
	widget:set_markup(text)
end


batt_icon = wibox.widget.imagebox()
batt_icon:set_image("/home/alan/.config/awesome/themes/custom/battery.png")
batt_level = wibox.widget.textbox()
function update_batt()
    get_batt(batt_level)
end
update_batt()
batt_update_timer = timer({ timeout = 30 })

batt_update_timer:connect_signal("timeout", update_batt)
batt_update_timer:start()
-- Below doesn't seem to work.  Fix it, then we can stop setting the timer.
pow_interface = "org.freedesktop.UPower.Device"
acad_change = "type='signal',interface='"..pow_interface.."',path='/org/freedesktop/UPower/devices/line_power_AC',member='Changed'"
batt_change = "type='signal',interface='"..pow_interface.."',path='/org/freedesktop/UPower/devices/battery_BAT0',member='Changed'"
dbus.add_match("system", acad_change)
dbus.add_match("system", batt_change)
dbus.connect_signal(pow_interface, update_batt)

batt_widget = {batt_icon, batt_level}
-- }}}

-- {{{ RAM usage textbox
-- Taken from Vicious article on Awesome wiki

-- Initialize widget
memwidget = wibox.widget.textbox()
-- Register widget
-- $1 = percentage usage, $2 = actual usage, $3 = total available
vicious.register(memwidget, vicious.widgets.mem, "<b>RAM:</b> $2 MB ($1%)")

-- }}}
 
-- {{{ CPU usage textbox
-- Taken from Vicious article on Awesome wiki
cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu, "<b>CPU:</b> $1% ")

-- Check CPU temp.  Relies on "cputemp" which is a short script to output CPU temp in a format like "41.2°C"
cputmpwidget = wibox.widget.textbox()
awful.widget.watch('cputemp', 5,
		function(w, s)
			-- strip spaces and newline from output of cputemp
			w:set_markup_silently('('..string.gsub(s, "%s*\n", "")..')') 
		end, cputmpwidget)
-- }}}

-- {{{ Net usage textbox
netwidget = wibox.widget.textbox()
vicious.register(netwidget, vicious.widgets.net, "<b>NET:</b> ${wlp6s0 up_kb} KB ↑ ${wlp6s0 down_kb} KB ↓")
-- }}}

-- {{{ Hard drive usage textbox
hdwidget = wibox.widget.textbox()
vicious.register(hdwidget, vicious.widgets.fs, "<b>SSD:</b> ${/ used_gb} GB / ${/ size_gb} GB")
-- }}}

-- {{{ Pending upgrades textbox
udwidget = wibox.widget.textbox()
vicious.register(udwidget, vicious.widgets.pkg, "<b>UPDATES:</b> $1", nil, "Arch")
-- }}}
