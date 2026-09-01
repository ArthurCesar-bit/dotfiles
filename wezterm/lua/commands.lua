local wezterm = require("wezterm")
local act = wezterm.action

-- Entradas extras na paleta de comandos (CTRL+SHIFT+P).
wezterm.on("augment-command-palette", function(_window, _pane)
	return {
		{
			brief = "Transparência: alternar",
			icon = "md_circle_opacity",
			action = act.EmitEvent("toggle-opacity"),
		},
		{
			brief = "Modo zen: fonte grande, sem abas",
			icon = "md_meditation",
			action = act.EmitEvent("toggle-zen"),
		},
		{
			brief = "Renomear aba",
			icon = "md_rename_box",
			action = act.PromptInputLine({
				description = "Renomear aba:",
				action = wezterm.action_callback(function(window, _pane, line)
					if line and #line > 0 then
						window:active_tab():set_title(line)
					end
				end),
			}),
		},
		{
			brief = "Renomear workspace",
			icon = "md_layers_edit",
			action = act.PromptInputLine({
				description = "Novo nome do workspace:",
				action = wezterm.action_callback(function(_window, _pane, line)
					if line and #line > 0 then
						wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
					end
				end),
			}),
		},
		{
			brief = "Limpar scrollback",
			icon = "md_broom",
			action = act.ClearScrollback("ScrollbackAndViewport"),
		},
	}
end)

return {}
