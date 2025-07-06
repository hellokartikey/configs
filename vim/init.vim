" Binding Table
"
" LEADER
"   <SPACE>
"
" NORMAL
"   <leader>n   : Move to next buffer
"   <leader>p   : Move to prev buffer
"
"   <leader>w   : Close current buffer
"   <leader>s   : Update current buffer
"   <leader>o   : Open a buffer
"
"   <leader>e   : Show whitespaces
"   <leader>r   : Toggle relative line number
"   <leader>l   : Toggle line numbers
"   <leader>c   : Toggle cursor line
"
"   <leader>u   : Toggle Undotree
"
"   <leader>x   : Toggle Trouble
"
" LSP BINDS
"   <C-p>       : Move selection up, trigger lsp menu if not visible
"   <C-n>       : Move selection down, trigger lsp menu if not visible
"   <C-y>       : Confirm lsp selection
"   <C-e>       : Close lsp menu
"
"   K           : Show hover information
"   gd          : Jump to defintion
"   gD          : Jump to declaration
"   gi          : List all implementations
"   go          : Jump to type definition
"   gr          : List all references
"   gs          : Display signature information
"   gcc         : Comment a line
"
"   [d          : Move to previous diagnostic
"   ]d          : Move to next diagnostic
"
" VISUAL
"   >           : Indent selected lines one unit
"   <           : Unindent selected lines one unit
"

call plug#begin()

Plug 'tpope/vim-surround'

Plug 'tpope/vim-commentary'

Plug 'mbbill/undotree'

Plug 'christoomey/vim-tmux-navigator'

Plug 'christoomey/vim-system-copy'

if has('nvim')

  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

  Plug 'honza/vim-snippets'
  Plug 'L3MON4D3/LuaSnip', {'tag': 'v2.*', 'do': 'make install_jsregexp'}
  Plug 'saadparwaiz1/cmp_luasnip'

  Plug 'neovim/nvim-lspconfig'
  Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v3.x'}

  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'

  Plug 'folke/trouble.nvim'

endif

call plug#end()

" Leader key
let g:mapleader = ' '

" Enable syntax highlight
set notermguicolors

" Enable mouse
set mouse=a

" Status Line
highlight clear StatusLineNC

set laststatus=2
set statusline=
set statusline+=\ %f       " filename
set statusline+=\ %m       " is modified
set statusline+=%=         " middle space
set statusline+=%=         " right space
set statusline+=%y         " filetype
set statusline+=\ %5l:%-3c " line:col
set statusline+=\ %P       " percentage
set statusline+=\          " margin

" Tab Line
nnoremap <leader>n :bnext<CR>
nnoremap <leader>p :bprevious<CR>
nnoremap <leader>w :bdelete<CR>

highlight clear TabLineFill
highlight clear TabLine
highlight! link TabLineSel StatusLine

" TODO - Add scrolling support
function HkTabLine()
  let s = ''

  for i in filter(range(1, bufnr('$')), 'buflisted(v:val)')
    if i == bufnr()
      let s ..= '%#TabLineSel#'
    else
      let s ..= '%#TabLine#'
    endif

    let s ..= ' ' .. bufname(i) .. ' '
  endfor

  let s ..= '%#TabLineFill#%T'

  return s
endfunction

set showtabline=2
set tabline=%!HkTabLine()

" File management
nnoremap <leader>s :update<CR>
nnoremap <leader>o :edit<space>

" Undotree
nnoremap <leader>u :UndotreeToggle<CR>
let g:undotree_WindowLayout = 3
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_ShortIndicators = 1
let g:undotree_ShortIndicators = 1
let g:undotree_SplitWidth = 30
let g:undotree_DiffpanelHeight = 10
let g:undotree_HelpLine = 0

if has("persistent_undo")
    let target_path = expand('~/.cache/undodir/vim')

    if has('nvim')
      let target_path = expand('~/.cache/undodir')
    endif

    if !isdirectory(target_path)
        call mkdir(target_path, "p", 0700)
    endif

    let &undodir=target_path
    set undofile
endif

" Indent
vnoremap < <gv
vnoremap > >gv

" Search
set ignorecase
set smartcase

" Show whitespaces
set listchars=tab:🡲\ ,eol:¶,space:•

nnoremap <leader>e :set list!<CR>

" Trailing spaces
highlight ExtraWhitespace ctermbg=9
match ExtraWhitespace /\s\+$/

" Lines
set nowrap
set scrolloff=3

nnoremap <leader>r :set relativenumber!<CR>
nnoremap <leader>l :set number!<CR>

" Highlight Lines
set colorcolumn=80,120
nnoremap <leader>c :set cursorline!<CR>

" Tabs
set tabstop=2
set shiftwidth=2
set expandtab

" Colors
highlight clear Visual
highlight Visual cterm=reverse
highlight CursorLine term=reverse cterm=none ctermbg=236
highlight PMenu term=reverse cterm=none ctermbg=240 ctermfg=15
highlight PMenuSel cterm=bold ctermbg=232 ctermfg=12

" Auto light/dark mode colors
function! HKSetColorScheme()
  if &background == 'light'
    highlight CursorLine term=reverse cterm=none ctermbg=0
  elseif &background == 'dark'
    highlight CursorLine term=reverse cterm=none ctermbg=236
  endif
endfunction

autocmd OptionSet background call HKSetColorScheme()

highlight! link CursorLineNR CursorLine
highlight! link ColorColumn CursorLine

" File types
au BufRead,BufNewFile *.qrc setfiletype xml
au BufRead,BufNewFile *.qml setfiletype qmljs

if has('nvim')
  " Trouble Setup
  nnoremap <leader>x :Trouble diagnostics toggle<CR>

  " Treesitter Config
  lua require('treesitter')

  " Trouble Config
  lua require('error_menu')

  " Mason Config
  lua require('mason-lsp')

  " Snippets
  lua require('snippets')
endif
