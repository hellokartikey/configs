call plug#begin()

Plug 'vim-airline/vim-airline'

Plug 'preservim/nerdtree'

call plug#end()

" Airline Stuff
let g:airline#extensions#tabline#enabled = 1
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
highlight CursorLine ctermbg=236 cterm=none
highlight CursorLineNr ctermbg=236 cterm=none
highlight ColorColumn ctermbg=236
highlight Visual ctermbg=239

" Tree Setup
nmap <C-b> :NERDTreeToggle<CR>

