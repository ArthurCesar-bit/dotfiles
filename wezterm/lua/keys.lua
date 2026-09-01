local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

-- Alterna transparência da janela em runtime (sem editar arquivo).
wezterm.on("toggle-opacity", function(window, _pane)
	local overrides = window:get_config_overrides() or {}
	if overrides.window_background_opacity == nil or overrides.window_background_opacity >= 0.99 then
		overrides.window_background_opacity = 0.85
	else
		overrides.window_background_opacity = 1.0
	end
	window:set_config_overrides(overrides)
end)

-- Alterna o "modo leitura": fonte maior + padding folgado.
wezterm.on("toggle-zen", function(window, _pane)
	local overrides = window:get_config_overrides() or {}
	if overrides.font_size == nil then
		overrides.font_size = 16.0
		overrides.window_padding = { left = 48, right = 48, top = 24, bottom = 24 }
		overrides.enable_tab_bar = false
	else
		overrides.font_size = nil
		overrides.window_padding = nil
		overrides.enable_tab_bar = nil
	end
	window:set_config_overrides(overrides)
end)

function M.apply(config)
	config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1500 }
	config.disable_default_key_bindings = false

	config.keys = {
		-- manda um CTRL+Space literal quando precisar
		{ key = "Space", mods = "LEADER|CTRL", action = act.SendKey({ key = "Space", mods = "CTRL" }) },

		--------------------------------------------------------------- splits
		{ key = "|", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{ key = "d", mods = "CTRL|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "e", mods = "CTRL|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

		----------------------------------------------------- navegar entre panes
		{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
		{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
		{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
		{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
		{ key = "LeftArrow", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Left") },
		{ key = "DownArrow", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Down") },
		{ key = "UpArrow", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Up") },
		{ key = "RightArrow", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Right") },

		{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
		{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
		{ key = "o", mods = "LEADER", action = act.RotatePanes("Clockwise") },
		{ key = "s", mods = "LEADER", action = act.PaneSelect({ alphabet = "asdfghjkl" }) },

		------------------------------------------------------------------ abas
		{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
		{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
		{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
		{ key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
		{ key = "Tab", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },
		{
			key = ",",
			mods = "LEADER",
			action = act.PromptInputLine({
				description = "Renomear aba:",
				action = wezterm.action_callback(function(window, _pane, line)
					if line and #line > 0 then
						window:active_tab():set_title(line)
					end
				end),
			}),
		},

		-------------------------------------------------------------- workspaces
		{ key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
		{
			key = "W",
			mods = "LEADER|SHIFT",
			action = act.PromptInputLine({
				description = "Novo workspace:",
				action = wezterm.action_callback(function(window, pane, line)
					if line and #line > 0 then
						window:perform_action(
							act.SwitchToWorkspace({ name = line }),
							pane
						)
					end
				end),
			}),
		},

		------------------------------------------------------------ redimensionar
		{ key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize", one_shot = false, timeout_milliseconds = 2000 }) },

		--------------------------------------------------------------- utilidades
		{ key = "f", mods = "LEADER", action = act.Search({ CaseInSensitiveString = "" }) },
		{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },
		{ key = "b", mods = "LEADER", action = act.EmitEvent("toggle-opacity") },
		{ key = "m", mods = "LEADER", action = act.EmitEvent("toggle-zen") },
		{ key = "u", mods = "LEADER", action = act.CharSelect({ copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" }) },

		{ key = "p", mods = "CTRL|SHIFT", action = act.ActivateCommandPalette },
		{ key = "Space", mods = "CTRL|SHIFT", action = act.QuickSelect },
		{ key = "f", mods = "CTRL|SHIFT", action = act.Search({ CaseInSensitiveString = "" }) },
		{ key = "k", mods = "CTRL|SHIFT", action = act.ClearScrollback("ScrollbackAndViewport") },

		------------------------------------------------------------------- fonte
		{ key = "+", mods = "CTRL|SHIFT", action = act.IncreaseFontSize },
		{ key = "-", mods = "CTRL", action = act.DecreaseFontSize },
		{ key = "0", mods = "CTRL", action = act.ResetFontSize },
	}

	-- ALT+1..9 salta direto para a aba
	for i = 1, 9 do
		table.insert(config.keys, {
			key = tostring(i),
			mods = "ALT",
			action = act.ActivateTab(i - 1),
		})
	end

	config.key_tables = {
		resize = {
			{ key = "h", action = act.AdjustPaneSize({ "Left", 3 }) },
			{ key = "j", action = act.AdjustPaneSize({ "Down", 3 }) },
			{ key = "k", action = act.AdjustPaneSize({ "Up", 3 }) },
			{ key = "l", action = act.AdjustPaneSize({ "Right", 3 }) },
			{ key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 3 }) },
			{ key = "DownArrow", action = act.AdjustPaneSize({ "Down", 3 }) },
			{ key = "UpArrow", action = act.AdjustPaneSize({ "Up", 3 }) },
			{ key = "RightArrow", action = act.AdjustPaneSize({ "Right", 3 }) },
			{ key = "Escape", action = "PopKeyTable" },
			{ key = "Enter", action = "PopKeyTable" },
		},
	}

	------------------------------------------------------------------ mouse
	config.mouse_bindings = {
		-- CTRL + clique abre link
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = act.OpenLinkAtMouseCursor,
		},
		-- clique simples só seleciona, sem abrir link por engano
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "NONE",
			action = act.CompleteSelection("ClipboardAndPrimarySelection"),
		},
		-- botão do meio cola
		{
			event = { Down = { streak = 1, button = "Middle" } },
			mods = "NONE",
			action = act.PasteFrom("PrimarySelection"),
		},
	}
end

return M
