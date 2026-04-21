# MyLazyVim

A personal Neovim configuration built on [LazyVim](https://www.lazyvim.org/), managed by [lazy.nvim](https://github.com/folke/lazy.nvim).

## Quick Start

```bash
git clone https://github.com/hermanzhaozzzz/MyLazyVim.git ~/.config/nvim
nvim  # plugins install automatically on first run
```

## Features

- **Colorscheme**: [tokyonight-night](https://github.com/folke/tokyonight.nvim) (default), [gruvbox](https://github.com/ellisonleao/gruvbox.nvim) available
- **Completion**: [blink.cmp](https://github.com/saghen/blink.cmp) with ghost text, custom Tab/Shift-Tab cycling
- **REPL**: [iron.nvim](https://github.com/hkupty/iron.nvim) — Python (ipython), Shell (zsh)
- **CSV/TSV**: [rainbow_csv](https://github.com/mechatroner/rainbow_csv) — column coloring, aligned view, header/index pinning
- **Formatting**: [conform.nvim](https://github.com/stevearc/conform.nvim) with [stylua](https://github.com/JohnnyMorganz/StyLua)
- **Languages**: Docker, JSON, Markdown, Python, R, Rust, TeX, TOML, YAML

## Keymaps

### Insert Mode
| Key | Action |
|-----|--------|
| `jj` | Escape to Normal mode |
| `Ctrl+A` | Go to start of line |
| `Ctrl+E` | Go to end of line |

### Normal / Visual Mode
| Key | Action |
|-----|--------|
| `Ctrl+A` | Go to first non-blank character |
| `Ctrl+E` | Go to end of line |
| `J` / `K` (visual) | Move selected lines down/up |

### Window
| Key | Action |
|-----|--------|
| `<leader>z + Arrow` | Resize window |
| `<leader>zi` / `zo` / `zr` | Neovide zoom in/out/reset |

### REPL (`<leader>r`)
| Key | Action |
|-----|--------|
| `<leader>rr` | Toggle REPL |
| `<leader>rl` | Send line |
| `<leader>rc` | Send motion/visual |
| `<leader>rb` | Send code block |
| `<leader>rn` | Send block and move |
| `<leader>rf` | Send entire file |
| `<leader>rR` | Restart REPL |
| `<leader>rq` | Exit REPL |
| `<leader>ri` | Interrupt REPL |

### Table (`<leader>t`, csv/tsv only)
| Key | Action |
|-----|--------|
| `<leader>ta` | Toggle in-place aligned editing |
| `<leader>th` | Toggle pinned header (ta mode only) |
| `<leader>ti` | Insert literal tab character |

## Directory Structure

```
~/.config/nvim/
├── init.lua                 -- Entry point
├── lazyvim.json             -- LazyVim extras
├── stylua.toml              -- Lua formatter config
├── lua/
│   ├── config/
│   │   ├── lazy.lua         -- lazy.nvim bootstrap
│   │   ├── options.lua      -- Additional options
│   │   ├── keymaps.lua      -- Custom keymaps
│   │   └── autocmds.lua     -- Custom autocommands
│   └── plugins/
│       ├── blink-cmp.lua    -- Completion
│       ├── colorscheme.lua  -- Colorscheme
│       ├── iron.lua         -- REPL
│       └── rainbow-csv.lua  -- CSV/TSV display
```

## Requirements

- [Neovim](https://neovim.io/) >= 0.9.0
- [Git](https://git-scm.io/) >= 2.19.0
- A [Nerd Font](https://www.nerdfonts.com/) (for icons)
- Optional: [Neovide](https://neovide.dev/) for GUI features

## License

See [LICENSE](LICENSE).
