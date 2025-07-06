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
"   <leader>b   : Navigate buffers
"
"   <leader>e   : Show whitespaces
"   <leader>r   : Toggle relative line number
"   <leader>l   : Toggle line numbers
"   <leader>c   : Toggle cursor line
"   <leader>k   : Toggle vertical line
"   <leader>h   : Toggle highlight
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
Plug 'christoomey/vim-tmux-navigator'

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

" General
colorscheme default
syntax off
let g:mapleader = ' '
set mouse=a
set notermguicolors
set clipboard=unnamedplus
set tabstop=2
set shiftwidth=2
set expandtab
set nowrap
set scrolloff=3
set showtabline=2
set tabline=%!HkTabLine()
match ExtraWhitespace /\s\+$/

" Status Line
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
set ignorecase
set smartcase
set listchars=tab:🡲\ ,eol:¶,space:•

" Remaps
nnoremap <leader>n :bnext<CR>
nnoremap <leader>p :bprevious<CR>
nnoremap <leader>w :bdelete<CR>
nnoremap <leader>s :update<CR>
nnoremap <leader>o :edit<space>
nnoremap <leader>b :buffers<CR>:buffer *
nnoremap <leader>e :set list!<CR>
nnoremap <leader>r :set relativenumber!<CR>
nnoremap <leader>l :set number!<CR>
nnoremap <leader>c :set cursorline!<CR>
nnoremap <leader>k :execute "set cc=" . (&cc == "" ? "80,120" : "")<CR>
nnoremap <leader>h :TSToggle highlight<CR>
vnoremap < <gv
vnoremap > >gv

" TODO - Add scrolling support
" TODO - Move away from buffer tab line
function HkTabLine()
  let s = ''

  for i in filter(range(1, bufnr('$')), 'buflisted(v:val)')
    if i == bufnr()
      let s ..= '%#TabLineSel#'
    else
      let s ..= '%#TabLine#'
    endif

    let s ..= ' '

    if bufname(i) == ''
      let s ..= '*'
    else
      let s ..= bufname(i)
    endif

    let s ..= ' '
  endfor

  let s ..= '%#TabLineFill#%T'

  return s
endfunction

" Colors
highlight clear TabLineFill
highlight clear TabLine
highlight! link TabLineSel StatusLine
highlight ExtraWhitespace ctermbg=9
highlight clear StatusLineNC
highlight clear Visual
highlight Visual cterm=reverse
highlight CursorLine term=reverse cterm=none ctermbg=236
highlight PMenu term=reverse cterm=none ctermbg=240 ctermfg=15
highlight PMenuSel cterm=bold ctermbg=232 ctermfg=12
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
