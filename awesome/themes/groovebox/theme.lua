--[[

     My theme for awesome, called Groovebox
     github.com/shensel/dotfiles
     gruvbox color scheme: github.com/morhetz/gruvbox

--]]

local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi

local os, string, math = os, string, math
local my_table = awful.util.table or gears.table

-- define colors here
local colors = {
    bg      = '#1d2021',
    red     = '#fb4934',
    green   = '#b8bb26',
    yellow  = '#fabd2f',
    blue    = '#83a598',
    purple  = '#d3869b',
    aqua    = '#8ec07c',
    orange  = '#fe8019',
    fg      = '#fbf1c7',
    arch    = '#1793d1'
}

-- Icon Font https://www.nerdfonts.com/cheat-sheet
local theme                                     = {}
theme.walldir                                   = os.getenv("HOME") .. "/wallpapers"
theme.wallpaper                                 = theme.walldir .. "/wall.jpg"
theme.font                                      = "Jetbrains Mono Nerd Font 9"
theme.bg_normal                                 = colors.bg
theme.bg_focus                                  = colors.bg
theme.bg_urgent                                 = colors.bg
theme.bg_systray                                = theme.bg_normal
theme.fg_normal                                 = colors.fg
theme.fg_focus                                  = colors.orange
theme.fg_urgent                                 = colors.red

theme.border_width                              = dpi(2)
theme.border_normal                             = colors.bg
theme.border_focus                              = colors.orange
theme.border_marked                             = colors.red

theme.taglist_font                              = theme.font
theme.taglist_bg_normal                         = theme.bg_normal
theme.taglist_fg_empty                          = theme.fg_normal
theme.taglist_fg_focus                          = theme.fg_focus
theme.taglist_fg_occupied                       = colors.aqua

theme.useless_gap                               = 8
theme.systray_icon_spacing                      = 4

local markup = lain.util.markup
local separators = lain.util.separators

-- Textclock
os.setlocale(os.getenv("LANG")) -- to localize the clock
local textclock = wibox.widget.textclock(markup(colors.orange, "  %A %d %B  %H:%M "))
textclock.font = theme.font

-- Calendar
theme.cal = lain.widget.cal({
    week_number = 'left',
    attach_to = { textclock },
    notification_preset = {
        font = theme.font,
        fg   = theme.fg_normal,
        bg   = theme.bg_normal,
        margin = 5
    }
})

-- Weather
theme.weather = lain.widget.weather({
    city_id = 2832939,
    notification_preset = {
        font = theme.font,
        fg = theme.fg_normal,
        bg = theme.bg_normal,
        margin = 5
    },
    weather_na_markup = markup.fontfg(theme.font, colors.green, "N/A "),
    settings = function()
        descr = weather_now["weather"][1]["description"]:lower()
        units = math.floor(weather_now["main"]["temp"])
        widget:set_markup(markup.fontfg(theme.font, colors.green, '  ' .. descr .. " @ " .. units .. "°C"))
    end
})

-- CPU
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, colors.orange, "礪 " .. cpu_now.usage .. "%"))
    end
})

-- Coretemp
local temp = lain.widget.temp({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, colors.purple, ' ' .. coretemp_now .. "°C"))
    end
})

-- Battery
local bat = lain.widget.bat({
    settings = function()
        local perc = bat_now.perc ~= "N/A" and bat_now.perc .. "%" or bat_now.perc

        if bat_now.ac_status == 1 then
            perc = ' ' .. perc
        else
            perc = ' ' .. perc
        end
        widget:set_markup(markup.fontfg(theme.font, colors.yellow, perc))
    end,
    bat_notification_charged_preset = {
        fg = theme.fg_normal,
        bg = theme.bg_normal
    },
    bat_notification_low_preset = {
        fg = theme.fg_normal,
        bg = theme.bg_normal
    },
    bat_notification_charged_preset = {
        fg = theme.fg_normal,
        bg = theme.bg_normal
    }
})


-- ALSA volume
theme.volume = lain.widget.alsa({
    settings = function()
        if volume_now.status == "off" then
            --volume_now.level = ' ' .. volume_now.level
            widget:set_markup(markup.fontfg(theme.font, colors.blue, " " .. volume_now.level .. "%"))
        else
            widget:set_markup(markup.fontfg(theme.font, colors.blue, " " .. volume_now.level .. "%"))

        end

    end
})

-- Net
local netdowninfo = wibox.widget.textbox()
local netupinfo = lain.widget.net({
    settings = function()
        if iface ~= "network off" and
           string.match(theme.weather.widget.text, "N/A")
        then
            theme.weather.update()
        end

        widget:set_markup(markup.fontfg(theme.font, colors.red, ' ' .. net_now.sent))
        netdowninfo:set_markup(markup.fontfg(theme.font, colors.green, ' ' .. net_now.received))
    end,
    notify = 'off'
})

-- MEM
local memory = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, colors.yellow, " " .. mem_now.used))
    end
})

-- Disk Usage
local fs = lain.widget.fs({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, colors.red, ' ' .. math.ceil(fs_now['/'].used) .. ' ' .. fs_now['/'].units))
    end,
    notification_preset = {
        font = theme.font,
        fg = theme.fg_normal,
        bg = theme.bg_normal,
        margin = 7
    }
})

-- Taskwarrior
local task_widget = wibox.widget.textbox()
task_widget.font = theme.font
task_widget.markup = '<span foreground="' .. colors.aqua .. '"> todo</span>'
lain.widget.contrib.task.attach(task_widget)

-- MOC
strlen = 19 -- length of '/home/simon/music/
local moc_widget = lain.widget.contrib.moc({
    music_dir = '~/music',
    settings = function () 
        if moc_now.state == 'PLAY' then
            widget:set_markup(markup.fontfg(theme.font, colors.aqua, ' ' .. string.sub(moc_now.file, 19, -5)))
        else
            widget:set_markup(markup.fontfg(theme.font, colors.aqua, ' '))
        end
        moc_notification_preset = {
            title = ' Now Playing',
            timeout = 3,
            text = string.format('%s - %s', string.sub(moc_now.file, strlen), moc_now.total),
            font = theme.font,
            fg = theme.fg_normal,
            bg = theme.bg_normal,
            margin = 7,
        }
    end

})

-- First Icon (maybe add click-menu later)
local menu_widget = wibox.widget.textbox()
menu_widget.markup = '<span foreground="' .. colors.arch .. '">  </span>'
menu_widget.font = theme.font

-- Connect to screen
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
    s.taglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- separators
    local spr= wibox.widget.textbox(" | ")
    spr.font = theme.font
    local first_spr= wibox.widget.textbox("| ")
    first_spr.font = theme.font
    
    -- create the systray
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
            widget = wibox.container.background
        },
        margins = 5,
        widget = wibox.container.margin
    }

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        screen = s,
        height = dpi(30),
        bg = theme.bg_normal,
        fg = theme.fg_normal,
        border_width = 10,

        width = dpi(s.workarea.width - dpi(30) - theme.border_width),
        ontop = false,
        x = screen[1].geometry.width / 2 - 150,
        y = 2,
        expand = true,
        screen = mouse.screen,
        opacity = 0.85
    })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        widget = wibox.container.background,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            menu_widget,
            spr,
            s.taglist,
        },
        { -- Middle Widgets
            layout = wibox.layout.fixed.horizontal,
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            systray,
            first_spr,
            netdowninfo,
            spr,
            netupinfo,
            spr,
            memory.widget,
            spr,
            cpu.widget,
            spr,
            temp.widget,
            spr,
            fs.widget,
            spr,
            bat.widget,
            spr,
            task_widget,
            spr,
            moc_widget,
            spr,
            theme.volume.widget,
            spr,
            theme.weather.widget,
            spr,
            textclock
        },
        top = 1,
        bottom = 1,
        widget = wibox.container.margin
    }
    awful.screen.padding(screen[s], {top=-12, left=0, right=0, bottom=0})
end

return theme
