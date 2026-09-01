local wezterm = require("wezterm")
local theme = require("lua.theme")
local p = theme.palette

local M = {}

function M.apply(config)
	----------------------------------------------------------------- tipografia
	config.font = wezterm.font_with_fallback({
		{ family = "JetBrainsMono Nerd Font", weight = "Regular" },
		{ family = "Symbols Nerd Font Mono", scale = 0.9 },
		"DejaVu Sans Mono",
	})
	config.font_size = 13.5
	config.line_height = 1.15
	config.cell_width = 1.0
	config.freetype_load_target = "Light"
	config.freetype_render_target = "HorizontalLcd"
	config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }

	config.font_rules = {
		{
			intensity = "Bold",
			italic = false,
			font = wezterm.font({ family = "JetBrainsMono Nerd Font", weight = "Bold" }),
		},
		{
			italic = true,
			intensity = "Normal",
			font = wezterm.font({ family = "JetBrainsMono Nerd Font", style = "Italic" }),
		},
	}

	------------------------------------------------------------------ cores
	config.colors = theme.colors
	config.bold_brightens_ansi_colors = true

	-- profundidade sutil: gradiente vertical quase imperceptível
	config.window_background_gradient = {
		orientation = { Linear = { angle = -90.0 } },
		colors = { p.bg_deep, p.bg, "#04060a" },
		interpolation = "Linear",
		blend = "Rgb",
		noise = 24,
	}
	config.window_background_opacity = 1.0
	config.text_background_opacity = 1.0

	------------------------------------------------------------------ janela
	config.window_decorations = "RESIZE"
	config.window_padding = { left = 14, right = 12, top = 10, bottom = 8 }
	config.initial_cols = 120
	config.initial_rows = 32
	config.adjust_window_size_when_changing_font_size = false
	config.window_close_confirmation = "AlwaysPrompt"
	config.skip_close_confirmation_for_processes_named = {
		"bash", "sh", "zsh", "fish", "tmux", "nu", "cmd.exe",
	}

	config.inactive_pane_hsb = {
		saturation = 0.82,
		brightness = 0.68,
	}

	------------------------------------------------------------------ cursor
	config.default_cursor_style = "SteadyBlock"
	config.cursor_blink_rate = 0 -- 0 = nunca pisca, mesmo se o app pedir
	config.force_reverse_video_cursor = false

	------------------------------------------------------------ paleta/overlays
	config.command_palette_bg_color = p.surface
	config.command_palette_fg_color = p.fg
	config.command_palette_font_size = 13.0
	config.char_select_bg_color = p.surface
	config.char_select_fg_color = p.fg

	------------------------------------------------------------------ tab bar
	config.use_fancy_tab_bar = false
	config.tab_bar_at_bottom = false
	config.hide_tab_bar_if_only_one_tab = false
	config.show_new_tab_button_in_tab_bar = true
	config.tab_max_width = 32
	config.show_tab_index_in_tab_bar = false

	------------------------------------------------------------------ scroll
	config.scrollback_lines = 20000
	config.enable_scroll_bar = false

	---------------------------------------------------------------- desempenho
	config.max_fps = 120
	config.animation_fps = 60
	config.front_end = "OpenGL" -- troque para "WebGpu" se quiser o renderer novo
	config.prefer_egl = true

	------------------------------------------------------------------- diversos
	config.audible_bell = "Disabled"
	config.visual_bell = {
		fade_in_function = "EaseIn",
		fade_in_duration_ms = 90,
		fade_out_function = "EaseOut",
		fade_out_duration_ms = 90,
		target = "CursorColor",
	}
	config.enable_kitty_graphics = true
	config.use_ime = true
	config.warn_about_missing_glyphs = false
	config.check_for_updates = false
	config.default_cwd = wezterm.home_dir
end

return M
