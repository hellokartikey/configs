VIM_CONFIG = init.vim
TMUX_CONFIG = tmux.conf
ZSHRC = zshrc

all: vim_conf nvim_conf tmux zsh

zsh: ${ZSHRC}
	cp ~/.zshrc
	@echo "New .zshrc installed. Source it."

tmux: ${TMUX_CONFIG}
	mkdir -p ~/.config/tmux
	ln -sf ${PWD}/${TMUX_CONFIG} ~/.config/tmux/${TMUX_CONFIG}
	@echo "New tmux config installed. Install plugins with prefix+I"

tmux_plugins:
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

vim_conf: ${VIM_CONFIG}
	ln -sf ${PWD}/${VIM_CONFIG} ~/.vimrc
	@echo "New vim config installed. Install plugins with :PlugInstall"

nvim_conf: ${VIM_CONFIG}
	mkdir -p ~/.config/nvim/lua
	ln -sf ${PWD}/${VIM_CONFIG} ~/.config/nvim/${VIM_CONFIG}
	ln -sf ${PWD}/treesitter.lua ~/.config/nvim/lua/treesitter.lua
	@echo "New nvim config installed. Install plugins with :PlugInstall"

vim_plug:
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim_plug:
	sh -c "curl -fLo \
		'${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim' \
		--create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

ohmyzsh:
	sh -c "$(curl -fsSL \
		https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	git clone https://github.com/zsh-users/zsh-autosuggestions.git \
		~/.ohmyzsh/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
		~/.ohmyzsh/plugins/zsh-syntax-highlighting

