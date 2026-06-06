-- Define custom widgets and behaviour relating to them.

require("_helpers")

-- Separators

bar_sep = wibox.widget.textbox()
bar_sep:set_text(" | ")
space_sep = wibox.widget.textbox()
space_sep:set_text(" ")

-- {{{ Volume textbox
function update_volume()
	awful.spawn.easy_async("amixer -c 0 sget Master", update_vol_widget)
end

function update_vol_widget(stdout, stderr, exitreason, exitcode)
	-- stdout here is the output of calling amixer -c 0 sget Master

	local level, sound_status = string.match(stdout, "%[(%d+%%)%] %[%-?%d+%.%d%ddB%] %[(%a+)%]")
	text = " <b>" .. level .. "</b>"
    if sound_status == "off" then
        text = "<span color=\"red\">" .. text .. "</span>"
    end
	vol_level:set_markup(text)
end

function handle_alsa_event(stdout)
    update_volume(vol_level)
end

awful.spawn.with_line_callback("unbuffer alsactl monitor", { stdout = handle_alsa_event })	

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
bat_status = {
    present = nil,
    dis_charge = nil,
    level = nil
}

-- Set the initial status
local init_bat_status = io.popen("acpi -b"):read("*all")
if init_bat_status == "" then
    bat_status.present = false
else
    bat_status.present = true
    local dis_charge, level = string.match(init_bat_status, "(%a+), (%d+)%%")
    if dis_charge == "Full" then
        bat_status.dis_charge = "FullyCharged"
    else
        bat_status.dis_charge = dis_charge
    end
    bat_status.level = tonumber(level)
end

function update_bat_widget(widget, status)
	if not status.present then
		text = " <b>removed</b> "
	else		
		if status.dis_charge == "Discharging" then
			if status.level <= 10 then
				text = ' <b><span color="red">' .. status.level .. '%-</span></b> '
				naughty.notify({ 
                    text = "Battery is running low.\n" .. status.level .. "% remaining.",
                    title = "Low battery" 
                })
			else
				text = " <b>" .. status.level .. "%-</b> "
			end
		elseif status.dis_charge == "Charging" then
			text = " <b>" .. status.level .. "%+</b> "
		elseif status.dis_charge == "FullyCharged" then
			text = ' <b><span color="green">' .. status.level .. '%</span></b> '
		end
	end
	widget:set_markup(text)
end

local dbus = dbus

dbus.add_match(
    "system",
    "type='signal',"
        .."interface='org.freedesktop.DBus.Properties',"
        .."member='PropertiesChanged',"
        .."path='/org/freedesktop/UPower/devices/battery_BAT0'"
)

local dbus_vals = {
    "Unknown",
    "Charging",
    "Discharging",
    "Empty",
    "FullyCharged",
    "PendingCharge",
    "PendingDischarge"
}
dbus.connect_signal("org.freedesktop.DBus.Properties", function(...)
    local args = { ... }
    if args[1].path ~= "/org/freedesktop/UPower/devices/battery_BAT0" then return end
    local values = args[3]
    if values["State"] ~= nil then bat_status.dis_charge = dbus_vals[values["State"]+1] end
    if values["Percentage"] ~= nil then bat_status.level = math.ceil(values["Percentage"]) end

    update_bat_widget(bat_level_textbox, bat_status)
end)

bat_icon_imagebox = wibox.widget.imagebox()
bat_icon_imagebox:set_image("/home/alan/.config/awesome/themes/custom/battery.png")
bat_level_textbox = wibox.widget.textbox()


bat_widget = {bat_icon_imagebox, bat_level_textbox}
update_bat_widget(bat_level_textbox, bat_status)

-- }}}

-- {{{ RAM usage textbox

memwidget = awful.widget.watch("free --bytes", 2, function(widget, stdout)
    local used, total = parse_free(stdout)
    pct = math.floor((used / total) * 100)
    widget:set_markup(string.format("<b>RAM:</b> %s (%d%%)", format_bytes(used), pct))
end)

-- }}}
 
-- {{{ CPU usage textbox
cpu_use_text = wibox.widget.textbox()
cpu_temp_text = wibox.widget.textbox()

function handle_mpstat_output(stdout)
    if string.find(stdout, "all") then
        local idle = tonumber(splitstr(stdout)[12])
        local busy = 100 - idle
        cpu_use_text:set_markup(math.floor(busy+0.5).."%")
    end
end

awful.spawn.with_line_callback('mpstat 3', {stdout = handle_mpstat_output})
        
-- Check CPU temp.  The bash outputs CPU temp in a format like "41.2°C"
awful.widget.watch('bash -c "sensors | grep \\"Package id 0:\\" | awk -F \' \' \'{print $4}\' | cut -c 2-"', 5,
		function(w, s)
			-- strip spaces and newline from output of cputemp
			w:set_markup('('..string.gsub(s, "%s*\n", "")..')') 
		end, cpu_temp_text)

-- Combine both of these CPU widgets into a single wibox
cpu_widget = {
    wibox.widget.textbox("<b>CPU: </b>"),
    cpu_use_text,
    space_sep,
    cpu_temp_text,
    layout=wibox.layout.fixed.horizontal
}
-- }}}

-- {{{ Net usage textbox
local netstats = {up = 0, down = 0}
netwidget = awful.widget.watch("grep wlan0 /proc/net/dev", 2, function(widget, stdout)
    i = i + 1
    local down, up = parse_net_dev(stdout)
    -- divide by two to get per-second value
    local d_down = math.floor((down - netstats["down"]) / 2)
    local d_up = math.floor((up - netstats["up"]) / 2)
    netstats["down"] = down
    netstats["up"] = up
    down_hr = format_bytes(d_down)
    up_hr = format_bytes(d_up)
    widget:set_markup(string.format("<b>NET:</b> %s ↑ %s ↓", up_hr, down_hr))
end)
-- }}}

-- {{{ Hard drive usage textbox
local mountpoints = { ["/"] = "main", ["/mnt/storage"] = "storage" }
hdwidget = awful.widget.watch("df", 5, function(widget, stdout)
    local stats = parse_df(stdout, mountpoints)
    local main = stats["main"]
    local main_total = main[1] / 1000000
    local main_used = main[2] / 1000000
    local storage = stats["storage"]
    local storage_total = storage[1] / 1000000
    local storage_used = storage[2] / 1000000
    widget:set_markup(string.format("<b>main:</b> %.1f / %.1f GB <b>storage:</b> %.1f / %.1f GB", main_used, main_total, storage_used, storage_total))
end)
-- }}}

-- {{{ Pending upgrades textbox
udwidget = awful.widget.watch("bash -c \"trizen -Qu | wc -l\"", 300, function(widget, stdout)
    widget:set_markup(string.format("<b>UPDATES:</b> %d", stdout))
end)
-- }}}

-- {{{ Now Playing textbox

np_cmd = "playerctl --format '{{status}} {{artist}} - {{title}}' -F metadata"

function get_now_playing(output_str)
    -- Parse output of playerctl and get message to display
    i, _ = string.find(output_str, ' ')
    status = string.sub(output_str, 0, i-1)
    if status == "Paused" or status == "Stopped" then return "N/A" end
    return ' ' .. string.sub(output_str, i+1) .. ' '
end

np_label = wibox.widget.textbox("<b>PLAYING:</b> ")
np_textbox = wibox.widget.textbox("N/A")

awful.spawn.with_line_callback(np_cmd, {
    stdout = function(line)
        np_textbox:set_markup(get_now_playing(line))
        
    end
})

np_scrollbox = wibox.container.scroll.horizontal(np_textbox)

np_container = {
    layout = wibox.layout.fixed.horizontal,
    np_label,
    np_scrollbox
}

-- }}}
