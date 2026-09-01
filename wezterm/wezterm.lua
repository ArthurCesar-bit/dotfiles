--[[
  WezTerm — tema "Nocturne" (dark)
  ~/.config/wezterm -> ~/dotfiles/wezterm

  LEADER = CTRL+Space

  Panes      LEADER |  / LEADER -   split horizontal / vertical
             LEADER h j k l         navegar
             LEADER z               zoom     LEADER x  fechar
             LEADER s               selecionar pane   LEADER o  rotacionar
             LEADER r               modo resize (hjkl, Esc sai)
  Abas       LEADER c  nova         LEADER n / p  próxima / anterior
             ALT+1..9  ir para aba  LEADER ,  renomear
  Workspaces LEADER w  listar       LEADER W  criar
  Extras     LEADER f  buscar       LEADER [  copy mode
             LEADER b  transparência  LEADER m  modo zen
             CTRL+SHIFT+P  paleta   CTRL+SHIFT+Space  quick select
--]]

local wezterm = require("wezterm")
local config = wezterm.config_builder()

config:set_strict_mode(true)

require("lua.appearance").apply(config)
require("lua.keys").apply(config)
require("lua.tabs")
require("lua.commands")

--------------------------------------------------------------------- shell
config.default_prog = { os.getenv("SHELL") or "/bin/bash", "-l" }

------------------------------------------------------------------ hyperlinks
config.hyperlink_rules = wezterm.default_hyperlink_rules()
-- owner/repo -> github
table.insert(config.hyperlink_rules, {
	regex = [[["']?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["']?]],
	format = "https://www.github.com/$1/$3",
})

---------------------------------------------------------------- quick select
config.quick_select_patterns = {
	"[0-9a-f]{7,40}", -- hashes de commit
	"[\\w\\-\\.\\/]+\\.(lua|ts|tsx|js|jsx|py|rs|go|json|md|yaml|yml)", -- caminhos de arquivo
	"https?://\\S+",
}

return config
