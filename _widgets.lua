-- Define custom widgets and behaviour relating to them.

vicious = require("vicious")

-- Volume and power widgets are old and don't use vicious, the rest are newer
-- and do use vicious.
-- Volume and power use certain functionality (coloured output depending on
-- volume/power level) which I can't replicate in vicious yet, so until I find
-- better docs for vicious they stay that way.

-- {{{ Volume textbox
function get_volume(widget)
    -- Takes a widget which has a text value as an arg. Gets the current
    -- audio volume, formats it and sets it as the text value of the widget.
	local info = io.popen("amixer -c 0 sget Master"):read("*all")
	local level, mute_status = string.match(info, "%[(%d+%%)%] %[%-*%d+%.%d+dB%] %[(%a+)%]")
	text = " <b>" .. level .. "</b>"
    if mute_status == "off" then
        text = "<span color=\"red\">" .. text .. "</span>"
    end
	widget:set_markup(text)
end

vol_level = wibox.widget.textbox()
get_volume(vol_level)
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
pow_interface = "org.freedesktop.UPower.Device"
acad_change = "type='signal',interface='"..pow_interface.."',path='/org/freedesktop/UPower/devices/line_power_ACAD',member='Changed'"
batt_change = "type='signal',interface='"..pow_interface.."',path='/org/freedesktop/UPower/devices/battery_BAT1',member='Changed'"
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
vicious.register(cpuwidget, vicious.widgets.cpu, "<b>CPU:</b> $1%")
-- }}}

-- {{{ Thermal info textbox
tempwidget = wibox.widget.textbox()
vicious.register(tempwidget, vicious.widgets.thermal, "<b>TEMP:</b> $1°C", nil, "thermal_zone0")
--- }}}

-- {{{ Net usage textbox
netwidget = wibox.widget.textbox()
vicious.register(netwidget, vicious.widgets.net, "<b>NET:</b> ${wlp6s0 up_kb} KB ↑ ${wlp6s0 down_kb} KB ↓")
-- }}}

-- {{{ Hard drive usage textbox
hdwidget = wibox.widget.textbox()
vicious.register(hdwidget, vicious.widgets.fs, "<b>HD:</b> ${/ used_gb} GB / ${/ size_gb} GB")
-- }}}

-- {{{ Pending upgrades textbox
udwidget = wibox.widget.textbox()
vicious.register(udwidget, vicious.widgets.pkg, "<b>UPDATES:</b> $1", nil, "Arch")
-- }}}
