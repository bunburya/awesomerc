-- Define custom widgets and behaviour relating to them.

vicious = require("vicious")

-- Separators

bar_sep = wibox.widget.textbox()
bar_sep:set_text(" | ")
space_sep = wibox.widget.textbox()
space_sep:set_text(" ")

-- Volume, temperature, power and CPU widgets don't use vicious,
-- the rest are newer and do use vicious.
-- Volume and power use certain functionality (coloured output depending on
-- volume/power level) which I can't replicate in vicious yet, so until I find
-- better docs for vicious they stay that way.
-- Temperature widget seems to have broken in vicious so I went back to
-- a sensors-based approach.
-- Stopped using vicious for CPU widget so I could integrate the progressbar
-- widget from awesome 4.3 (TODO: also do this for RAM and SDD widgets).

-- {{{ Volume textbox
function update_volume()
	--awful.spawn.easy_async("amixer -c 1 -D pulse sget Master", update_snd_widget)
	awful.spawn.easy_async("amixer -c 0 sget Master", update_snd_widget)
end

function update_snd_widget(stdout, stderr, exitreason, exitcode)
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
				naughty.notify({ text = "Battery is running low.\n" .. status.level .. "% remaining.", title = "Low battery" })
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

upmon_cmd = "/usr/bin/upmon -p /org/freedesktop/UPower/devices/battery_BAT0 Percentage,State"

awful.spawn.with_line_callback(upmon_cmd, { stdout = function(line) 
    if not bat_status.present then bat_status = true end
    local dis_charge = string.match(line, "State=(%a+)")
    if dis_charge ~= nil then bat_status.dis_charge = dis_charge end
    local level = string.match(line, "Percentage=(%d+)")
    if level ~= nil then bat_status.level = tonumber(level) end
    update_bat_widget(bat_level, bat_status)
end })


bat_icon = wibox.widget.imagebox()
bat_icon:set_image("/home/alan/.config/awesome/themes/custom/battery.png")
bat_level = wibox.widget.textbox()


bat_widget = {bat_icon, bat_level}
update_bat_widget(bat_level, bat_status)

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
cpu_use_text = wibox.widget.textbox()
cpu_temp_text = wibox.widget.textbox()
--cpu_use_bar = wibox.widget.progressbar()
--cpu_use_widget = {
--        cpu_use_bar,
--        {cpu_use_text, cpu_temp_text, layout=wibox.layout.fixed.horizontal},
--        layout = wibox.layout.stack
--        }

function handle_mpstat_output(stdout)
    if string.find(stdout, "all") then
        local idle = tonumber(splitstr(stdout)[12])
        local busy = 100 - idle
        cpu_use_text:set_markup(math.floor(busy+0.5).."%")
        --cpu_use_bar:set_value(busy/100)
    end
end

awful.spawn.with_line_callback('mpstat 3', {stdout = handle_mpstat_output})
        
-- Check CPU temp.  Relies on "cputemp" which is a short script to output CPU temp in a format like "41.2°C"
awful.widget.watch('cputemp', 5,
		function(w, s)
			-- strip spaces and newline from output of cputemp
			w:set_markup_silently('('..string.gsub(s, "%s*\n", "")..')') 
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
netwidget = wibox.widget.textbox()
vicious.register(netwidget, vicious.widgets.net, "<b>NET:</b> ${wlan0 up_kb} KB ↑ ${wlan0 down_kb} KB ↓")
-- }}}

-- {{{ Hard drive usage textbox
hdwidget = wibox.widget.textbox()
vicious.register(hdwidget, vicious.widgets.fs, "<b>nvme0:</b> ${/ used_gb} GB / ${/ size_gb} GB <b>nvme1:</b> ${/mnt/storage used_gb} GB / ${/mnt/storage size_gb} GB")
-- }}}

-- {{{ Pending upgrades textbox
udwidget = wibox.widget.textbox()
vicious.register(udwidget, vicious.widgets.pkg, "<b>UPDATES:</b> $1", 300, "Arch")
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
