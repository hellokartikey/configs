VIM_CONFIG = init.vim
TMUX_CONFIG = tmux.conf

all: vim_conf nvim_conf

tmux: ${TMUX_CONFIG}
	mkdir -p ~/.config/tmux
	ln -sf ${PWD}/${TMUX_CONFIG} ~/.config/tmux/${TMUX_CONFIG}

vim_conf: ${VIM_CONFIG}
	ln -sf ${PWD}/${VIM_CONFIG} ~/.vimrc

nvim_conf: ${VIM_CONFIG}
	mkdir -p ~/.config/nvim/lua
	ln -sf ${PWD}/${VIM_CONFIG} ~/.config/nvim/${VIM_CONFIG}
	ln -sf ${PWD}/treesitter.lua ~/.config/nvim/lua/treesitter.lua

vim_plug:
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim_plug:
	sh -c "curl -fLo \
		'${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim' \
		--create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

