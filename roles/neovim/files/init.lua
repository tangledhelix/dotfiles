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
  { src = 'https://github.com/tangledhelix/org-links.nvim' },
})

vim.g.mapleader = ' '

-- https://github.com/nvim-orgmode/orgmode/blob/master/docs/configuration.org

require('orgmode').setup({
  org_agenda_files = '~/orgfiles/**/*',
  org_default_notes_file = '~/orgfiles/refile.org',
  org_todo_keywords = { 'TODO', 'NEXT', '|', 'DONE' },

  -- overview, content, showeverything, inherit
  org_startup_folded = 'content',

  -- default 1 (Mon), set 0 for Sun
  calendar_week_start_day = 0,

  -- I set this to avoid weird highlights from '$',
  -- not because I use LaTeX
  org_highlight_latex_and_related = 'entities',

  org_todo_keyword_faces = {
    NEXT = ':foreground #16181D :background #9AFFFF :weight bold :slant italic',
  },
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'org',
  callback = function()
    vim.opt.shiftwidth = 2
    vim.opt.softtabstop = 2
    -- why? because otherwise org-links leaves virtual blank lines
    vim.opt.wrap = false

    -- add another item to current headings or list
    vim.keymap.set('i', '<S-CR>', '<cmd>lua require("orgmode").action("org_mappings.meta_return")<CR>', {
      silent = true,
      buffer = true,
    })

    -- indent or outdent by shiftwidth
    vim.keymap.set('i', '<Tab>', '<Esc>>>A', { silent = true, buffer = true })
    vim.keymap.set('i', '<S-Tab>', '<Esc><<A', { silent = true, buffer = true })

    -- reclaim {, } functionality taken over by orgmode
    vim.keymap.set('n', 'g{', '{', { noremap = true })
    vim.keymap.set('n', 'g}', '}', { noremap = true })
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'orgagenda',
  callback = function()
    vim.keymap.set('n', '>', ':wincmd +<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<', ':wincmd -<CR>', { noremap = true, silent = true })
  end
})

-- Experimental LSP support
vim.lsp.enable('org')

local harpoon = require('harpoon')
harpoon:setup({
  settings = {
    save_on_toggle = true,
    --sync_on_ui_close = true,
  } 
})

vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end)
vim.keymap.set('n', '<leader><leader>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

require('FTerm').setup({ border = 'double', blend = 0 })
vim.keymap.set('n', '<C-t>', '<CMD>lua require("FTerm").toggle()<CR>')
vim.keymap.set('t', '<C-t>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')

-- ^G plus a register name pastes to FTerm panel (e.g. ^Ga for register a)
-- default register doesn't work with this.
vim.cmd([[tnoremap <expr> <C-G> '<C-\><C-N>"'.nr2char(getchar()).'pi']])

require('lualine').setup({
  options = { theme = 'powerline_dark' },
})

vim.keymap.set('n', '<leader>g', require('lazygit').lazygit, { noremap = true, silent = true })

require('telescope').setup()

-- use vertical layout
-- disabling - breaks orgmode telescope plugin
--require('telescope').setup{
--  defaults = {
--    layout_strategy = 'vertical',
--    --layout_config = { height = 0.95, width = 0.95 },
--  }
--}

-- some of these are off because LSPs aren't installed
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

require('org-bullets').setup()

vim.opt.number = false
vim.opt.relativenumber = true

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

vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 40,
    })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  callback = function()
    vim.opt.shiftwidth = 2
    vim.opt.softtabstop = 2
  end
})

if vim.fn.has('mac') == 1 then
  -- interact with system clipboard (normal or visual modes)
  vim.keymap.set({ 'n', 'x' }, '<leader>y', '"+y')
  vim.keymap.set({ 'n', 'x' }, '<leader>p', '"+p')
  vim.keymap.set({ 'n', 'x' }, '<leader>P', '"+P')
end

vim.keymap.set('n', '<leader>e', vim.cmd.Ex)

-- stretch for Esc less...
vim.keymap.set('i', 'kj', '<Esc>', {})
vim.keymap.set('i', 'jj', '<Esc>', {})

-- and Ctrl...
vim.keymap.set('n', '<leader>w', '<C-w>', {})

-- saner j,k movements
vim.keymap.set({'n', 'x'}, 'j', 'gj', { noremap = true })
vim.keymap.set({'n', 'x'}, 'k', 'gk', { noremap = true })
vim.keymap.set({'n', 'x'}, 'gj', 'j', { noremap = true })
vim.keymap.set({'n', 'x'}, 'gk', 'k', { noremap = true })

vim.api.nvim_create_user_command("Orgstart", function()
  vim.cmd("cd ~/orgfiles")
  vim.cmd("edit main.org")
  require('harpoon'):list():add()
  vim.cmd("vsplit")
  vim.cmd("edit refile.org")
  require('harpoon'):list():add()
  vim.cmd("wincmd l")
  vim.cmd("Org agenda a")
  vim.cmd("2sleep")
  vim.cmd("norm vd.")
end, {})

require('org-links').setup()

