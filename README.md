# kickstart.nvim — minimal

Minimal Neovim config based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).

Uses `vim.pack` as plugin manager, **mini.nvim** modules for most UI/UX needs, **neo-tree** for file browsing, and native `vim.lsp` (no mason, no treesitter).

## Structure

```
init.lua
lua/core/
├── options.lua       # vim.o settings
├── keymaps.lua       # basic keymaps + mini.pick bindings
├── lsp.lua           # LSP config (no mason, servers installed manually)
└── commands.lua      # :AddPack, :DelPack, :UpdatePack
lua/plugins/
├── init.lua          # loads all plugin files
├── tokyonight.lua    # colorscheme
├── mini.lua          # 19 mini.nvim modules
├── neo-tree.lua      # file explorer
├── telekasten.lua    # notes
└── debug.lua         # DAP (simplified)
lua/custom/plugins/   # user plugins
```

## Key plugins

| Category | Choice |
|---|---|
| Plugin manager | `vim.pack` (built-in) |
| UI/UX | **mini.nvim** (clue, statusline, tabline, notify, indentscope, diff, pairs, etc.) |
| LSP | `nvim-lspconfig` (no mason — install servers manually) |
| Completion | mini.completion + mini.snippets |
| Picker | mini.pick (via mini.extra) |
| File explorer | neo-tree.nvim |
| Colorscheme | tokyonight-night |
| Notes | telekasten.nvim |
| Debug | nvim-dap + dap-ui + dap-go |

## External dependencies

- `git`, `make`, `unzip`
- [ripgrep](https://github.com/BurntSushi/ripgrep) (for grep picker)
- [fd-find](https://github.com/sharkdp/fd) (for file picker, optional)
- Nerd Font (optional, for icons)
- LSP servers for languages you use (e.g. `pyright`, `rust-analyzer`, `typescript-language-server`, `lua-language-server`)

## First start

```sh
nvim
```

`vim.pack` will download all plugins automatically. To check plugin status:

```vim
:UpdatePack
```

To update plugins:

```vim
:lua vim.pack.update()
```

## Managing plugins

```
:AddPack user/repo   — install a plugin from GitHub
:DelPack plugin-name — remove a plugin
:UpdatePack          — check for updates (offline)
```
