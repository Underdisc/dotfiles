-- A modified version of the default theme (found in
-- /usr/share/awesome/themes/default/theme.lua).
local local_paths = require("local_paths")

-- A grayscale color palette used for all coloring.
-- Normal: Represents nothing
-- Contrast: Makes a widget stand out against the normal background
-- Unfocus: Visible but not receiving input
-- Focus: Visible and receiving input
local theme = {}
theme.bg_normal   = "#222222"
theme.fg_normal   = "#cccccc"
theme.bg_contrast = "#333333"
theme.fg_contrast = "#dddddd"
theme.bg_unfocus  = "#444444"
theme.fg_unfocus  = "#eeeeee"
theme.bg_hover    = "#444444"
theme.fg_hover    = "#ffffff"
theme.bg_focus    = "#cccccc"
theme.fg_focus    = "#222222"
theme.bg_minimize = "#111111"
theme.fg_minimize = "#bbbbbb"

-- Applications of the color palette and other theme settings.
theme.font = "JetBrainsMono Nerd Font Italic Bold 10"
theme.wallpaper_horizontal = local_paths.wallpaper_horizontal
theme.wallpaper_vertical = local_paths.wallpaper_vertical

theme.border_width  = 2
theme.border_normal = theme.bg_unfocus
theme.border_focus  = theme.bg_focus

theme.tasklist_bg_normal = theme.bg_contrast
theme.tasklist_fg_normal = theme.fg_contrast
theme.tasklist_bg_focus = theme.bg_focus
theme.tasklist_fg_focus = theme.fg_focus

theme.taglist_bg_occupied = theme.bg_contrast
theme.taglist_fg_occupied = theme.fg_contrast
theme.taglist_bg_empty    = theme.bg_contrast
theme.taglist_fg_empty    = theme.fg_contrast
theme.taglist_bg_focus    = theme.bg_focus
theme.taglist_fg_focus    = theme.fg_focus

return theme
