-- Nocturne — paleta escura, contraste calibrado, sem neon berrante.
local M = {}

M.palette = {
	-- superfícies
	bg        = "#06080c", -- fundo principal (quase preto, com veio azul)
	bg_deep   = "#030407", -- gradiente / bordas
	surface   = "#0b0e14", -- tab bar, painéis inativos
	overlay   = "#151b27", -- seleção, hover
	border    = "#1b2230",

	-- texto
	fg        = "#c6cedb",
	fg_dim    = "#8b95a7",
	muted     = "#4d5768",

	-- acentos
	blue      = "#6cb6ff",
	cyan      = "#5ccfe6",
	green     = "#7fd88f",
	yellow    = "#ffcc66",
	orange    = "#ff9f5a",
	red       = "#ef6b73",
	purple    = "#c8a3ff",
	pink      = "#f38ba8",
}

local p = M.palette

M.colors = {
	foreground = p.fg,
	background = p.bg,

	cursor_bg = "#ffffff",
	cursor_fg = p.bg,
	cursor_border = "#ffffff",

	selection_bg = p.overlay,
	selection_fg = p.fg,

	scrollbar_thumb = p.border,
	split = p.border,

	ansi = {
		"#0d1017", -- black
		p.red,
		p.green,
		p.yellow,
		p.blue,
		p.purple,
		p.cyan,
		"#b9c1cc", -- white
	},
	brights = {
		"#333c49",
		"#ff8087",
		"#95e6a6",
		"#ffd580",
		"#8cc7ff",
		"#d6b7ff",
		"#7ce0f3",
		"#e6edf3",
	},

	indexed = {
		[16] = p.orange,
		[17] = p.pink,
	},

	compose_cursor = p.orange,
	copy_mode_active_highlight_bg = { Color = p.blue },
	copy_mode_active_highlight_fg = { Color = p.bg },
	copy_mode_inactive_highlight_bg = { Color = p.overlay },
	copy_mode_inactive_highlight_fg = { Color = p.fg },

	quick_select_label_bg = { Color = p.orange },
	quick_select_label_fg = { Color = p.bg },
	quick_select_match_bg = { Color = p.overlay },
	quick_select_match_fg = { Color = p.yellow },

	tab_bar = {
		background = p.bg_deep,
		active_tab = {
			bg_color = p.bg,
			fg_color = p.blue,
			intensity = "Bold",
		},
		inactive_tab = {
			bg_color = p.bg_deep,
			fg_color = p.muted,
		},
		inactive_tab_hover = {
			bg_color = p.surface,
			fg_color = p.fg_dim,
			italic = false,
		},
		new_tab = {
			bg_color = p.bg_deep,
			fg_color = p.muted,
		},
		new_tab_hover = {
			bg_color = p.surface,
			fg_color = p.cyan,
		},
	},
}

return M
