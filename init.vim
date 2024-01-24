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
"
"   <leader>t   : Toggle NERDTree
"   <leader>y   : Find current buffer in NERDTree
"
"   <leader>u   : Toggle Undotree
"
"   <leader>f   : Open FZF
"   <leader>g   : Open FZF Buffers
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
endif

call plug#end()

" Leader key
let g:mapleader = ' '

" Enable syntax highlight
syntax on

" Disable mouse
set mouse=

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
set listchars=tab:▸\ ,eol:¬,space:.
nnoremap <leader>e :set list!<CR>

" Lines
set number
set relativenumber
set nowrap
set scrolloff=8

" Highlight Lines
set colorcolumn=80,120
set cursorline

" Tabs
set tabstop=2
set shiftwidth=2
set expandtab

" Colors
function! SetColorScheme()
  if &background == "dark"
    highlight Visual term=reverse cterm=none ctermbg=238
    highlight CursorLine term=reverse cterm=none ctermbg=236
  elseif &background == "light"
    highlight Visual term=reverse cterm=none ctermbg=251
    highlight CursorLine term=reverse cterm=none ctermbg=253
  endif
endfunction
command! SetColorScheme call SetColorScheme()

autocmd OptionSet background SetColorScheme
autocmd VimEnter * SetColorScheme

highlight! link CursorLineNR CursorLine
highlight! link ColorColumn CursorLine

" Tree Setup
nnoremap <leader>t :NERDTreeToggle<CR>
nnoremap <leader>y :NERDTreeFind<CR>
let g:NERDTreeMinimalUI = 1
let g:NERDTreeMinimalMenu = 1
let g:NERDTreeShowHidden = 1
let g:NERDTreeIgnore = ['__pycache__$', '.git$']

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

" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" File types
au BufRead,BufNewFile *.qrc setfiletype xml
au BufRead,BufNewFile *.qml setfiletype qmljs

if has('nvim')
  " Treesitter Setup
  lua require('treesitter')
endif

