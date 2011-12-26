-- {{{ Volume textbox
function get_volume(widget)
    -- Takes a widget which has a text value as an arg. Gets the current
    -- audio volume, formats it and sets it as the text value of the widget.
	local info = io.popen("amixer -c Intel sget Master"):read("*all")
	local level, mute_status = string.match(info, "%[(%d+%%)%] %[%-*%d+%.%d+dB%] %[(%a+)%]")
	text = " <b>" .. level .. "</b>"
    if mute_status == "off" then
        text = "<span color=\"red\">" .. text .. "</span>"
    end
	widget.text = text
end

vol_level = widget({ type = "textbox" })
get_volume(vol_level)
vol_icon = widget({ type = "imagebox" })
vol_icon.image = image("/home/alan/.config/awesome/themes/custom/volume.png")
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
		elseif dis_charge == "Unknown" then     -- Battery is full, and AC plugged in.
			text = ' <b><span color="green">' .. level .. '%</span></b> '
		end
	end
	widget.text = text
end


batt_icon = widget({ type = "imagebox" })
batt_icon.image = image("/home/alan/.config/awesome/themes/custom/battery.png")
batt_level = widget({ type = "textbox" })
function update_batt()
    get_batt(batt_level)
end
update_batt()
batt_update_timer = timer({ timeout = 30 })

batt_update_timer:add_signal("timeout", update_batt)
batt_update_timer:start()
pow_interface = "org.freedesktop.UPower.Device"
acad_change = "type='signal',interface='"..pow_interface.."',path='/org/freedesktop/UPower/devices/line_power_ACAD',member='Changed'"
batt_change = "type='signal',interface='"..pow_interface.."',path='/org/freedesktop/UPower/devices/battery_BAT1',member='Changed'"
dbus.add_match("system", acad_change)
dbus.add_match("system", batt_change)
dbus.add_signal(pow_interface, update_batt)

batt_widget = {batt_icon, batt_level}
-- }}}
