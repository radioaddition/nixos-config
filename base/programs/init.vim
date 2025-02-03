call plug#begin()

Plug 'Mofiqul/adwaita.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'NoahTheDuke/vim-just'
Plug 'VonHeikemen/fine-cmdline.nvim'
Plug 'junegunn/fzf'
Plug 'junegunn/vim-easy-align'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'preservim/nerdtree'
Plug 'sQVe/sort.nvim'
Plug 'tpope/vim-fireplace'
Plug 'tpope/vim-sensible'

call plug#end()

lua << EOF
vim.cmd([[runtime! ftplugin/man.vim]])
vim.cmd([[let g:adwaita_transparent = v:true]])
vim.cmd([[silent! colorscheme adwaita]])
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.lazyredraw = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard:append { 'unnamed', 'unnamedplus' }
vim.opt.linebreak = true
vim.opt.scrolloff = 5
vim.cmd([[au InsertEnter * hi CursorLine gui=underline cterm=underline]])
vim.cmd([[au InsertLeave * hi CursorLine gui=none cterm=none guibg=Grey20]])
vim.cmd([[au InsertEnter * hi CursorColumn gui=none cterm=none guibg=transparent]])
vim.cmd([[au InsertLeave * hi CursorColumn gui=none cterm=none guibg=Grey20]])
vim.cmd([[nnoremap <CR> <cmd>FineCmdline<CR>]])
vim.opt.showmode = false
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'adwaita',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
EOF
