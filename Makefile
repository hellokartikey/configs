VIM_CONFIG = init.vim

all: vim_conf nvim_conf

vim_conf: ${VIM_CONFIG}
	ln -sf ${PWD}/init.vim ~/.vimrc

nvim_conf: ${VIM_CONFIG}
	mkdir -p ~/.config/nvim/lua
	ln -sf ${PWD}/init.vim ~/.config/nvim/init.vim
	ln -sf ${PWD}/treesitter.lua ~/.config/nvim/lua/treesitter.lua

vim_plug:
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim_plug:
	sh -c 'curl -fLo \
		"${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" \
		--create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

