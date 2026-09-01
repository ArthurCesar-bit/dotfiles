local wezterm = require("wezterm")
local theme = require("lua.theme")
local p = theme.palette
local nf = wezterm.nerdfonts

local M = {}

-- Acesso seguro a glifos: nomes do Nerd Font variam entre versoes do wezterm.
local function g(name, fallback)
	local v = nf[name]
	if v == nil or v == "" then
		return fallback or "*"
	end
	return v
end

-- Separadores powerline (meia-lua) — dão o formato de "pílula" nas abas.
local LEFT_EDGE = g("ple_left_half_circle_thick", "")
local RIGHT_EDGE = g("ple_right_half_circle_thick", "")

-- Ícone por processo em primeiro plano.
local ICON_FALLBACK = g("cod_circle_filled", g("md_circle_medium", "●"))

local ICONS = {
	["bash"] = g("cod_terminal_bash", ICON_FALLBACK),
	["sh"] = g("cod_terminal", ICON_FALLBACK),
	["zsh"] = g("dev_terminal", ICON_FALLBACK),
	["fish"] = g("md_fish", ICON_FALLBACK),
	["nvim"] = g("custom_vim", ICON_FALLBACK),
	["vim"] = g("custom_vim", ICON_FALLBACK),
	["vi"] = g("custom_vim", ICON_FALLBACK),
	["git"] = g("dev_git", ICON_FALLBACK),
	["lazygit"] = g("dev_git", ICON_FALLBACK),
	["node"] = g("md_nodejs", ICON_FALLBACK),
	["npm"] = g("md_npm", ICON_FALLBACK),
	["pnpm"] = g("md_npm", ICON_FALLBACK),
	["yarn"] = g("md_npm", ICON_FALLBACK),
	["bun"] = g("md_hamburger", ICON_FALLBACK),
	["deno"] = g("dev_javascript", ICON_FALLBACK),
	["python"] = g("md_language_python", ICON_FALLBACK),
	["python3"] = g("md_language_python", ICON_FALLBACK),
	["cargo"] = g("dev_rust", ICON_FALLBACK),
	["rustc"] = g("dev_rust", ICON_FALLBACK),
	["go"] = g("seti_go", ICON_FALLBACK),
	["docker"] = g("md_docker", ICON_FALLBACK),
	["kubectl"] = g("md_kubernetes", ICON_FALLBACK),
	["ssh"] = g("md_ssh", ICON_FALLBACK),
	["htop"] = g("md_chart_areaspline", ICON_FALLBACK),
	["btop"] = g("md_chart_areaspline", ICON_FALLBACK),
	["top"] = g("md_chart_areaspline", ICON_FALLBACK),
	["make"] = g("seti_makefile", ICON_FALLBACK),
	["claude"] = g("md_robot_outline", ICON_FALLBACK),
	["psql"] = g("dev_postgresql", ICON_FALLBACK),
	["tmux"] = g("cod_terminal_tmux", ICON_FALLBACK),
	["man"] = g("md_book_open_page_variant", ICON_FALLBACK),
}

local function basename(s)
	if not s then
		return nil
	end
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local function process_name(tab)
	local pane = tab.active_pane
	local name = basename(pane.foreground_process_name) or ""
	if name == "" then
		-- fallback: primeira palavra do título
		name = string.match(pane.title or "", "^%S+") or "shell"
	end
	return name
end

local function tab_label(tab, max_width)
	local name = process_name(tab)
	local icon = ICONS[name] or ICON_FALLBACK
	local title = tab.tab_title
	if title == nil or #title == 0 then
		title = name
	end

	local text = string.format(" %s %d %s ", icon, tab.tab_index + 1, title)
	return wezterm.truncate_right(text, max_width - 2)
end

wezterm.on("format-tab-title", function(tab, _tabs, _panes, _config, hover, max_width)
	local bg, fg
	if tab.is_active then
		bg, fg = p.overlay, p.blue
	elseif hover then
		bg, fg = p.surface, p.fg_dim
	else
		bg, fg = p.bg_deep, p.muted
	end

	local label = tab_label(tab, max_width)

	-- indicadores: painel com output novo / zoom
	local marks = ""
	if tab.active_pane.is_zoomed then
		marks = marks .. g("cod_zoom_in", "") .. " "
	end
	if not tab.is_active and tab.active_pane.has_unseen_output then
		marks = marks .. g("cod_circle_small_filled", "") .. " "
	end

	return {
		{ Background = { Color = p.bg_deep } },
		{ Foreground = { Color = bg } },
		{ Text = LEFT_EDGE },
		{ Background = { Color = bg } },
		{ Foreground = { Color = fg } },
		{ Attribute = { Intensity = tab.is_active and "Bold" or "Normal" } },
		{ Text = label },
		{ Foreground = { Color = tab.is_active and p.green or p.orange } },
		{ Text = marks },
		{ Background = { Color = p.bg_deep } },
		{ Foreground = { Color = bg } },
		{ Text = RIGHT_EDGE },
	}
end)

-- Lado esquerdo da tab bar: workspace atual.
wezterm.on("update-status", function(window, _pane)
	local ws = window:active_workspace()
	window:set_left_status(wezterm.format({
		{ Background = { Color = p.bg_deep } },
		{ Foreground = { Color = p.purple } },
		{ Text = "  " .. g("cod_layers", "") .. " " .. ws .. "  " },
	}))
end)

local function cwd_of(pane)
	local ok, cwd = pcall(function()
		return pane:get_current_working_dir()
	end)
	if not ok or cwd == nil then
		return nil
	end
	local path
	if type(cwd) == "string" then
		path = cwd:gsub("^file://[^/]*", "")
	else
		path = cwd.file_path
	end
	if not path then
		return nil
	end
	path = path:gsub("/$", "")
	local home = wezterm.home_dir
	if path == home then
		return "~"
	end
	path = path:gsub("^" .. home, "~")
	return path
end

local function battery_segment()
	local info = wezterm.battery_info()
	if #info == 0 then
		return nil
	end
	local b = info[1]
	local pct = b.state_of_charge * 100
	local icons = {
		g("md_battery_10", ""), g("md_battery_30", ""), g("md_battery_50", ""),
		g("md_battery_70", ""), g("md_battery", ""),
	}
	local icon = icons[math.max(1, math.min(5, math.ceil(pct / 20)))]
	if b.state == "Charging" then
		icon = g("md_battery_charging", g("md_battery", ""))
	end
	return string.format("%s %.0f%%", icon, pct), (pct < 20 and p.red or p.fg_dim)
end

-- Lado direito: cwd · bateria · relógio.
wezterm.on("update-right-status", function(window, pane)
	local cells = {}

	local dir = cwd_of(pane)
	if dir then
		table.insert(cells, { g("cod_folder_opened", "") .. " " .. basename(dir), p.cyan })
	end

	local bat, bat_color = battery_segment()
	if bat then
		table.insert(cells, { bat, bat_color })
	end

	table.insert(cells, { g("md_clock_outline", "") .. " " .. wezterm.strftime("%H:%M"), p.fg_dim })

	local elements = {}
	if window:leader_is_active() then
		table.insert(elements, { Background = { Color = p.orange } })
		table.insert(elements, { Foreground = { Color = p.bg } })
		table.insert(elements, { Attribute = { Intensity = "Bold" } })
		table.insert(elements, { Text = " " .. g("md_keyboard_outline", g("md_apple_keyboard_command", "\xe2\x8c\x98")) .. " LEADER " })
		table.insert(elements, "ResetAttributes")
	end

	for i, cell in ipairs(cells) do
		table.insert(elements, { Background = { Color = p.bg_deep } })
		table.insert(elements, { Foreground = { Color = p.border } })
		table.insert(elements, { Text = i == 1 and "  " or "  " .. g("ple_left_half_circle_thin", "") .. " " })
		table.insert(elements, { Foreground = { Color = cell[2] } })
		table.insert(elements, { Text = cell[1] })
	end
	table.insert(elements, { Text = "  " })

	window:set_right_status(wezterm.format(elements))
end)

return M
