# Neovim Configuration Refactoring Plan

## Overview
Split the monolithic `init.lua` (1183 lines) into a fully modular structure where **every single plugin** gets its own dedicated file for maximum organization and maintainability.

## Target Structure
```
├── init.lua                              (minimal entry point)
├── lua/
│   ├── config/
│   │   ├── options.lua                   (vim options & settings)
│   │   ├── keymaps.lua                   (global keymaps only)
│   │   ├── autocmds.lua                  (autocommands)
│   │   └── utils.lua                     (utility functions)
│   └── plugins/
│       ├── init.lua                      (lazy.nvim setup + imports)
│       ├── vim-sleuth.lua                (detect tabstop automatically)
│       ├── gitsigns.lua                  (git integration)
│       ├── vim-visual-multi.lua          (multi-cursor editing)
│       ├── which-key.lua                 (keybind helper)
│       ├── telescope.lua                 (fuzzy finder)
│       ├── telescope-fzf-native.lua      (telescope fzf extension)
│       ├── telescope-ui-select.lua       (telescope ui-select)
│       ├── telescope-undo.lua            (telescope undo tree)
│       ├── todo-comments.lua             (todo highlighting)
│       ├── mini-ai.lua                   (better text objects)
│       ├── mini-surround.lua             (surround operations)
│       ├── mini-statusline.lua           (status line)
│       ├── nvim-treesitter.lua           (syntax highlighting)
│       ├── nvim-treesitter-textobjects.lua (treesitter text objects)
│       ├── nvim-treesitter-context.lua   (show context)
│       ├── neo-tree.lua                  (file explorer)
│       ├── auto-session.lua              (session management)
│       ├── indent-blankline.lua          (indentation guides)
│       ├── copilot.lua                   (AI completion)
│       ├── lazydev.lua                   (lua development support)
│       ├── nvim-lspconfig.lua            (LSP configuration)
│       ├── mason.lua                     (LSP installer)
│       ├── mason-lspconfig.lua           (mason + lspconfig bridge)
│       ├── mason-tool-installer.lua      (auto-install tools)
│       ├── fidget.lua                    (LSP progress indicator)
│       ├── conform.lua                   (code formatting)
│       ├── blink-cmp.lua                 (completion engine)
│       ├── luasnip.lua                   (snippet engine)
│       └── darcubox.lua                  (colorscheme)
└── lua/custom/plugins/                   (existing - keep as-is)
```

---

## Stage 1: Core Configuration Extraction
**Goal**: Extract basic vim configuration and utilities
**Success Criteria**: Neovim starts with same options and basic functionality
**Tests**: 
- All vim options work as before
- Hard mode toggle functional
- Autocommands trigger correctly
**Status**: Not Started

### Files to Create:
- `lua/config/options.lua` - Lines 18-109 (all vim.opt settings)
- `lua/config/utils.lua` - Lines 113-147 (hard mode functionality)
- `lua/config/autocmds.lua` - Lines 152-171 + 1160-1164 (all autocommands)
- `lua/config/keymaps.lua` - Lines 981+ (global keymaps only, no plugin-specific)

---

## Stage 2: Plugin Manager Setup
**Goal**: Set up plugin directory structure and lazy.nvim
**Success Criteria**: Plugin manager initializes and can load plugins
**Tests**: Lazy.nvim dashboard appears and functions
**Status**: Not Started

### Files to Create:
- `lua/plugins/init.lua` - Lazy.nvim setup (lines 184-193) + require all plugin files + custom.plugins import

---

## Stage 3: Individual Plugin Extraction (Every Plugin Gets Its Own File)
**Goal**: Extract every single plugin to its own dedicated file
**Success Criteria**: Each plugin works identically to current setup
**Tests**: Test each plugin individually after extraction
**Status**: Not Started

### Simple Plugins (Single-line or minimal config):

#### `lua/plugins/vim-sleuth.lua` (Line 195)
```lua
return {
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
}
```

#### `lua/plugins/vim-visual-multi.lua` (Lines 268-272)
```lua
return {
  'mg979/vim-visual-multi',
  branch = 'master',
  event = 'VeryLazy',
}
```

#### `lua/plugins/copilot.lua` (Lines 633-635 + keymaps 993-997)
```lua
return {
  'github/copilot.vim',
  -- Include the Copilot keymap configuration
}
```

#### `lua/plugins/lazydev.lua` (Lines 639-650)
```lua
return {
  'folke/lazydev.nvim',
  ft = 'lua',
  opts = { ... }
}
```

#### `lua/plugins/mason.lua` (Line 657)
```lua
return {
  'williamboman/mason.nvim', 
  opts = {}
}
```

#### `lua/plugins/mason-lspconfig.lua` (Line 658)
```lua
return {
  'williamboman/mason-lspconfig.nvim',
}
```

#### `lua/plugins/mason-tool-installer.lua` (Line 659)
```lua
return {
  'WhoIsSethDaniel/mason-tool-installer.nvim',
}
```

#### `lua/plugins/fidget.lua` (Line 662)
```lua
return {
  'j-hui/fidget.nvim', 
  opts = {}
}
```

#### `lua/plugins/luasnip.lua` (Lines 910-922)
```lua
return {
  'L3MON4D3/LuaSnip',
  version = '2.*',
  build = function() ... end,
}
```

#### `lua/plugins/darcubox.lua` (Lines 967-972)
```lua
return {
  'Koalhack/darcubox-nvim',
  config = function()
    vim.cmd 'colorscheme darcubox'
  end,
}
```

### Complex Plugins (With substantial configuration):

#### `lua/plugins/gitsigns.lua` (Lines 196-266)
- Complete gitsigns setup
- All keymaps and git hunk operations
- Blame and quickfix integration

#### `lua/plugins/which-key.lua` (Lines 273-324)
- Keybind helper configuration
- Icon settings
- Key group documentation

#### `lua/plugins/telescope.lua` (Lines 325-431)
- Main telescope setup
- All search keymaps
- Extension loading
- Helper functions

#### `lua/plugins/telescope-fzf-native.lua`
- Extract from telescope dependencies
- FZF native extension setup

#### `lua/plugins/telescope-ui-select.lua`
- Extract from telescope dependencies
- UI select extension

#### `lua/plugins/telescope-undo.lua`
- Extract from telescope dependencies
- Undo tree integration

#### `lua/plugins/todo-comments.lua` (Lines 433-437 + 1166-1182)
- TODO highlighting
- Navigation keymaps
- Quickfix and telescope integration

#### `lua/plugins/mini-ai.lua`
- Extract from mini.nvim setup
- Better text objects configuration

#### `lua/plugins/mini-surround.lua`
- Extract from mini.nvim setup
- Surround operations

#### `lua/plugins/mini-statusline.lua`
- Extract from mini.nvim setup
- Complete statusline configuration

#### `lua/plugins/nvim-treesitter.lua` (Lines 512-573)
- Main treesitter setup
- Language installation
- Highlighting and indent

#### `lua/plugins/nvim-treesitter-textobjects.lua`
- Extract from treesitter dependencies
- Text object operations
- Movement and swap keymaps

#### `lua/plugins/nvim-treesitter-context.lua` (Lines 500-511)
- Context showing at top of screen
- Configuration options

#### `lua/plugins/neo-tree.lua` (Lines 575-587 + 1006-1030)
- File explorer setup
- Smart toggle keymap

#### `lua/plugins/auto-session.lua` (Lines 588-605)
- Session management
- Keymaps for save/restore

#### `lua/plugins/indent-blankline.lua` (Lines 606-632)
- Indentation guides
- Scope highlighting
- Filetype exclusions

#### `lua/plugins/nvim-lspconfig.lua` (Lines 651-855)
- Main LSP configuration
- Server setups
- LSP keymaps and autocommands
- Diagnostic configuration

#### `lua/plugins/conform.lua` (Lines 857-903)
- Code formatting setup
- Format on save
- Formatter configurations

#### `lua/plugins/blink-cmp.lua` (Lines 904-952)
- Completion engine
- Completion keymaps
- Source configuration

---

## Stage 4: Global Keymap Organization
**Goal**: Clean up global keymaps, ensure no plugin-specific ones remain
**Success Criteria**: Only truly global keymaps in keymaps.lua
**Tests**: All global navigation and utility keymaps work
**Status**: Not Started

### Global Keymaps Only:
- Window navigation (Ctrl+hjkl)
- Buffer management (leader+b...)
- Quickfix navigation (leader+q...)
- Utility keymaps (Esc, line numbers, clipboard)
- Custom motions (line movement, increment/decrement)
- Terminal safe navigation
- Visual mode improvements

### Plugin-Specific Keymaps (move to respective plugin files):
- Telescope keymaps → telescope.lua
- Gitsigns keymaps → gitsigns.lua
- Neo-tree keymaps → neo-tree.lua
- Todo navigation → todo-comments.lua
- LSP keymaps → nvim-lspconfig.lua
- Format keymaps → conform.lua
- Copilot keymaps → copilot.lua

---

## Stage 5: Entry Point Optimization
**Goal**: Minimal init.lua that loads everything correctly
**Success Criteria**: All plugins load, no conflicts, same functionality
**Tests**: Complete functionality test, startup performance
**Status**: Not Started

### New init.lua:
```lua
-- Global Settings
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.g.copilot_no_tab_map = true

-- Load configuration
require('config.options')
require('config.autocmds')
require('config.keymaps')

-- Load all plugins
require('plugins')
```

### plugins/init.lua structure:
```lua
-- Setup lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
-- ... lazy setup code ...

require('lazy').setup({
  -- Import every individual plugin file
  { import = 'plugins.vim-sleuth' },
  { import = 'plugins.gitsigns' },
  { import = 'plugins.vim-visual-multi' },
  -- ... import every plugin file ...
  
  -- Keep existing custom plugins
  { import = 'custom.plugins' },
})
```

---

## Benefits of Complete Plugin Separation

### Advantages:
- **Ultimate modularity** - Each plugin completely self-contained
- **Easy debugging** - Issues isolated to single files
- **Simple sharing** - Share individual plugin configs easily  
- **Clear dependencies** - Each file shows exactly what it needs
- **No conflicts** - Plugin keymaps and configs never interfere
- **Conditional loading** - Comment out single import to disable
- **Better git history** - Changes to one plugin don't affect others
- **Easy customization** - Modify one plugin without touching others

### Special Considerations:
1. **Dependencies** - Some plugins depend on others (telescope extensions)
2. **Load order** - Ensure proper loading sequence
3. **Shared config** - Some settings might be shared (diagnostic config)
4. **Import management** - plugins/init.lua manages all imports
5. **Fix typo** - Line 1171: `reqtire` → `require`

### Testing Strategy:
- Extract plugins in dependency order (dependencies first)
- Test each plugin individually after extraction
- Verify all keymaps work correctly
- Check lazy.nvim dashboard shows all plugins
- Ensure startup performance isn't degraded
- Test plugin interactions still work