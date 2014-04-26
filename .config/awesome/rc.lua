require("awful")
require("awful.autofocus")
require("awful.rules")
require("wibox")
require("beautiful")
require("lfs")

host = io.open('/etc/hosts','r'):read('*all'):match('localhost (%w+)')
config_path = awful.util.getdir('config') .. '/'

dofile(config_path .. 'rc.' .. host)

beautiful.init(config_path .. 'theme.lua')

modkey = "Mod4"
terminal = "urxvt"

xdg_config = os.getenv('XDG_CONFIG_HOME') or os.getenv('HOME') .. '/.config'

tags = {}
for s = 1, screen.count() do
  tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, awful.layout.suit.tile)
end

mytextclock = awful.widget.textclock()

mywibox = {}
mypromptbox = {}
mytaglist = {}

mytasklist = {}

for s = 1, screen.count() do
  mypromptbox[s] = awful.widget.prompt()
  mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)
  mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)
  mywibox[s] = awful.wibox({ position = "top", screen = s })

  local left_layout = wibox.layout.fixed.horizontal()
  left_layout:add(mytaglist[s])
  left_layout:add(mypromptbox[s])

  local right_layout = wibox.layout.fixed.horizontal()
  if s == screen.count() then
    right_layout:add(wibox.widget.systray())
    right_layout:add(mytextclock)
  end

  local layout = wibox.layout.align.horizontal()
  layout:set_left(left_layout)
  layout:set_middle(mytasklist[s])
  layout:set_right(right_layout)

  mywibox[s]:set_widget(layout)
end

dbus_exec = "/usr/bin/dbus-send --system --print-reply --type=method_call --dest="

-- Power control menu
powermenu = awful.menu({
  items = {
    { "Shutdown" , dbus_exec .. "org.freedesktop.ConsoleKit /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Stop"   },
    { "Restart"  , dbus_exec .. "org.freedesktop.ConsoleKit /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Restart"},
    { "Suspend"  , dbus_exec .. "org.freedesktop.UPower /org/freedesktop/UPower org.freedesktop.UPower.Suspend"                            },
    { "Hibernate", dbus_exec .. "org.freedesktop.UPower /org/freedesktop/UPower org.freedesktop.UPower.Hibernate"                          },
    { "Log off"  , awesome.quit    },
    { "Reload"   , awesome.restart }
  }
})

amixer_exec = "/usr/bin/amixer -q sset Master "

globalkeys = awful.util.table.join(
  awful.key({modkey,          }, "Left"                , awful.tag.viewprev       ),
  awful.key({modkey,          }, "Right"               , awful.tag.viewnext       ),
  awful.key({modkey,          }, "Escape"              , awful.tag.history.restore),
  awful.key({                 }, "XF86AudioRaiseVolume", function () awful.util.spawn(amixer_exec .. "5%+"   ) end),
  awful.key({                 }, "XF86AudioLowerVolume", function () awful.util.spawn(amixer_exec .. "5%-"   ) end),
  awful.key({                 }, "XF86AudioMute"       , function () awful.util.spawn(amixer_exec .. "toggle") end),
  awful.key({modkey           }, "Tab"                 , function () awful.client.focus.byidx(1)  end),
  awful.key({modkey, "Control"}, "Tab"                 , function () awful.screen.focus_relative(1) end),
  awful.key({modkey,          }, "Return"              , function () awful.util.spawn(terminal) end),
  awful.key({modkey, "Shift"  }, "Return"              , function () awful.util.spawn("sudo -E " .. terminal) end),
  awful.key({modkey, "Control"}, "Return"              , function () awful.util.spawn(terminal .. " -e /usr/bin/python2") end),
  awful.key({modkey,          }, "l"                   , function () awful.tag.incmwfact( 0.05) end),
  awful.key({modkey,          }, "h"                   , function () awful.tag.incmwfact(-0.05) end),
  awful.key({modkey, "Shift"  }, "h"                   , function () awful.tag.incnmaster( 1) end),
  awful.key({modkey, "Shift"  }, "l"                   , function () awful.tag.incnmaster(-1) end),
  awful.key({modkey, "Control"}, "h"                   , function () awful.tag.incncol( 1) end),
  awful.key({modkey, "Control"}, "l"                   , function () awful.tag.incncol(-1) end),
  awful.key({modkey, "Control"}, "n"                   , awful.client.restore),
  awful.key({modkey           }, "r"                   , function () mypromptbox[mouse.screen]:run() end),
  awful.key({                 }, pm_key                , function () powermenu:toggle({ keygrabber = true, coords = { x = 0, y = 0 }}) end)
)

clientkeys = awful.util.table.join(
  awful.key({modkey,           }, "f"     , function (c) c.fullscreen = not c.fullscreen  end),
  awful.key({modkey, "Shift"   }, "c"     , function (c) c:kill() end),
  awful.key({modkey, "Control" }, "space" , awful.client.floating.toggle),
  awful.key({modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
  awful.key({modkey,           }, "o"     , awful.client.movetoscreen                        ),
  awful.key({modkey,           }, "t"     , function (c) c.ontop = not c.ontop            end),
  awful.key({modkey,           }, "n"     , function (c) c.minimized = true end)
)

keynumber = 0
for s = 1, screen.count() do
  keynumber = math.min(9, math.max(#tags[s], keynumber));
end

for i = 1, keynumber do
  globalkeys = awful.util.table.join(globalkeys,
    awful.key({ modkey }, "#" .. i + 9,
      function ()
        local screen = mouse.screen
        if tags[screen][i] then
          awful.tag.viewonly(tags[screen][i])
        end
      end),
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
      function ()
        if client.focus and tags[client.focus.screen][i] then
          awful.client.movetotag(tags[client.focus.screen][i])
        end
      end))
end

clientbuttons = awful.util.table.join(
  awful.button({ modkey }, 1, awful.mouse.client.move),
  awful.button({ modkey }, 3, awful.mouse.client.resize)
)

root.keys(globalkeys)

awful.rules.rules = {
  -- General
  { rule = { },
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_color,
      focus = true,
      keys = clientkeys,
      buttons = clientbuttons,
      size_hints_honor = false } },
  -- Eclipse
  { rule = {
      class = "Eclipse" },
    except_any = {
      name = {"(.*) - Eclipse SDK "} },
    properties = {
      floating = true } }
}

client.connect_signal("manage", function (c, startup)
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

function autostart(file)
  local f = io.open(file, 'r')

  if f ~= nil then
    context = f:read('*all')
  
    local value = function (key)
      return context:match('\n' .. key .. '=([^\n]+)')
    end

    local name = value('Name') or 'N/A'
    local exec = value('Exec')

    if exec ~= nil then
      -- Assume false
      local startup = value('StartupNotify') or 'false'

      if startup:lower() == 'false' then
        startup = false
      else
        startup = true
      end

      local hidden = value('Hidden') or 'false'

      if hidden:lower() == 'false' then
        print('Autostarting ' .. name .. ' (' .. exec .. ') ')
        awful.util.spawn(exec, startup)
      end
    end

    f:close()
  end
end

autostart_path = xdg_config .. '/autostart/'

for file in lfs.dir(autostart_path) do
  if file:sub(0,1) ~= '.' then
    autostart(autostart_path .. file)
  end
end
