# dotfiles

My personal terminal configuration, kept on GitHub so it is easy to hand off to any
machine I sit down at. Clone the repo, symlink a few directories, and I get the same
Neovim, tmux, Ghostty, btop and presenterm setup I use every day — no manual re-tweaking.

Everything here is Linux/macOS oriented and lives under `~/.config`.

---

## What's inside

| Directory  | Tool                  | Target location             |
| ---------- | --------------------- | --------------------------- |
| `nvim/`    | Neovim (Lua, lazy.nvim) | `~/.config/nvim`          |
| `tmux/`    | tmux                  | `~/.config/tmux`            |
| `ghostty/` | Ghostty               | `~/.config/ghostty`         |
| `btop/`    | btop                  | `~/.config/btop`            |
| `presenterm/` | presenterm         | `~/.config/presenterm`      |

Shared theme across the stack: **Catppuccin** (Mocha in Neovim, Catppuccin in tmux),
with **Tokyo Night** in btop. Font is **JetBrains Mono** with a **Symbols Nerd Font**
fallback — a Nerd Font is assumed everywhere (`vim.g.have_nerd_font = true`).

---

## Requirements

**Core**

- Neovim ≥ 0.10 (uses `vim.lsp.enable`, `vim.uv`)
- git, make, unzip, [ripgrep](https://github.com/BurntSushi/ripgrep) — checked by `:checkhealth`
- [fd](https://github.com/sharkdp/fd) and [fzf](https://github.com/junegunn/fzf) for fzf-lua
- A Nerd Font (JetBrains Mono + Symbols Nerd Font Mono)

**Optional, per tool**

- tmux ≥ 3.0 (undercurl / underline-colour support) + [tpm](https://github.com/tmux-plugins/tpm)
- [lazygit](https://github.com/jesseduffield/lazygit) for `<leader>gg`
- Node.js / Go / Python toolchains for the language servers you actually use
- btop, [Ghostty](https://ghostty.org/) ≥ 1.1 (keybind sequences)
- [presenterm](https://github.com/mfontanini/presenterm) ≥ 0.16 + `python3` (for `+exec` snippets)

LSP servers and formatters are installed automatically by
[mason.nvim](https://github.com/williamboman/mason.nvim) +
[mason-tool-installer](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim) —
no manual `npm i -g` needed.

---

## Installation

```bash
git clone git@github.com:ArthurCesar-bit/dotfiles.git ~/dotfiles
cd ~/dotfiles

mkdir -p ~/.config

ln -s ~/dotfiles/nvim    ~/.config/nvim
ln -s ~/dotfiles/tmux    ~/.config/tmux
ln -s ~/dotfiles/ghostty ~/.config/ghostty
ln -s ~/dotfiles/btop    ~/.config/btop
ln -s ~/dotfiles/presenterm ~/.config/presenterm
```

Symlink only what you want — each directory is independent.

> If a config already exists at any of those paths, back it up first
> (`mv ~/.config/nvim ~/.config/nvim.bak`); `ln -s` will not overwrite a directory.

### First run

**Neovim** — `nvim`. lazy.nvim bootstraps itself, installs all plugins, then Mason
pulls the language servers and formatters. Verify with `:checkhealth` and `:Lazy`.

**tmux** — install tpm first, then fetch plugins from inside tmux with
<kbd>prefix</kbd> + <kbd>I</kbd>:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

**Ghostty / btop / presenterm** — no bootstrap step; they read the config on next launch.
Reload Ghostty's config in place with <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>,</kbd>.

---

## Neovim

Kickstart-flavoured but split into modules. Leader is <kbd>Space</kbd>.

```
nvim/
├── init.lua              # leader, nerd-font flag, module loading
├── lua/
│   ├── globals.lua       # global vars
│   ├── options.lua       # editor options
│   ├── keymaps.lua       # core keymaps
│   ├── lazy-init.lua     # lazy.nvim bootstrap + plugin spec imports
│   ├── health.lua        # :checkhealth for external deps
│   └── plugins/
│       ├── coding/       # lsp, blink.cmp, treesitter, trouble, autopairs, todo-comments
│       ├── editor/       # fzf-lua, gitsigns, nvim-tree, lualine, lazygit, ufo, which-key, tmux nav
│       ├── formatting/   # conform.nvim
│       ├── test/         # neotest (+ go, python, vitest, plenary adapters)
│       ├── ui/           # moonfly, dressing, treesitter-context
│       └── util/         # mini.hipatterns
└── lsp/                  # per-server settings (vim.lsp.config style)
```

**Language servers** (`lsp/` + enabled in `plugins/coding/lspconfig.lua`):
`lua_ls`, `vtsls`, `eslint`, `tailwindcss`, `cssls`, `gopls`, `pyright`, `ruff`,
`astro`, `dockerls`, `docker_compose_language_service`, `neocmake`.

**Formatting** (`conform.nvim`, format-after-save): `stylua` for Lua; for JS/TS/JSON/CSS
it prefers **Biome** when a `biome.json`/`biome.jsonc` exists in the project root,
otherwise falls back to **Prettier**/`prettierd`, and finally to LSP formatting.
Toggle it off with `vim.g.disable_autoformat` (global) or `vim.b.disable_autoformat`
(buffer).

### Key bindings (selection)

| Key | Action |
| --- | ------ |
| `<leader><space>` / `<leader>ff` | Find files |
| `<leader>fg` | Git files |
| `<leader>sg` | Live grep |
| `<leader>sk` / `<leader>sh` | Keymaps / help pages |
| `<leader>sr` | Search & replace (grug-far) |
| `<leader>e` | File explorer (nvim-tree) |
| `<leader>gg` | lazygit |
| `<leader>cr` | LSP rename |
| `<leader>ca` | Code action |
| `<leader>cd` / `<leader>cs` | Diagnostics / symbols (Trouble) |
| `<leader>bd` / `<leader>bo` | Delete buffer / other buffers |
| `<leader>tt` / `<leader>tr` | Run test file / nearest test (neotest) |
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `sh` / `sv` | Vertical / horizontal split |
| `<Tab>` / `<S-Tab>` | Next / previous tab |
| `<Esc>` | Clear search highlight |

`<leader>` then wait — [which-key](https://github.com/folke/which-key.nvim) shows the
rest.

---

## tmux

- Plugins via tpm: tmux-sensible, tmux-resurrect, tmux-continuum, tmux.nvim, catppuccin
- Custom Catppuccin status line: session, running command, current path, zoom flag
- Windows/panes are 1-indexed with `renumber-windows on`
- Mouse on, 30k scrollback history, zero escape-time
- `prefix + v` / `prefix + h` — split vertically / horizontally in the current path
- `prefix + x` — kill pane
- `prefix + \` — toggle the status bar
- `prefix + r` — reload the config
- `M-h/j/k/l` — resize panes (passes through to Neovim when a Vim pane is focused)
- Undercurl and OSC 8 hyperlink passthrough enabled

## Ghostty

Migrated from WezTerm; the **Nocturne** palette came along unchanged
(`ghostty/themes/nocturne`).

- JetBrains Mono Nerd Font 13.5, cell height +15%, ligatures on (`calt`/`clig`/`liga`)
- Nocturne dark palette, GTK headerbar (`window-decoration = auto`), padding 14/12 x 10/8
- Block cursor, no blink, 50 MB scrollback, copy-on-select to the clipboard
- Leader is <kbd>Ctrl</kbd>+<kbd>Space</kbd> (Ghostty key *sequences*), mirroring the old
  WezTerm bindings

| Key | Action |
| --- | ------ |
| <kbd>leader</kbd> `|` / `-` | Split right / down |
| <kbd>leader</kbd> `h` `j` `k` `l` | Move between splits |
| <kbd>leader</kbd> <kbd>Ctrl</kbd>+`hjkl` | Resize split |
| <kbd>leader</kbd> `z` / `x` | Zoom / close split |
| <kbd>leader</kbd> `c` / `n` / `p` | New tab / next / previous |
| <kbd>leader</kbd> `b` | Toggle background opacity |
| <kbd>Alt</kbd>+<kbd>1..9</kbd> | Jump to tab |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>d</kbd> / <kbd>e</kbd> | Split right / down |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>p</kbd> | Command palette |

Set as the system terminal (GNOME, <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>T</kbd>):

```bash
sudo update-alternatives --set x-terminal-emulator /usr/bin/ghostty
echo com.mitchellh.ghostty.desktop > ~/.config/GNOME-xdg-terminals.list
gsettings set org.gnome.desktop.default-applications.terminal exec ghostty
```

## btop

- Tokyo Night theme, transparent background, truecolor
- Vim keys enabled, 2s refresh, `cpu mem net proc` boxes
- `color_theme` is set to the bare name `tokyo-night`, which btop resolves from
  `~/.config/btop/themes` — the theme file is vendored in `btop/themes/`, so it works
  on any machine without depending on a distro or Homebrew path
- btop writes `btop.log` into its config dir; it is gitignored

## presenterm

- Code snippet execution is enabled from the config, so `+exec` blocks run without
  passing `-x` / `--enable-snippet-execution` on every invocation
- A custom `python` executor writes the snippet to `snippet.py` and runs it with
  `python3`
- Check what presenterm actually loaded with `presenterm --current-theme`; an invalid
  key makes it exit with `invalid configuration: ...`

---

## Notes & known rough edges

- `nvim/lazy-lock.json` is **gitignored**, so plugin versions are not pinned across
  machines — a fresh clone installs the latest versions.
- `tmux/tmux.conf` calls `~/.config/tmux/hooks/update-pane-status.sh`, which is not
  in this repo. Those bindings still work; the hook just fails silently.
- Ghostty has no workspaces, copy-mode or scrollback search, so the WezTerm bindings for
  those were dropped in the migration; tmux covers the same ground.

## License

Personal configuration — take whatever is useful.
