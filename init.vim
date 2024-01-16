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
"   <leader>t   : Open NERDTree
"   <leader>f   : Find current buffer in NERDTree
"
" VISUAL
"   >           : Indent selected lines one unit
"   <           : Unindent selected lines one unit
"

call plug#begin()

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdtree'

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

" Airline Stuff
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'default'
let g:airline_symbols_ascii = 1
let g:airline_theme = 'base16_colors'

" Switch tabs
nnoremap <TAB> :bnext<CR>
nnoremap <S-TAB> :bprevious<CR>
nnoremap <leader>w :bdelete<CR>

" File management
nnoremap <leader>s :update<CR>
nnoremap <leader>o :edit<space>

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
nnoremap <leader>f :NERDTreeFind<CR>
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

