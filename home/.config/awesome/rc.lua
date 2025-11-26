-- A heavily adapted version of the default config (found in
-- /etc/xdg/awesome/rc.lua) that ships with awesome (v4.3 from pacman).
require("awful.autofocus")
local awful = require("awful")
local beautiful = require("beautiful")
local common = require("awful.widget.common")
local gears = require("gears")
local naughty = require("naughty")
local wibox = require("wibox")

-- Handle runtime errors
local in_error = false
awesome.connect_signal("debug::error", function (err)
  -- Make sure we don't go into an endless error loop
  if in_error then return end
  in_error = true
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Error",
    text = tostring(err)
  })
  in_error = false
end)

awful.spawn.with_shell("picom &")
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

local terminal = "kitty"
local super = "Mod4"
local alt = "Mod1"
local ctrl = "Control"
local shift = "Shift"

-- Prevent clients from being unreachable after screen count changes.
client.connect_signal("manage", function (c)
  if awesome.startup
    and not c.size_hints.user_position
    and not c.size_hints.program_position then
      awful.placement.no_offscreen(c)
  end
end)

-- Focus a client when the mouse enters it.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

-- Update properties when a client is focused or unfocused.
client.connect_signal("focus",
  function(c)
    c.border_color = beautiful.border_focus
    c.screen.last_focus = c
  end
)
client.connect_signal("unfocus",
  function(c)
    c.border_color = beautiful.border_normal
  end
)

-- Each screen receives a widget that covers its entirety. This widget is used
-- to detect when the mouse enters the screen. This is used to track which
-- screen is consuming input.
for s in screen do
  s.overlay_widget = wibox {
    screen = s,
    visible = true,
    ontop = true,
    x = s.geometry.x,
    y = s.geometry.y,
    width = s.geometry.width,
    height = s.geometry.height,
    bg = "#00000000",
    input_passthrough = false,
    widget = wibox.widget.base.empty_widget(),
  }
end

for s in screen do
  s.focus_widget = wibox.widget {
    wibox.widget.base.empty_widget(),
    forced_width = 26,
    bg = beautiful.bg_unfocus,
    widget = wibox.container.background,
  }
end

local function focus_screen(new_focus_screen)
  for s in screen do
    if s == new_focus_screen then
      s.overlay_widget.input_passthrough = true
      s.focus_widget.bg = beautiful.bg_focus
    else
      s.overlay_widget.input_passthrough = false
      s.focus_widget.bg = beautiful.bg_unfocus
    end
  end
end

for s in screen do
  s.overlay_widget:connect_signal("mouse::enter", function()
    focus_screen(s)
  end)
end

-- Helper functions for finding, switching to, and switching clients to tags.
local function find_tag(tag_name)
  for s in screen do
    for _, screen_tag in ipairs(s.tags) do
      if screen_tag.name == tag_name then
        return screen_tag
      end
    end
  end
  return nil
end

local function focus_tag(tag_name)
  local tag = find_tag(tag_name)
  if not tag then return end
  tag:view_only()
  if awful.screen.focused() ~= tag.screen then
    awful.screen.focus(tag.screen)
  end
end

local function move_client_to_tag(tag_name)
  if not client.focus then return end
  local tag = find_tag(tag_name)
  if not tag then return end
  local focused_client = client.focus
  focused_client:move_to_tag(tag)
  focused_client:jump_to()
  client.focus = focused_client
end

-- The available tags that clients can exist within. The first tags are for the
-- primary monitor and the last three are for the secondary monitor.
local tag_names = {"h", "j", "k", "l", ";", "'"}
local primary_tags = {table.unpack(tag_names, 1, 3)}
local secondary_tags = {table.unpack(tag_names, 4, 6)}
awful.tag(primary_tags, screen[1], awful.layout.suit.fair)
awful.tag(secondary_tags, screen[2], awful.layout.suit.fair.horizontal)
focus_tag("k")

-- Create the widgets representing the different tags for each screen.
local taglist_buttons = gears.table.join(
  awful.button({}, 1, function(t) focus_tag(t.name) end),
  awful.button({super}, 1, function(t) move_client_to_tag(t.name) end)
)

for s in screen do
  s.taglist_widget = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = taglist_buttons,
    layout = {
      spacing = 3,
      layout = wibox.layout.fixed.horizontal
    },
    widget_template = {
      {
        {
          id = 'text_role',
          widget = wibox.widget.textbox,
        },
        left = 10,
        right = 10,
        widget = wibox.container.margin,
      },
      id = 'background_role',
      widget = wibox.container.background,
      create_callback = function(self, tag) tag.wibar_widget = self end,
    },
    update_function = function(w, buttons, label, data, tags, args)
      common.list_update(w, buttons, label, data, tags, args)
      for s_update in screen do
        for _, t in ipairs(s_update.tags) do
          if not t.wibar_widget then goto continue end
          t.wibar_widget.bg = beautiful.bg_contrast
          t.wibar_widget.fg = beautiful.fg_contrast
          if t.selected then
            if t.screen == awful.screen.focused() then
              t.wibar_widget.bg = beautiful.bg_focus
              t.wibar_widget.fg = beautiful.fg_focus
            else
              t.wibar_widget.bg = beautiful.bg_unfocus
              t.wibar_widget.fg = beautiful.fg_unfocus
            end
          end
          ::continue::
        end
      end
    end
  }
end

-- Create the widgets representing the different tasks on each screen.
local tasklist_buttons = gears.table.join(
  awful.button({}, 1, function (c)
    if c == client.focus then
      c.minimized = true
    else
      c:emit_signal(
        "request::activate",
        "tasklist",
        {raise = true}
      )
    end
  end)
)

for s in screen do
  s.tasklist_widget = awful.widget.tasklist {
    screen  = s,
    filter  = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons,
    layout = {
      spacing = 3,
      layout = wibox.layout.fixed.horizontal,
    },
    widget_template = {
      {
        {
          {
            {
              forced_width = 19,
              id = 'icon_role',
              widget = wibox.widget.imagebox,
            },
            top = 5,
            layout = wibox.container.margin,
          },
          {
            id = 'text_role',
            forced_width = 50,
            widget = wibox.widget.textbox,
          },
          layout = wibox.layout.fixed.horizontal,
        },
        left = 5,
        right = 7,
        widget = wibox.container.margin,
      },
      id = 'background_role',
      widget = wibox.container.background,
      create_callback = function(self, client) client.wibar_widget = self end,
    },
    update_function = function(w, buttons, label, data, clients, args)
      common.list_update(w, buttons, label, data, clients, args)
      for s_update in screen do
        for _, c in pairs(s_update.clients) do
          if not c.wibar_widget then
            goto continue
          end
          c.wibar_widget.bg = beautiful.bg_contrast
          c.wibar_widget.fg = beautiful.fg_contrast
          if c == client.focus then
            c.wibar_widget.bg = beautiful.bg_focus
            c.wibar_widget.fg = beautiful.fg_focus
          elseif s.last_focus and c == s.last_focus then
            c.wibar_widget.bg = beautiful.bg_unfocus
            c.wibar_widget.fg = beautiful.fg_unfocus
          end
          ::continue::
        end
      end
    end
  }
end

-- The widgets used for launching new programs.
for s in screen do
  s.promptbox = awful.widget.prompt()
end

-- Create the lock, sleep, hibernate, and poweroff buttons that will occupy
-- the system menu
local system_menu_icons = {"󰣧", "󱠇", "", ""}
local system_menu_widgets = {}
for _, icon in ipairs(system_menu_icons) do
  local widget = wibox.widget {
    {
      {
        font = "JetBrainsMono Nerd Font Mono 20",
        text = icon,
        widget = wibox.widget.textbox,
      },
      left = 7,
      widget = wibox.container.margin,
    },
    forced_height = 32,
    bg = beautiful.bg_contrast,
    fg = beautiful.fg_contrast,
    widget = wibox.container.background,
  }
  widget:connect_signal("mouse::enter", function()
    widget.bg = beautiful.bg_hover
    widget.fg = beautiful.fg_hover
  end)
  widget:connect_signal("mouse::leave", function()
    widget.bg = beautiful.bg_contrast
    widget.fg = beautiful.fg_contrast
  end)
  table.insert(system_menu_widgets, widget)
end

-- System menu widget that is displayed upon clicking the system widget
local system_menu_widget = awful.popup {
  widget = {
    system_menu_widgets[1],
    system_menu_widgets[2],
    system_menu_widgets[3],
    system_menu_widgets[4],
    forced_width = 30,
    spacing = 3,
    layout = wibox.layout.fixed.vertical,
  },
  visible = false,
  ontop = true,
  preferred_positions = 'bottom',
  preferred_anchors = 'middle',
  border_color = beautiful.border_focus,
  border_width = 2
}

-- The system widget for accessing the system menu
local system_widget = wibox.widget {
  {
    {
      font = "JetBrainsMono Nerd Font Mono 26",
      text = "󰣇",
      widget = wibox.widget.textbox,
    },
    left = 7,
    widget = wibox.container.margin,
  },
  forced_width = 34,
  bg = beautiful.bg_contrast,
  fg = beautiful.fg_contrast,
  widget = wibox.container.background,
}
system_widget:connect_signal("mouse::enter", function()
  if not system_menu_widget.visible then
    system_widget.bg = beautiful.bg_hover
    system_widget.fg = beautiful.fg_hover
  end
end)
system_widget:connect_signal("mouse::leave", function()
  if not system_menu_widget.visible then
    system_widget.bg = beautiful.bg_contrast
    system_widget.fg = beautiful.fg_contrast
  end
end)
system_widget:connect_signal("button::press", function(_, _, _, _, _, geometry)
  system_menu_widget.visible = not system_menu_widget.visible
  if system_menu_widget.visible then
    system_widget.bg = beautiful.bg_focus
    system_widget.fg = beautiful.fg_focus
    awful.placement.next_to(system_menu_widget, {
      preferred_positions = "bottom",
      preferred_anchors = "front",
      geometry = geometry,
    })
  else
    system_widget.bg = beautiful.bg_hover
    system_widget.fg = beautiful.fg_hover
  end
end)

-- Each system menu button triggers a different command
local function close_system_menu()
  system_widget.bg = beautiful.bg_contrast
  system_widget.fg = beautiful.fg_contrast
  system_menu_widget.visible = false
end

system_menu_widgets[1]:connect_signal("button::press", function()
  close_system_menu()
end)
system_menu_widgets[2]:connect_signal("button::press", function()
  close_system_menu()
  awful.spawn("systemctl suspend")
end)
system_menu_widgets[3]:connect_signal("button::press", function()
  close_system_menu()
  awful.spawn("systemctl hibernate")
end)
system_menu_widgets[4]:connect_signal("button::press", function()
  close_system_menu()
  awful.spawn("poweroff")
end)

-- Widget for displaying the time.
local clock_widget = wibox.widget {
  {
    {
      refresh = 1,
      format = "%y/%m/%d-%H:%M:%S",
      widget = wibox.widget.textclock,
    },
    left = 8,
    right = 10,
    widget = wibox.container.margin,
  },
  bg = beautiful.bg_contrast,
  fg = beautiful.fg_contrast,
  widget = wibox.container.background,
}

-- Create the wibars for both monitors.
for s in screen do
  s.wibar = awful.wibar({
    position = "top",
    screen = s,
    height = 30,
    bg = beautiful.bg_normal
  })
end

screen[1].wibar:setup {
  {
    system_widget,
    clock_widget,
    spacing = 3,
    layout = wibox.layout.fixed.horizontal,
  },
  nil,
  {
    screen[1].promptbox,
    screen[1].tasklist_widget,
    screen[1].taglist_widget,
    screen[1].focus_widget,
    spacing = 3,
    layout = wibox.layout.fixed.horizontal,
  },
  layout = wibox.layout.align.horizontal,
}

screen[2].wibar:setup {
  {
    screen[2].focus_widget,
    screen[2].taglist_widget,
    screen[2].tasklist_widget,
    screen[2].promptbox,
    spacing = 3,
    layout = wibox.layout.fixed.horizontal,
  },
  nil,
  nil,
  layout = wibox.layout.align.horizontal,
}

-- Set the screen wallpapers and updatedate the wallpapers anytime a screen
-- geometry is fired.
local function set_wallpaper(s)
  if s.index == 1 then
    gears.wallpaper.maximized(beautiful.wallpaper_horizontal, s, true)
  elseif s.index == 2 then
    gears.wallpaper.maximized(beautiful.wallpaper_vertical, s, true)
  end
end
for s in screen do
  set_wallpaper(s)
end
screen.connect_signal("property::geometry", set_wallpaper)

-- Keybinds
local globalkeys = gears.table.join(
  -- Move through clients by index or switch monitors
  awful.key({super}, "j",
    function() awful.client.focus.byidx(1) end,
    {description = "focus next by index", group = "client"}),
  awful.key({super}, "k",
    function() awful.client.focus.byidx(-1) end,
    {description = "focus previous by index", group = "client"}),
  awful.key({super}, "h",
    function() awful.screen.focus_relative(-1) end,
    {description = "focus the previous screen", group = "screen"}),
  awful.key({super}, "l",
    function() awful.screen.focus_relative(1) end,
    {description = "focus the next screen", group = "screen"}),

  -- Swap clients by index or move clients to the other monitor
  awful.key({super}, "5",
    function() awful.client.swap.byidx(1) end,
    {description = "swap with next client by index", group = "client"}),
  awful.key({super}, "6",
    function() awful.client.swap.byidx(-1) end,
    {description = "swap with previous client by index", group = "client"}),
  awful.key({super, shift}, "0",
    function() client.focus:move_to_screen() end,
    {description = "move to left screen", group = "client"}),
  awful.key({super}, "7",
    function() client.focus:move_to_screen() end,
    {description = "move to right screen", group = "client"}),

  -- Move to and from clients using relative positions.
  awful.key({super, alt}, "j",
    function() awful.client.focus.bydirection("down") end,
    {description = "focus down", group = "client"}),
  awful.key({super, alt}, "k",
    function() awful.client.focus.bydirection("up") end,
    {description = "focus up", group = "client"}),
  awful.key({super, alt}, "h",
    function() awful.client.focus.bydirection("left") end,
    {description = "focus left", group = "screen"}),
  awful.key({super, alt}, "l",
    function() awful.client.focus.bydirection("right") end,
    {description = "focus right", group = "screen"}),

  -- Swap clients using relative positions.
  awful.key({super, alt}, "5",
    function() awful.client.swap.bydirection("down") end,
    {description = "swap down", group = "client"}),
  awful.key({super, alt}, "6",
    function() awful.client.swap.bydirection("up") end,
    {description = "swap up", group = "client"}),
  awful.key({super, alt, shift}, "0",
    function() awful.client.swap.bydirection("left") end,
    {description = "swap left", group = "screen"}),
  awful.key({super, alt}, "7",
    function() awful.client.swap.bydirection("right") end,
    {description = "swap right", group = "screen"}),

  -- Start programs, restart awesome, and remove notifications.
  awful.key({super}, "r",
    function () awful.screen.focused().promptbox:run() end,
    {description = "run prompt", group = "launcher"}),
  awful.key({super}, "t",
    function() awful.spawn(terminal) end,
    {description = "open a terminal", group = "launcher"}),
  awful.key({super}, "s",
    function() awful.spawn("flameshot gui") end,
    {description = "create a screenshot", group = "launcher"}),
  awful.key({super}, "n",
    function() naughty.destroy_all_notifications() end,
    {description = "create a screenshot", group = "launcher"}),
  awful.key({super, ctrl}, "r",
    awesome.restart,
    {description = "reload awesome", group = "awesome"})
)

-- Keybinds for switching and moving clients between tags
for _, tag_name in ipairs(tag_names) do
  globalkeys = gears.table.join(globalkeys,
    awful.key({super, ctrl}, tag_name,
      function() focus_tag(tag_name) end,
      {description = "switch to tag " .. tag_name, group = "tag"}
    )
  )
end

globalkeys = gears.table.join(globalkeys,
  awful.key({super, ctrl, "Shift"}, "0",
    function() move_client_to_tag("h") end,
    {description = "move client to tag h", group = "tag"}
  ),
  awful.key({super, ctrl}, "5",
    function() move_client_to_tag("j") end,
    {description = "move client to tag j", group = "tag"}
  ),
  awful.key({super, ctrl}, "6",
    function() move_client_to_tag("k") end,
    {description = "move client to tag k", group = "tag"}
  ),
  awful.key({super, ctrl}, "7",
    function() move_client_to_tag("l") end,
    {description = "move client to tag l", group = "tag"}
  ),
  awful.key({super, ctrl}, "8",
    function() move_client_to_tag(";") end,
    {description = "move client to tag ;", group = "tag"}
  ),
  awful.key({super, ctrl}, "9",
    function() move_client_to_tag("'") end,
    {description = "move client to tag '", group = "tag"}
  )
)

root.keys(globalkeys)

-- Keybinds for controlling client windows.
local clientkeys = gears.table.join(
  awful.key({super}, "x",
    function(c) c:kill() end,
    {description = "close", group = "client"}),
  awful.key({super}, "c",
    function(c) c.minimized = true end,
    {description = "minimize", group = "client"}),
  awful.key({super}, "v",
    function(c)
      if c.maximized == false then
        c.floating = false
        c.maximized = true
      else
        c.maximized = false
      end
      c.border_width = beautiful.border_width
    end,
    {description = "maximize", group = "client"}),
  awful.key({super}, "f",
    function(c)
      if c.floating == false then
        c.maximized = false
        c.floating = true
      else
        c.floating = false
      end
      c.border_width = beautiful.border_width
    end,
    {description = "toggle floating", group = "client"})
)

-- Mouse controls for moving and resizing floating clients.
local clientbuttons = gears.table.join(
  awful.button({super}, 1,
    function (c)
      c:emit_signal("request::activate", "mouse_click", {raise = true})
      awful.mouse.client.move(c)
    end),
  awful.button({super}, 3,
    function (c)
      c:emit_signal("request::activate", "mouse_click", {raise = true})
      awful.mouse.client.resize(c)
    end)
)

-- The properties set for clients when they are created.
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap+awful.placement.no_offscreen,
      titlebars_enabled = false,
      maximized = true,
      floating = false,
    }
  },
}

