--[[

     Multicolor Awesome WM theme 2.0
     github.com/lcpz

--]]

local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi

local string = string
local os = os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local theme                                     = {}
theme.confdir                                   = os.getenv("HOME") .. "/.config/awesome/themes/multicolor"
theme.walldir                                   = os.getenv("HOME") .. "/wallpapers"
theme.wallpaper                                 = theme.walldir .. "/wall.jpg"
theme.font                                      = "Roboto Mono 10"
theme.menu_bg_normal                            = "#000000"
theme.menu_bg_focus                             = "#000000"
theme.bg_normal                                 = "#1d202190"
theme.bg_focus                                  = "#00000080"
theme.bg_urgent                                 = "#00000080"
theme.tasklist_bg_focus                         = "#00000000"
theme.tasklist_bg_normal                        = "#00000000"
theme.taglist_bg_focus                          = "#00000000"
theme.taglist_bg_normal                         = "#00000000"
theme.fg_normal                                 = "#aaaaaa"
theme.fg_focus                                  = "#ff8c00"
theme.fg_urgent                                 = "#af1d18"
theme.fg_minimize                               = "#ffffff"
theme.border_width                              = dpi(2)
theme.border_normal                             = "#1c2022"
theme.border_focus                              = "#a94a02"
theme.border_marked                             = "#3ca4d8"
theme.menu_border_width                         = 0
theme.menu_width                                = dpi(130)
theme.menu_submenu_icon                         = theme.confdir .. "/icons/submenu.png"
theme.menu_fg_normal                            = "#aaaaaa"
theme.menu_fg_focus                             = "#ff8c00"
theme.menu_bg_normal                            = "#050505dd"
theme.menu_bg_focus                             = "#050505dd"

-- Icons
-- Not needed atm and therefore not working
--theme.widget_temp                               = theme.confdir .. "/icons/temp.png"
theme.widget_temp                               = "/home/simon/Downloads/temp.png"
--theme.widget_uptime                             = theme.confdir .. "/icons/ac.png"
theme.widget_uptime                             = "/home/simon/Downloads/power.png"
--theme.widget_cpu                                = theme.confdir .. "/icons/cpu.png"
theme.widget_cpu                                = '/home/simon/Downloads/cpu.png'
--theme.widget_weather                            = theme.confdir .. "/icons/dish.png"
theme.widget_weather                            = "/home/simon/Downloads/weather.png"
--theme.widget_mem                                = theme.confdir .. "/icons/mem.png"
theme.widget_mem                                = '/home/simon/Downloads/memory.png'
--theme.widget_netdown                            = theme.confdir .. "/icons/net_down.png"
theme.widget_netdown                            = "/home/simon/Downloads/netdown.png"
--theme.widget_netup                              = theme.confdir .. "/icons/net_up.png"
theme.widget_netup                              = "/home/simon/Downloads/netup.png"
--theme.widget_batt                               = theme.confdir .. "/icons/bat.png"
theme.widget_batt                               = "/home/simon/Downloads/battery.png"
--theme.widget_clock                              = theme.confdir .. "/icons/clock.png"
theme.widget_clock                              = "/home/simon/Downloads/clock.png"
--theme.widget_vol                                = theme.confdir .. "/icons/spkr.png"
theme.widget_vol                                = '/home/simon/Downloads/volume.png'
theme.taglist_squares_sel                       = theme.confdir .. "/icons/square_a.png"
theme.taglist_squares_unsel                     = theme.confdir .. "/icons/square_b.png"
theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = false
theme.useless_gap                               = 8

theme.systray_icon_spacing = 4

local markup = lain.util.markup
local separators = lain.util.separators

-- Textclock
os.setlocale(os.getenv("LANG")) -- to localize the clock
local clockcolor = '#f38019'
local clockicon = wibox.widget.imagebox(theme.widget_clock)
local mytextclock = wibox.widget.textclock(markup(theme.fg_normal, "%A %d %B ") .. markup(theme.fg_normal, "%H:%M"))
mytextclock.font = theme.font

-- Calendar
theme.cal = lain.widget.cal({
    attach_to = { mytextclock },
    notification_preset = {
        font = "Roboto Mono 10",
        fg   = theme.fg_normal,
        bg   = string.sub(theme.bg_normal, 1, 7)
    }
})

-- Weather
local weathercolor = '#b8bb26'
local weathericon = wibox.widget.imagebox(theme.widget_weather)
theme.weather = lain.widget.weather({
    city_id = 2832939, -- placeholder (London)
    notification_preset = { font = "Terminus 10", fg = theme.fg_normal, bg=string.sub(theme.bg_normal, 1, 7) },
    weather_na_markup = markup.fontfg(theme.font, "#eca4c4", "N/A "),
    settings = function()
        descr = weather_now["weather"][1]["description"]:lower()
        units = math.floor(weather_now["main"]["temp"])
        widget:set_markup(markup.fontfg(theme.font, theme.fg_normal, descr .. " @ " .. units .. "°C"))
    end
})

-- CPU
local cpucolor = '#fe8019'
local cpuicon = wibox.widget.imagebox(theme.widget_cpu)
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, theme.fg_normal, "cpu " .. cpu_now.usage .. "%"))
    end
})

-- Coretemp
local tempcolor = '#d3869b'
local tempicon = wibox.widget.imagebox(theme.widget_temp)
local temp = lain.widget.temp({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, theme.fg_normal, coretemp_now .. "°C"))
    end
})

-- Battery
local batcolor = '#fabd2f'
local baticon = wibox.widget.imagebox(theme.widget_batt)
local bat = lain.widget.bat({
    settings = function()
        local perc = bat_now.perc ~= "N/A" and bat_now.perc .. "%" or bat_now.perc

        if bat_now.ac_status == 1 then
            perc = perc .. " plug"
        end

        widget:set_markup(markup.fontfg(theme.font, theme.fg_normal, "bat " .. perc))
    end
})

-- ALSA volume
local volcolor = '#83a598'
local volicon = wibox.widget.imagebox(theme.widget_vol)
theme.volume = lain.widget.alsa({
    settings = function()
        if volume_now.status == "off" then
            volume_now.level = volume_now.level .. "M"
        end

        widget:set_markup(markup.fontfg(theme.font, theme.fg_normal, "vol " .. volume_now.level .. "%"))
    end
})

-- Net
local netdowncolor = '#b8bb26'
local netupcolor = '#fb4934'
local netdownicon = wibox.widget.imagebox(theme.widget_netdown)
local netdowninfo = wibox.widget.textbox()
local netupicon = wibox.widget.imagebox(theme.widget_netup)
local netupinfo = lain.widget.net({
    settings = function()
        if iface ~= "network off" and
           string.match(theme.weather.widget.text, "N/A")
        then
            theme.weather.update()
        end

        widget:set_markup(markup.fontfg(theme.font, theme.fg_normal, net_now.sent))
        netdowninfo:set_markup(markup.fontfg(theme.font, theme.fg_normal, net_now.received))
    end
})

-- MEM
local memcolor = '#fabd2f'
local memicon = wibox.widget.imagebox(theme.widget_mem)
local memory = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, theme.fg_normal, "mem " .. mem_now.used))
    end
})

function theme.at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons )

    local appsep= wibox.widget.textbox(" | ")
    appsep.font = "JetBrainsMono Nerd Font 10"
    --local spr = wibox.widget.textbox('     ')
    --local half_spr = wibox.widget.textbox('  ')
    
    --[[
    local arrow = separators.arrow_left
    function theme.powerline_rl(cr, width, height)
        local arrow_depth, offset = height/2, 0

        -- Avoid going out of the (potential) clip area
        if arrow_depth < 0 then
            width  =  width + 2*arrow_depth
            offset = -arrow_depth
        end

        cr:move_to(offset + arrow_depth         , 0        )
        cr:line_to(offset + width               , 0        )
        cr:line_to(offset + width - arrow_depth , height/2 )
        cr:line_to(offset + width               , height   )
        cr:line_to(offset + arrow_depth         , height   )
        cr:line_to(offset                       , height/2 )

        cr:close_path()
    end
    local function pl(widget, bgcolor, padding)
        return wibox.container.background(wibox.container.margin(widget, dpi(16), dpi(16)), bgcolor, theme.powerline_rl)
    end
    --]]
    
    local systray = wibox.widget.systray()
    local systray = wibox.widget {
        {
            {
                {
                    {
                        systray,
                        nil,
                        layout = wibox.layout.fixed.horizontal
                    },
                    margins = 0,
                    widget = wibox.container.margin
                },
                layout = wibox.layout.fixed.horizontal
            },
            bg = theme.bg_normal,
            --fg = theme.fg_normal,
            opacity = 0,
            widget = wibox.container.background
        },
        margins = 0,
        widget = wibox.container.margin
    }



    --[[
    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        screen = s,
        height = dpi(30),
        bg = '#00000000',
        fg = theme.fg_normal,
        border_width = 7,
        --border_color = '#ffffff',

        --strech = false,
        width = dpi(s.workarea.width-40-theme.border_width-5),
        ontop = true,
        x = screen[1].geometry.width / 2 - 150,
        y = 2,
        expand = true,
        screen = mouse.screen,
    })


    

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        --expand = 'none',
        --widget = wibox.container.background,
        --shape_border_width = 10,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            --wibox.widget.systray(), -- adjust bg color
            wibox.container.background(systray, '#00000000'),

            arrow(theme.bg_normal, netdowncolor),
            wibox.container.background(netdownicon, netdowncolor),
            wibox.container.background(netdowninfo, netdowncolor),

            arrow(netdowncolor, netupcolor),
            wibox.container.background(netupicon, netupcolor),
            netupinfo,  -- needs to be fixed

            arrow(netupcolor, memcolor),
            wibox.container.background(memicon, memcolor),
            wibox.container.background(memory.widget, memcolor),
            arrow(memcolor, cpucolor),
            wibox.container.background(cpuicon, cpucolor),
            wibox.container.background(cpu.widget, cpucolor),

            arrow(cpucolor, tempcolor),
            wibox.container.background(tempicon, tempcolor),
            wibox.container.background(temp.widget, tempcolor),

            arrow(tempcolor, volcolor),
            wibox.container.background(volicon, volcolor),
            wibox.container.background(theme.volume.widget, volcolor),

            arrow(volcolor, batcolor),
            wibox.container.background(baticon, batcolor),
            wibox.container.background(bat.widget, batcolor),

            arrow(batcolor, weathercolor),
            wibox.container.background(weathericon, weathercolor),
            wibox.container.background(theme.weather.widget, weathercolor),

            arrow(weathercolor, clockcolor),
            wibox.container.background(clockicon, clockcolor),
            wibox.container.background(mytextclock, clockcolor),
            --clockicon,
            --mytextclock,
        },
        top = 1,
        bottom = 1,
        widget = wibox.container.margin
    }
    awful.screen.padding(screen[s], {top=-12, left=0, right=0, bottom=0})
    --]]





    -- see https://github.com/nonamescm/dotfiles
	s.wibox_left = wibox {
		width = dpi(1920 / 5),
		height = dpi(36),
		ontop = false,
		screen = s,
		expand = true,
		visible = true,
		bg = theme.bg_normal,
		x = dpi(15),
		y = dpi(10),
		--border_width = dpi(2),
		--border_color = theme.bg_light,

	}
	s.wibox_left:setup {
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			{
				layout = wibox.layout.fixed.horizontal,
				{
					{
						layout = wibox.layout.align.horizontal,
						s.mypromptbox,
					},
					widget = wibox.container.background,
				},
				{
					{
						layout = wibox.layout.align.horizontal,
						s.mytaglist,
					},
					bg = theme.bg_light,
					widget = wibox.container.background,
				},
			},
			widget = wibox.container.margin,
			top = dpi(5),
			bottom = dpi(5),
			right = dpi(5),
			left = dpi(5)
		},
		{ -- Center widgets
			layout = wibox.layout.align.horizontal,
		},
	}



	s.wibox_right = wibox {
		width = dpi(1920 / 2),
		height = dpi(36),
		ontop = false,
		screen = s,
		expand = true,
		visible = true,
		bg = theme.bg_normal,
		x = dpi(1920 - 1920 / 2 - 17),
		y = dpi(10),
		--border_width = dpi(2),
		--border_color = theme.bg_light,
	}

	s.wibox_right:setup {
		layout = wibox.layout.align.horizontal,
		{ -- Right widgets
			{
				layout = wibox.layout.fixed.horizontal,
				{
					{
						layout = wibox.layout.fixed.horizontal,
						wibox.container.margin(
							--wibox.widget.systray(),
                            systray,
							dpi(3), dpi(3), dpi(3), dpi(3)
						),
					},
					bg = theme.bg_light,
					widget = wibox.container.background,
				},
                appsep,
				{
					{
						layout = wibox.layout.fixed.horizontal,
                        --netdownicon,
                        netdowninfo,
					},
					bg = theme.bg_light,
					widget = wibox.container.background,
				},
                appsep,
				{
					{
						layout = wibox.layout.fixed.horizontal,
                        --netupicon,
                        netupinfo,
					},
					bg = theme.bg_light,
					widget = wibox.container.background,
				},
                appsep,
				{
					{
						layout = wibox.layout.fixed.horizontal,
                        --memicon,
                        memory.widget,
					},
					bg = theme.bg_light,
					widget = wibox.container.background,
				},
                appsep,
				{
					{
						layout = wibox.layout.fixed.horizontal,
                        --cpuicon,
                        cpu,
					},
					bg = theme.bg_light,
					widget = wibox.container.background,
				},
                appsep,
				{
					{
						layout = wibox.layout.fixed.horizontal,
						--baticon,
						bat,
					},
					bg = theme.bg_light,
					widget = wibox.container.background,
				},
                appsep,
				{
					{
						layout = wibox.layout.fixed.horizontal,
						--volicon,
                        theme.volume.widget,
					},
					bg = theme.bg_light,
					widget = wibox.container.background,
				},
                appsep,
				{
					{
						layout = wibox.layout.fixed.horizontal,
						--weathericon,
						theme.weather.widget,
					},
					bg = theme.bg_light,
					widget = wibox.container.background,
				},
                appsep,
				{
					{
						layout = wibox.layout.fixed.horizontal,
						--clockicon,
						mytextclock,
					},
					bg = theme.bg_light,
					widget = wibox.container.background,
				},
			},
			widget = wibox.container.margin,
			top = dpi(5),
			bottom = dpi(5),
			right = dpi(5),
			left = dpi(5)
		},
	}

	s.wibox_left:struts {
		top = dpi(40),
	}

end

return theme
