vim.pack.add({
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/nvim-orgmode/orgmode' },
  { src = 'https://github.com/ThePrimeagen/harpoon', version = 'harpoon2' },
  { src = 'https://github.com/numToStr/FTerm.nvim' },
  { src = 'https://github.com/kyazdani42/nvim-web-devicons' },
  { src = 'https://github.com/nvim-lualine/lualine.nvim' },
  { src = 'https://github.com/kdheepak/lazygit.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope.nvim' },
  { src = 'https://github.com/akinsho/org-bullets.nvim' },
  { src = 'https://github.com/nvim-orgmode/telescope-orgmode.nvim' },
  { src = 'https://github.com/kylechui/nvim-surround', version = vim.version.range('4.x') },
})

-- Plugins to look at later:
--
-- terrortylor/nvim-comment
--
-- folke/todo-comments.nvim
--vim.keymap.set('n', ']t', function()
--  require('todo-comments').jump_next()
--end, { desc = 'Next todo comment' })
--vim.keymap.set('n', '[t', function()
--  require('todo-comments').jump_prev()
--end, { desc = 'Previous todo comment' })
--
-- windwp/nvim-autopairs
--
-- RRethy/nvim-treesitter-endwise
--
-- lewis6991/gitsigns.nvim
--
-- tpope/vim-characterize

vim.g.mapleader = ' '

-- line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.keymap.set('n', '<leader>n', ':set number!<CR>:set relativenumber!<CR>', { silent = true })

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

vim.opt.tabstop = 8
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = true
vim.keymap.set('n', '<leader>z', ':set wrap!<CR>:set wrap?<CR>')
-- break at word, not mid-word, if wrap is on
vim.opt.linebreak = true
-- visually indicate a break at left window edge
vim.opt.showbreak = '⟩⟩'

vim.opt.cursorline = true

vim.opt.scrolloff = 2

-- cursor styles; mostly this is defaults with blinking added
vim.opt.guicursor = 'n-v-c-sm:block-blinkon500-blinkoff500,'
                 .. 'i-ci-ve:ver25-blinkon500-blinkoff500,'
                 .. 'r-cr-o:hor20-blinkon500-blinkoff500,'
                 .. 't:block-blinkon500-blinkoff500-TermCursor'

-- uncomment to disable mouse support (default is 'nvi')
--opt.mouse = ''

if vim.fn.has('mac') == 1 then
  -- interact with system clipboard (normal or visual modes)
  vim.keymap.set({ 'n', 'x' }, '<leader>y', '"+y')
  vim.keymap.set({ 'n', 'x' }, '<leader>p', '"+p')
  vim.keymap.set({ 'n', 'x' }, '<leader>P', '"+P')
end

vim.keymap.set('n', '<leader>e', vim.cmd.Ex)

-- stretch for Esc less, handy sometimes
vim.keymap.set('i', 'kj', '<Esc>', {})
vim.keymap.set('i', 'jj', '<Esc>', {})

-- saner j,k movements
vim.keymap.set({'n', 'x'}, 'j', 'gj', { noremap = true })
vim.keymap.set({'n', 'x'}, 'k', 'gk', { noremap = true })
vim.keymap.set({'n', 'x'}, 'gj', 'j', { noremap = true })
vim.keymap.set({'n', 'x'}, 'gk', 'k', { noremap = true })

-- use J/K in visual mode to move lines (and re-indent)
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- --------------------------------------------------------------------------
-- orgmode

-- https://github.com/nvim-orgmode/orgmode/blob/master/docs/configuration.org
require('orgmode').setup({
  org_agenda_files = '~/orgfiles/**/*',
  org_default_notes_file = '~/orgfiles/refile.org',
  org_todo_keywords = { 'TODO', 'NEXT', '|', 'DONE' },

  -- [overview, content, showeverything, inherit]
  org_startup_folded = 'content',

  -- Default 1 (Mon), set 0 for Sun
  calendar_week_start_day = 0,

  -- Avoids weird highlight of '$'; I don't use LaTeX
  org_highlight_latex_and_related = 'entities',

  org_todo_keyword_faces = {
    NEXT = ':foreground #16181D :background #9AFFFF :weight bold :slant italic',
  },
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'org',
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2

    -- Improve display of links
    vim.wo.conceallevel = 2
    vim.wo.concealcursor = 'nc'
    --vim.wo.wrap = false

    -- shift-enter: add another item to list, or add a heading
    vim.keymap.set('i', '<S-CR>', '<cmd>lua require("orgmode").action("org_mappings.meta_return")<CR>', {
      silent = true,
      buffer = true,
    })

    -- insert mode: tab indents or outdents by shiftwidth
    vim.keymap.set('i', '<Tab>', '<Esc>>>A', { silent = true, buffer = true })
    vim.keymap.set('i', '<S-Tab>', '<Esc><<A', { silent = true, buffer = true })

    -- reclaim the { } functionality taken over by orgmode
    vim.keymap.set('n', 'g{', '{', { noremap = true })
    vim.keymap.set('n', 'g}', '}', { noremap = true })

    -- Toggle wrap mode when switching into insert mode.
    -- I prefer wrap be on while editing, but off when viewing because of
    -- concealed link display (specific to orgmode and conceallevel 2).
    --vim.api.nvim_create_autocmd('InsertEnter', {
    --  callback = function()
    --    vim.wo.wrap = true
    --  end,
    --})
    --vim.api.nvim_create_autocmd('InsertLeave', {
    --  callback = function()
    --    vim.wo.wrap = false
    --  end,
    --})

  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'orgagenda',
  callback = function()
    -- grow or shrink agenda window with >, <
    vim.keymap.set('n', '>', ':wincmd +<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<', ':wincmd -<CR>', { noremap = true, silent = true })
  end
})

-- Experimental LSP support
vim.lsp.enable('org')

-- prettification of bullets
require('org-bullets').setup()

-- start up orgmode how I like it
vim.api.nvim_create_user_command('Orgstart', function()
  vim.cmd('cd ~/orgfiles')
  vim.cmd('edit main.org')
  require('harpoon'):list():add()
  vim.cmd('norm zMzX')
  vim.cmd('vsplit')
  vim.cmd('edit refile.org')
  require('harpoon'):list():add()
  vim.cmd('wincmd l')
  vim.cmd('Org agenda a')
  vim.cmd('2sleep')
  vim.cmd('norm vd.')
end, {})

-- --------------------------------------------------------------------------
-- Harpoon

local harpoon = require('harpoon')
harpoon:setup({
  settings = {
    save_on_toggle = true,
    --sync_on_ui_close = true,
  }
})

vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end)
vim.keymap.set('n', '<leader><leader>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

-- --------------------------------------------------------------------------
-- FTerm - terminal window popover

require('FTerm').setup({ border = 'double', blend = 0 })
vim.keymap.set('n', '<C-t>', '<CMD>lua require("FTerm").toggle()<CR>')
vim.keymap.set('t', '<C-t>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')

-- ^G plus a register name pastes to FTerm panel (e.g. ^Ga for register a).
-- the default register doesn't work with this.
vim.cmd([[tnoremap <expr> <C-G> '<C-\><C-N>"'.nr2char(getchar()).'pi']])

-- --------------------------------------------------------------------------
-- lualine - status line

require('lualine').setup({
  options = { theme = 'powerline_dark' },
})

-- --------------------------------------------------------------------------
-- lazygit

vim.keymap.set('n', '<leader>g', require('lazygit').lazygit, { noremap = true, silent = true })

-- --------------------------------------------------------------------------
-- Telescope

require('telescope').setup()

-- use vertical layout
-- disabling - breaks orgmode telescope plugin
--require('telescope').setup{
--  defaults = {
--    layout_strategy = 'vertical',
--    --layout_config = { height = 0.95, width = 0.95 },
--  }
--}

-- some of these are off because related LSPs / plugins aren't installed
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>fa', builtin.resume, { desc = 'Find Again (open picker in previous state)' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find Buffer' })
vim.keymap.set('n', '<leader>fc', builtin.commands, { desc = 'Find Command' })
--vim.keymap.set('n', '<leader>fC', builtin.colorscheme, { desc = 'Find colorscheme' })
--vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Find Diagnostics' })
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find File' })
vim.keymap.set('n', '<leader>fg', builtin.git_files, { desc = 'Find file in Git' })
vim.keymap.set('n', '<leader>fhc', builtin.command_history, { desc = 'Find in Command History' })
vim.keymap.set('n', '<leader>fhs', builtin.search_history, { desc = 'Find in Search History' })
vim.keymap.set('n', '<leader>fj', builtin.jumplist, { desc = 'Find in jumplist' })
vim.keymap.set('n', '<leader>fm', builtin.marks, { desc = 'Find Mark' })
vim.keymap.set('n', '<leader>fr', builtin.registers, { desc = 'Find Registers' })
vim.keymap.set('n', '<leader>fs', builtin.live_grep, { desc = 'Find String' })
--vim.keymap.set('n', '<leader>ft', builtin.treesitter, { desc = 'Find in tree-sitter' })
vim.keymap.set('n', '<leader>f.', builtin.current_buffer_fuzzy_find, { desc = 'Find in current buffer' })

--vim.keymap.set('n', 'gr', builtin.lsp_references, { desc = 'Open a telescope window with references'})

require('telescope').load_extension('orgmode')
local orgext = require('telescope').extensions.orgmode
vim.keymap.set('n', '<leader>foh', orgext.search_headings, { desc = 'Org headlines' })
vim.keymap.set('n', '<leader>fot', orgext.search_tags, { desc = 'Org tags' })
vim.keymap.set('n', '<leader>for', orgext.refile_heading, { desc = 'Org refile' })
vim.keymap.set('n', '<leader>fol', orgext.insert_link, { desc = 'Org insert link' })

-- --------------------------------------------------------------------------
-- nvim-surround plugin

require('nvim-surround').setup()

-- --------------------------------------------------------------------------
-- autocmds

-- when yanking text, briefly flash a selection visually to show what was
-- yanked (40ms)
vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 40,
    })
  end,
})

-- use line numbers in quickfix/location windows
--vim.api.nvim_create_autocmd('Filetype', {
--  pattern = 'qf',
--  callback = function()
--    vim.bo.number = true
--    vim.bo.relativenumber = false
--  end,
--})

-- delete trailing whitespace on lines, when saving.
-- except if it's markdown, then don't. markdown can use EOL spaces
-- for paragraph formatting, which I want sometimes.
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function()
    if vim.bo.filetype ~= 'markdown' then
      vim.cmd([[%s/\s\+$//e]])
    end
  end,
})

-- --------------------------------------------------------------------------
-- per-filetype settings

-- https://neovim.io/doc/user/lua.html#vim.filetype.add()
local function indent_by_two()
  vim.bo.tabstop = 2
  vim.bo.softtabstop = 2
  vim.bo.shiftwidth = 2
end

vim.filetype.add({
  extension = {
    lua = function()
      indent_by_two()
      return 'lua'
    end,
    js = function()
      indent_by_two()
      return 'javascript'
    end,
    yaml = function()
      indent_by_two()
      return 'yaml'
    end,
    yml = function()
      indent_by_two()
      return 'yaml'
    end,
    eyaml = function()
      indent_by_two()
      return 'yaml'
    end,
    json = function()
      indent_by_two()
      return 'json'
    end,
    tt2 = function()
      return 'tt2html'
    end,
  },
})


