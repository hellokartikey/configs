call plug#begin()

Plug 'vim-airline/vim-airline'

Plug 'preservim/nerdtree'

call plug#end()

" Airline Stuff
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'
let g:airline_symbols_ascii = 1

" Switch tabs
nnoremap <TAB> :bnext<CR>
nnoremap <S-TAB> :bprevious<CR>

" Indent
vnoremap < <gv
vnoremap > >gv

" Show whitespaces
set listchars=tab:▸\ ,eol:¬,space:.
nnoremap <S-w> :set list!<CR>

" Lines
syntax on
set tabstop=2
set shiftwidth=2
set expandtab
set number
set relativenumber
set colorcolumn=80,120
set cursorline

" Colors
if &background ==# "dark"
  highlight Visual term=reverse cterm=none ctermbg=238
  highlight CursorLine term=reverse cterm=none ctermbg=236
elseif &background ==# "light"
  highlight Visual term=reverse cterm=none ctermbg=251
  highlight CursorLine term=reverse cterm=none ctermbg=253
endif

highlight! link CursorLineNR CursorLine
highlight! link ColorColumn CursorLine

" Tree Setup
nnoremap <C-b> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
let NERDTreeQuitOnOpen=1
let NERDTreeMinimalUI=1
let NERDTreeMinimalMenu=1

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

