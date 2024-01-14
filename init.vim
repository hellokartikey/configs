" Binding Table
"
" NORMAL
"   <TAB>   : Move to next buffer
"   <S-TAB> : Move to prev buffer
"   <C-w>   : Close current buffer
"   <S-w>   : Show whitespaces
"   <C-b>   : Open NERDTree
"   <C-f>   : Find current buffer in NERDTree
"
" VISUAL
"   >       : Indent selected lines one unit
"   <       : Unindent selected lines one unit

call plug#begin()

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdtree'

call plug#end()

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
nnoremap <C-w> :bdelete<CR>

" Indent
vnoremap < <gv
vnoremap > >gv

" Show whitespaces
set listchars=tab:▸\ ,eol:¬,space:.
nnoremap <S-w> :set list!<CR>

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
nnoremap <C-b> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
let g:NERDTreeMinimalUI = 1
let g:NERDTreeMinimalMenu = 1
let g:NERDTreeShowHidden = 1
let g:NERDTreeIgnore = ['__pycache__$', '.git$']

" Silently open file as buffer
let NERDTreeCustomOpenArgs = {
  \ 'file': {'reuse': 'all', 'where': 'p', 'keepopen': 1, 'stay': 1},
  \ 'dir': {} }

" Close vim when NERDTree is the last window
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

