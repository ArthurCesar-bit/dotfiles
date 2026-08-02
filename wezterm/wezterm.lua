local wezterm = require("wezterm")
local constants = require("constants")
local commands = require("commands")
local config = wezterm.config_builder()

-- Font settings
config.font_size = 14
config.line_height = 1.1
config.font = wezterm.font_with_fallback({
  "JetBrains Mono",
  { family = "Symbols Nerd Font Mono", scale = 0.9 },
})
config.freetype_load_flags = "NO_HINTING"

-- Colors
config.colors = {
	cursor_bg = "white",
	cursor_border = "white",
}

-- Appearance
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.window_background_image = constants.bg_image

-- Miscellaneous settings
config.max_fps = 120
config.prefer_egl = true

-- Custom commands
wezterm.on("augment-command-palette", function()
	return commands
end)

return config
