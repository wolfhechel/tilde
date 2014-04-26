----------------------------------------------
--       SelfIndulgance awesome theme       --
----------------------------------------------
-- Pontus Carlsson <PontusCarlsson@live.se> --
---- 24/08/2011                             --
----------------------------------------------

theme = {}

theme.font          = "sans 8"

theme.bg_normal     = "#222222"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.border_width  = 1
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

theme.taglist_squares_sel   = config_path .. "taglist/squarefw.png"
theme.taglist_squares_unsel = config_path .. "taglist/squarew.png"

theme.wallpaper_cmd = { "feh --no-xinerama --bg-scale " .. config_path .. host .. ".jpg" }

return theme
