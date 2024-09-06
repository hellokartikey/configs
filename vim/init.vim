" Binding Table
"
" LEADER
"   <SPACE>
"
" NORMAL
"   <TAB>       : Move to next buffer
"   <S-TAB>     : Move to prev buffer
"
"   <leader>w   : Close current buffer
"   <leader>s   : Update current buffer
"   <leader>o   : Open a buffer
"
"   <leader>e   : Show whitespaces
"   <leader>r   : Toggle relative line number
"   <leader>l   : Toggle line numbers
"
"   <leader>t   : Toggle NERDTree
"   <leader>y   : Find current buffer in NERDTree
"
"   <leader>u   : Toggle Undotree
"
"   <leader>x   : Toggle Trouble
"
"   <leader>f   : Open FZF
"   <leader>g   : Open FZF Buffers
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
"
"   [d          : Move to previous diagnostic
"   ]d          : Move to next diagnostic
"
" VISUAL
"   >           : Indent selected lines one unit
"   <           : Unindent selected lines one unit
"

call plug#begin()

Plug 'chriskempson/base16-vim'

Plug 'itchyny/lightline.vim'

Plug 'ap/vim-buftabline'

Plug 'preservim/nerdtree'

Plug 'tpope/vim-surround'

Plug 'mbbill/undotree'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

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
syntax on

" Set Folding
set nofoldenable
set foldmethod=indent
set foldcolumn=0

" Enable mouse
set mouse=a

" Lightline
let g:lightline = { 'colorscheme': '16color', }
let g:lightline.enable = { 'statusline': 1, 'tabline': 0 }
set noshowmode

" Switch tabs
nnoremap <TAB> :bnext<CR>
nnoremap <S-TAB> :bprevious<CR>
nnoremap <leader>w :bdelete<CR>

" FZF
let g:fzf_vim = {}
let g:fzf_layout = { 'down': '10' }
let g:fzf_vim.preview_window = []
nnoremap <leader>f :Files<CR>
nnoremap <leader>g :Buffers<CR>

" Buftabline
highlight! BufTabLineCurrent cterm=bold ctermbg=12
highlight! BufTabLineActive cterm=bold ctermbg=8
highlight! link BufTabLineHidden CursorLine
highlight! link BufTabLineFill CursorLine
let g:buftabline_indicators = 1

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
    let target_path = expand('~/.cache/undodir')

    if !isdirectory(target_path)
        call mkdir(target_path, "p", 0700)
    endif

    let &undodir=target_path
    set undofile
endif

" Indent
vnoremap < <gv
vnoremap > >gv

" Show whitespaces
set listchars=tab:⇄\ ,eol:↵,space:.
highlight! Whitespace term=none ctermfg=gray
highlight! link NonText Whitespace
nnoremap <leader>e :set list!<CR>

" Lines
set number
set nowrap
set scrolloff=8

nnoremap <leader>r :set relativenumber!<CR>
nnoremap <leader>l :set number!<CR>

" Highlight Lines
set colorcolumn=80,120
set cursorline

" Tabs
set tabstop=2
set shiftwidth=2
set expandtab

" Colors
highlight Visual term=reverse cterm=none ctermbg=238
highlight CursorLine term=reverse cterm=none ctermbg=236
highlight PMenu term=reverse cterm=none ctermbg=240 ctermfg=15
highlight PMenuSel cterm=bold ctermbg=232 ctermfg=12

set notermguicolors

highlight! link CursorLineNR CursorLine
highlight! link ColorColumn CursorLine

" Tree Setup
nnoremap <leader>t :NERDTreeToggle<CR>
nnoremap <leader>y :NERDTreeFind<CR>
let g:NERDTreeMinimalUI = 1
let g:NERDTreeMinimalMenu = 1
let g:NERDTreeShowHidden = 1
let g:NERDTreeIgnore = ['__pycache__$', '.git$']

" Trouble Setup
nnoremap <leader>x :Trouble diagnostics toggle<CR>

" Silently open file as buffer
let NERDTreeCustomOpenArgs = {
  \ 'file': {'reuse': 'all', 'where': 'p', 'keepopen': 1, 'stay': 1},
  \ 'dir': {} }

" Exit Vim when NERDTree is the only remaining window in the only tab
autocmd BufEnter *
 \ if tabpagenr('$') == 1 &&
 \     winnr('$') == 1 &&
 \     exists('b:NERDTree') &&
 \     b:NERDTree.isTabTree()
 \   | quit |
 \ endif

" Prevent other buffers from replacing the tree
autocmd BufEnter *
  \ if winnr() == winnr('h') &&
  \     bufname('#') =~ 'NERD_tree_\d\+' &&
  \     bufname('%') !~ 'NERD_tree_\d\+' &&
  \     winnr('$') > 1
  \   | let buf=bufnr()
  \   | buffer#
  \   | execute "normal! \<C-W>w"
  \   | execute 'buffer'.buf |
  \ endif

" File types
au BufRead,BufNewFile *.qrc setfiletype xml
au BufRead,BufNewFile *.qml setfiletype qmljs

if has('nvim')
  " Treesitter Config
  lua require('treesitter')

  " Trouble Config
  lua require('error_menu')

  " Mason Config
  lua require('mason-lsp')

  " Snippets
  lua require('snippets')
endif

