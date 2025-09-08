# Neovim Configuration

A clean, modular Neovim configuration focused on modern development workflows.

## Project Structure

```
nvim/
├── init.lua                  # Entry point - sets leader keys and loads modules
├── lazy-lock.json           # Lazy.nvim plugin lockfile for reproducible builds
├── .stylua.toml            # Lua formatter configuration
├── .gitignore              # Git ignore rules
└── lua/
    ├── config/             # Core Neovim configuration
    │   ├── autocmds.lua    # Auto-commands for custom behaviors
    │   ├── keymaps.lua     # Key bindings and mappings
    │   ├── options.lua     # Vim options and settings
    │   └── utils.lua       # Utility functions
    └── plugins/            # Plugin configurations
        ├── init.lua        # Plugin manager setup (Lazy.nvim)
        └── ...plugin.lua   # Individual plugin configuration files
```

## Architecture

### Modular Design
- **`init.lua`**: Minimal entry point that sets leader keys and loads core modules
- **`config/`**: Core Neovim configuration separated by concern
- **`plugins/`**: Individual plugin configurations with automatic loading

### Plugin Management
Uses [Lazy.nvim](https://github.com/folke/lazy.nvim) with automatic plugin discovery:
- Each `.lua` file in `plugins/` (except `init.lua`) is automatically loaded
- No need to manually maintain plugin lists
- Lockfile ensures reproducible plugin versions

### Configuration Categories

#### Core Configuration (`config/`)
- **options.lua**: Vim settings (line numbers, indentation, etc.)
- **keymaps.lua**: Key bindings and shortcuts
- **autocmds.lua**: Automatic commands for custom behaviors
- **utils.lua**: Shared utility functions

#### Plugin Categories (`plugins/`)
- **Language Support**: LSP, completion, snippets, formatting
- **UI Enhancement**: File explorer, status line, notifications
- **Development Tools**: Git integration, project management
- **Editor Features**: Multiple cursors, auto-session, fuzzy finding

## Key Features

- **LSP Integration**: Full Language Server Protocol support with Mason
- **Modern Completion**: Blink completion with snippet support
- **Git Integration**: Gitsigns for inline git status and operations
- **File Management**: Neo-tree file explorer with modern UI
- **Code Intelligence**: Treesitter for advanced syntax highlighting
- **Fuzzy Finding**: Telescope for files, buffers, and project search
- **Auto-formatting**: Conform.nvim for consistent code style
- **Session Management**: Auto-session for workspace persistence

## Getting Started

1. Place this configuration in your Neovim config directory:
   - Linux/macOS: `~/.config/nvim/`
   - Windows: `%APPDATA%\nvim\`

2. Start Neovim - plugins will be automatically installed on first run

3. Use `<Space>` as the leader key for most custom mappings

The configuration prioritizes simplicity and maintainability while providing a rich development experience.