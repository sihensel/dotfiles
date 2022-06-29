--[[

    ########   ######      ##       ##     ##    ###
    ##     ## ##    ##     ##       ##     ##   ## ##
    ##     ## ##           ##       ##     ##  ##   ##
    ########  ##           ##       ##     ## ##     ##
    ##   ##   ##           ##       ##     ## #########
    ##    ##  ##    ## ### ##       ##     ## ##     ##
    ##     ##  ######  ### ########  #######  ##     ##


    Programs used in this config:
        - Alacritty
        - Rofi
        - slock
        - Flameshot
        - Brave
        - MOC
        - PCManFM
        - Marktext

    Based on Awesome Copycats: github.com/lcpz
    Maintainer:
        Simon Hensel
        https://github.com/sihensel/dotfiles
--]]

-- {{{ Required libraries
local awesome, client, screen = awesome, client, screen
local ipairs, string, os, table, tostring, type = ipairs, string, os, table, tostring, tonumber, type

local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local lain          = require("lain")
local hotkeys_popup = require("awful.hotkeys_popup").widget
                      require("awful.hotkeys_popup.keys")
local my_table      = awful.util.table or gears.table -- 4.{0,1} compatibility
local dpi           = require("beautiful.xresources").apply_dpi
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "An error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Autostart windowless processes
-- This function will run once every time Awesome is started
--[[
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end
--]]
-- }}}

-- {{{ Variable definitions
local theme        = "groovebox"
local modkey       = "Mod4"
local altkey       = "Mod1"
local terminal     = "alacritty"
local vi_focus     = false -- vi-like client focus - https://github.com/lcpz/awesome-copycats/issues/275

naughty.config.padding = dpi(10)    -- set padding for notifications
awful.util.terminal = terminal
-- icons from https://www.nerdfonts.com/cheat-sheet
awful.util.tagnames = { " ", " ", " ", " ", " ", " ", " ", " ", " " }
awful.layout.layouts = {
    awful.layout.suit.tile,
}

awful.util.taglist_buttons = my_table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), theme))
-- }}}

-- {{{ Screen
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

--[[
-- No borders when rearranging only 1 non-floating or maximized client
screen.connect_signal("arrange", function (s)
    local only_one = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        if only_one and not c.floating or c.maximized then
            c.border_width = 0
        else
            c.border_width = beautiful.border_width
        end
    end
end)
--]]

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
    beautiful.at_screen_connect(s)
end)
-- }}}


-- {{{ Create a wallpaper carousel
-- currently mapped to 'modkey + [' and 'modkey + ]')
local walldir = os.getenv("HOME") .. "/wallpapers"
local position = 1
local function set_wallpaper(direction)
    local directory = io.popen("ls " .. walldir)    -- read the <walldir> directory
    local wallpapers = {}                           -- table with all wallpaper (image) files

    if directory then
        for image in directory:lines() do
            -- check if the file is an image (png and jpg in this case)
            local file_ending = string.sub(image, -4)
            if file_ending == ".png" or file_ending == ".jpg" then
                table.insert(wallpapers, image)
            end
        end
    end

    if direction then
        position = position + 1
        if position > #wallpapers then
            position = 1    -- handle carry over
        end
    else
        position = position - 1
        if position == 0 then
            
            position = #wallpapers  -- handle carry over
        end
    end

    local next_wallpaper = wallpapers[position]
    if not next_wallpaper then
        -- dispay an error message
        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "There was an error setting the wallpaper",
                         text = "Make sure ~/wallpapers exists and contains image files" })
        return false
    end

    for s = 1, screen.count() do
        gears.wallpaper.maximized(walldir .. "/" .. next_wallpaper, s, true)
    end
end
-- }}}

-- {{{ Key bindings
Globalkeys = my_table.join(

    -- Hotkeys
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description = "show help", group="awesome"}),
    -- Tag browsing
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),

    -- Default client focus
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),

    -- Standard programs
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "awesome"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,    }, "l",     function () awful.tag.incmwfact( 0.05) end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,    }, "h",     function () awful.tag.incmwfact(-0.05) end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true) end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true) end,
              {description = "decrease the number of columns", group = "layout"}),

    -- Brightness, install the 'acpilight' package
    awful.key({ altkey }, "Up", function () os.execute("xbacklight -inc 5") end,
              {description = "+10%", group = "hotkeys"}),
    awful.key({ altkey }, "Down", function () os.execute("xbacklight -inc 5") end,
              {description = "-10%", group = "hotkeys"}),

    -- ALSA volume control
    awful.key({ modkey }, "Up",
        function ()
            os.execute(string.format("amixer -q set %s 3%%+", beautiful.volume.channel))
            beautiful.volume.update()
        end,
        {description = "volume up", group = "hotkeys"}),
    awful.key({ modkey }, "Down",
        function ()
            os.execute(string.format("amixer -q set %s 3%%-", beautiful.volume.channel))
            beautiful.volume.update()
        end,
        {description = "volume down", group = "hotkeys"}),
    awful.key({ modkey }, "m",
        function ()
            os.execute(string.format("amixer -D pulse set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel))
            beautiful.volume.update()
        end,
        {description = "toggle mute", group = "hotkeys"}),

    -- MOC control
    awful.key({ altkey }, "Left", function () os.execute("mocp -r") end,
        {description = "MOC previous song", group = "hotkeys" }),
    awful.key({ altkey }, "Right", function () os.execute("mocp -f") end,
        {description = "MOC next song", group = "hotkeys" }),

    -- Custom program shortcuts
    awful.key({ modkey }, "b", function () awful.spawn("brave") end,
              {description = "Brave", group = "custom"}),

    awful.key({ modkey, "Shift"  }, "b", function () awful.spawn("google-chrome-stable") end,
              {description = "Google Chrome", group = "custom"}),

    awful.key({ modkey }, "t", function () awful.spawn("marktext") end,
              {description = "Marktext", group = "custom"}),

    awful.key({ modkey }, "e", function () awful.spawn("pcmanfm") end,
              {description = "PCManFM", group = "custom"}),
    
    awful.key({ modkey }, "F11", function () awful.spawn("flameshot gui") end,
              {description = "Take Screenshot", group = "custom"}),
    
    awful.key({ modkey }, "F12", function () awful.spawn("slock") end,
              {description = "Lock Screen", group = "custom"}),
    
    --rofi
    awful.key({ modkey }, "space", function ()
            os.execute('rofi -show run')
        end,
        {description = "run rofi", group = "custom"}),

    awful.key({ modkey }, "[", function () set_wallpaper(false) end,
              {description = "Cycle wallpaper carousel up", group = "custom"}),

    awful.key({ modkey }, "]", function () set_wallpaper(true) end,
              {description = "Cycle wallpaper carousel down", group = "custom"})
)

clientkeys = my_table.join(
    awful.key({ modkey, "Shift"   }, "m",      lain.util.magnify_client,
              {description = "magnify client", group = "client"}),
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey,    }, "c",      function (c) c:kill() end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen() end,
              {description = "move to screen", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = {description = "view tag #", group = "tag"}
        descr_toggle = {description = "toggle tag #", group = "tag"}
        descr_move = {description = "move focused client to tag #", group = "tag"}
        descr_toggle_focus = {description = "toggle focused client on tag #", group = "tag"}
    end
    Globalkeys = my_table.join(Globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  descr_view),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  descr_toggle),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  descr_move)
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(Globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     size_hints_honor = false
     }
    }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = vi_focus})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Custom autostart programs
awful.spawn.with_shell("picom --experimental-backends")
awful.spawn.with_shell("nm-applet")
