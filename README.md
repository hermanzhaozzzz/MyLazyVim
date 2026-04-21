# MyLazyVim

A personal Neovim configuration built on [LazyVim](https://www.lazyvim.org/), managed by [lazy.nvim](https://github.com/folke/lazy.nvim).

## Quick Start

```bash
git clone https://github.com/hermanzhaozzzz/MyLazyVim.git ~/.config/nvim
nvim  # plugins install automatically on first run
```

## Features

| Category | Plugin | Description |
|----------|--------|-------------|
| Colorscheme | [tokyonight-night](https://github.com/folke/tokyonight.nvim) | Default theme; [gruvbox](https://github.com/ellisonleao/gruvbox.nvim) available |
| Completion | [blink.cmp](https://github.com/Saghen/blink.cmp) | Ghost-text inline preview; Tab / Shift-Tab cycling |
| REPL | [iron.nvim](https://github.com/hkupty/iron.nvim) | Python (ipython), Shell (zsh) |
| CSV / TSV | [rainbow_csv](https://github.com/mechatroner/rainbow_csv) | Column coloring, in-place aligned view, pinned header |
| Formatting | [conform.nvim](https://github.com/stevearc/conform.nvim) | Lua via [stylua](https://github.com/JohnnyMorganz/StyLua) |
| Languages | LazyVim extras | Docker, JSON, Markdown, Python, R, Rust, TeX, TOML, YAML |

## Keymaps

All custom keymaps are defined in `lua/config/keymaps.lua` and plugin specs.
Below is a complete reference of non-default bindings.

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
| `J` / `K` (visual) | Move selected lines down / up |

### Window

| Key | Action |
|-----|--------|
| `<leader>z` + Arrow | Resize window |
| `<leader>zi` / `zo` / `zr` | Neovide zoom in / out / reset (GUI only) |

### REPL (`<leader>r`)

Requires an open REPL (`<leader>rr` to toggle).

| Key | Action |
|-----|--------|
| `<leader>rr` | Toggle REPL |
| `<leader>rl` | Send line |
| `<leader>rc` | Send motion / visual selection |
| `<leader>rb` | Send code block (`# %%`) |
| `<leader>rn` | Send block and move to next |
| `<leader>rf` | Send entire file |
| `<leader>rR` | Restart REPL |
| `<leader>rq` | Exit REPL |
| `<leader>ri` | Interrupt REPL |

### Table (`<leader>t`, CSV / TSV only)

Provides Typora-like in-place aligned editing — the underlying file is never modified, only the display changes.

| Key | Action |
|-----|--------|
| `<leader>ta` | Toggle aligned view (hide delimiters, show `\|` separators, pad columns) |
| `<leader>th` | Toggle pinned header — freeze row 1 at the top with a `─┼─` separator (requires `ta`) |
| `<leader>ti` | Insert a literal tab character and enter Insert mode |

**Details:**

- `<leader>ta` conceals delimiters (``,` or `\t`) and renders inline `│` separators with column padding.
  Only visible lines get extmarks, so large files stay responsive.
  Edits go to the real file; the display refreshes automatically (debounced).
- `<leader>th` opens a floating window pinned to row 1, synced with horizontal scroll.
  A `─┼─` separator line appears below the header.
  Press again to close.
- `<leader>ti` inserts a tab after the cursor and switches to Insert mode — useful in TSV where `Tab` would normally trigger completion.
- All three commands are only active when `filetype` is `csv` or `tsv`.

## Autocommands

- **TSV tab preservation** (`FileType tsv`): disables `expandtab`, sets `tabstop=1`, `shiftwidth=1`, `softtabstop=0` so tab characters are never converted to spaces.

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
│       ├── blink-cmp.lua    -- Completion (ghost text, Tab cycling)
│       ├── colorscheme.lua  -- Colorscheme (tokyonight-night)
│       ├── iron.lua         -- REPL (ipython, zsh)
│       └── rainbow-csv.lua  -- CSV/TSV aligned view & header pin
```

## Requirements

- [Neovim](https://neovim.io/) >= 0.9.0
- [Git](https://git-scm.io/) >= 2.19.0
- A [Nerd Font](https://www.nerdfonts.com/) (for icons)
- Optional: [Neovide](https://neovide.dev/) for GUI features (zoom, mouse hiding)

## License

See [LICENSE](LICENSE).
