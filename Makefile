VIM_CONFIG = init.vim

all: vim_conf nvim_conf

vim_conf: ${VIM_CONFIG} vim_plug
	ln -sf ${PWD}/init.vim ~/.vimrc

nvim_conf: ${VIM_CONFIG} nvim_plug
	ln -sf ${PWD}/init.vim ~/.config/nvim/init.vim

vim_plug:
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim_plug:
	sh -c 'curl -fLo \
		"${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" \
		--create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

