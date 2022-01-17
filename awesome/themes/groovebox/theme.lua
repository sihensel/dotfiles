--[[

     My theme for awesome, called Groovebox
     github.com/shensel/dotfiles
     gruvbox color scheme: github.com/morhetz/gruvbox

--]]

local gears = require("gears")
local lain  = require("lain")   -- https://github.com/lcpz/lainhttps://github.com/lcpz/lain
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi

local os, string, math = os, string, math
local my_table = awful.util.table or gears.table

-- define colors here
local colors = {
    {
        -- Groovebox
        bg          = '#1d2021',
        fg          = '#fbf1c7',
        red         = '#fb4934',
        red_dark    = '#cc241d',
        green       = '#b8bb26',
        green_dark  = '#98971a',
        yellow      = '#fabd2f',
        yellow_dark = '#d79921',
        blue        = '#83a598',
        blue_dark   = '#458588',
        purple      = '#d3869b',
        purple_dark = '#b16286',
        aqua        = '#8ec07c',
        aqua_dark   = '#689d6a',
        orange      = '#fe8019',
        orange_dark = '#d65d0e',
        arch        = '#1793d1'
    },
    {
        -- Groovebox light
        bg          = '#fbf1c7',
        fg          = '#3c3836',
        red         = '#cc241d',
        red_dark    = '#9d0006',
        green       = '#98971a',
        green_dark  = '#79740e',
        yellow_dark = '#b57614',
        yellow      = '#d79921',
        blue_dark   = '#076678',
        blue        = '#458588',
        purple_dark = '#8f3f71',
        purple      = '#b16286',
        aqua_dark   = '#427b58',
        aqua        = '#689d6a',
        orange_dark = '#af3a03',
        orange      = '#d65d0e',
        arch        = '#1793d1'
    },
    {
        -- Spacewave (WIP)
        bg          = '#070819',
        fg          = '#f8f5e9',
        red         = '#ef3a2a',
        red_dark    = '#d5152f',
        green       = '#6aff5a',
        green_dark  = '#3ade48',
        yellow      = '#ffcf3a',
        yellow_dark = '#ffbd25',
        blue        = '#3dc0ed',
        blue_dark   = '#2d34c5',
        purple      = '#df299a',
        purple_dark = '#801580',
        aqua        = '#80e1bd',
        aqua_dark   = '#34bfa4',
        orange      = '#ff9f00',
        orange_dark = '#ef6c26',
        arch        = '#1793d1'
    }
}

local themes = {'groovebox', 'spacewave'}
local theme_name = themes[1]

local theme                                     = {}
theme.walldir                                   = os.getenv("HOME") .. "/wallpapers"
theme.confdir                                   = os.getenv("HOME") .. "/.config/awesome"
theme.wallpaper                                 = theme.walldir .. '/wall.jpg'

if theme_name == 'groovebox' then
    colors = colors[1]
elseif theme_name == 'spacewave' then
    colors = colors[3]
end

-- Icon Font https://www.nerdfonts.com/cheat-sheet
theme.font                                      = "Roboto Mono Nerd Font 9.5"
theme.bg_normal                                 = colors.bg
theme.bg_focus                                  = colors.bg
theme.bg_urgent                                 = colors.bg
theme.bg_systray                                = theme.bg_normal
theme.fg_normal                                 = colors.fg
theme.fg_focus                                  = colors.orange
theme.fg_urgent                                 = colors.red_dark

theme.border_width                              = dpi(2)
theme.border_normal                             = colors.bg
theme.border_focus                              = colors.orange
theme.border_marked                             = colors.red

theme.taglist_font                              = theme.font
theme.taglist_bg_normal                         = theme.bg_normal
theme.taglist_fg_empty                          = theme.fg_normal
theme.taglist_fg_focus                          = theme.fg_focus
theme.taglist_fg_occupied                       = colors.blue_dark

theme.useless_gap                               = dpi(8)
theme.systray_icon_spacing                      = 5

local markup = lain.util.markup

-- Textclock
os.setlocale(os.getenv("LANG")) -- to localize the clock
local textclock = wibox.widget.textclock(markup(colors.orange, " %A %d %B  %H:%M  "))
textclock.font = theme.font

-- Calendar
theme.cal = lain.widget.cal({
    followtag = true,
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
    followtag = true,
    city_id = 2832939,
    notification_preset = {
        font = theme.font,
        fg = theme.fg_normal,
        bg = theme.bg_normal,
        margin = 5
    },
    weather_na_markup = markup.fontfg(theme.font, colors.green_dark, "N/A "),

    settings = function()
        descr = weather_now["weather"][1]["description"]:lower()
        units = math.floor(weather_now["main"]["temp"])
        widget:set_markup(markup.fontfg(theme.font, colors.green_dark, '  ' .. descr .. " " .. units .. "°C"))
    end
})

-- CPU
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, colors.aqua_dark, "礪 " .. cpu_now.usage .. "%"))
    end
})

-- Sysload
local sysload = lain.widget.sysload({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, colors.orange_dark, "﬘ " .. load_1 .. '%'))
    end
})

-- Coretemp
local temp = lain.widget.temp({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, colors.blue, ' ' .. coretemp_now .. "°C"))
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
        widget:set_markup(markup.fontfg(theme.font, colors.yellow_dark, perc))

        bat_notification_charged_preset = {
            title = 'Battery full',
            text = 'You can unplug the cable',
            font = theme.font,
            fg = theme.fg_normal,
            bg = theme.bg_normal,
            timeout = 300
        }
        bat_notification_low_preset = {
            title = 'Battery low',
            text = 'Plug the cable',
            font = theme.font,
            fg = theme.fg_normal,
            bg = theme.bg_normal,
            timeout = 180
        }
        bat_notification_critical_preset = {
            title = 'Battery exhausted',
            text = 'Plug the cable now!',
            font = theme.font,
            fg = theme.fg_normal,
            bg = theme.bg_normal,
            timeout = 15
        }
    end
})


-- ALSA volume
theme.volume = lain.widget.alsa({
    settings = function()
        if volume_now.status == "off" then
            widget:set_markup(markup.fontfg(theme.font, colors.blue_dark, " " .. volume_now.level .. "%"))
        else
            widget:set_markup(markup.fontfg(theme.font, colors.blue_dark, " " .. volume_now.level .. "%"))
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
    followtag = true,
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, colors.aqua, ' ' .. math.ceil(fs_now['/'].used) .. ' ' .. fs_now['/'].units))
    end,
    notification_preset = {
        font = theme.font,
        fg = theme.fg_normal,
        bg = theme.bg_normal,
        margin = 7
    }
})

-- MOC
local moc_widget = lain.widget.contrib.moc({
    default_art = theme.confdir .. "/lain/icons/music.png",
    cover_size = 75,
    timeout = 1,
    settings = function ()
        if moc_now.state == 'PLAY' then
            -- cut off the file path and extension (.mp3 etc)
            music_file = string.sub(moc_now.file:gsub('.*/', ''), 0,  -5)
            widget:set_markup(markup.fontfg(theme.font, colors.purple_dark, ' ' .. music_file))
        elseif moc_now.state == 'PAUSE' then
            widget:set_markup(markup.fontfg(theme.font, colors.purple_dark, ' '))
        else
            widget:set_markup(markup.fontfg(theme.font, colors.purple_dark, ' '))
        end

        moc_notification_preset = {
            title = ' Now Playing',
            text = string.format('%s | %s', music_file, moc_now.total),
            font = theme.font,
            fg = theme.fg_normal,
            bg = theme.bg_normal,
            margin = 7
        }
    end

})

-- First Icon (maybe add click-menu later)
local menu_widget = wibox.widget.textbox()
menu_widget.markup = '<span foreground="' .. colors.arch .. '">   </span>'
menu_widget.font = theme.font


-- Connect to screen
function theme.at_screen_connect(s)

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts)
    s.taglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Separators
    local spr= wibox.widget.textbox(" | ")
    spr.font = theme.font
    local first_spr= wibox.widget.textbox("| ")
    first_spr.font = theme.font
    
    -- Create the systray
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
        height = 30,
        bg = theme.bg_normal,
        fg = theme.fg_normal,
        border_width = 10,
        width = s.workarea.width - 35 - theme.border_width,
        ontop = false,
        x = screen[1].geometry.width / 2 - 150,
        y = 2,
        expand = true,
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
            sysload.widget,
            spr,
            temp.widget,
            spr,
            fs.widget,
            spr,
            bat.widget,
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
