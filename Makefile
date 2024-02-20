SCRIPTS_DIR = ${PWD}/scripts

ZSH_DIR = ${PWD}/zsh
TMUX_DIR = ${PWD}/tmux
VIM_DIR = ${PWD}/vim

VIM_CONFIG = ${VIM_DIR}/init.vim
VIM_THEME = ${VIM_DIR}/16color.vim
VIM_TREE = ${VIM_DIR}/treesitter.lua

TMUX_CONFIG = ${TMUX_DIR}/tmux.conf

ZSH_RC = ${ZSH_DIR}/zshrc
ZSH_THEME = ${ZSH_DIR}/ktheme.zsh-theme

DOWNLOAD_NVIMPLUG = ${SCRIPTS_DIR}/nvim_plug.sh
DOWNLOAD_VIMPLUG = ${SCRIPTS_DIR}/vim_plug.sh
DOWNLOAD_TPM = ${SCRIPTS_DIR}/tpm.sh
DOWNLOAD_OMZ = ${SCRIPTS_DIR}/ohmyzsh.sh

all: vim_conf nvim_conf tmux zsh

zsh: ${ZSH_RC} ohmyzsh
	@cp ${ZSH_RC} ~/.zshrc
	@ln -sf ${ZSH_THEME} ~/.oh-my-zsh/themes/
	@echo "New .zshrc installed. Source it."

tmux: ${TMUX_CONFIG} tmux_plugins
	@mkdir -p ~/.config/tmux
	@ln -sf ${TMUX_CONFIG} ~/.config/tmux/
	@echo "New tmux config installed. Install plugins with prefix+I"

vim_conf: ${VIM_CONFIG} vim_plug
	@ln -sf ${VIM_CONFIG} ~/.vimrc
	@echo "New vim config installed. Install plugins with :PlugInstall"

nvim_conf: ${VIM_CONFIG} nvim_plug
	@mkdir -p ~/.config/nvim/lua
	@ln -sf ${VIM_CONFIG} ~/.config/nvim/
	@ln -sf ${VIM_TREE} ~/.config/nvim/lua/
	@echo "New nvim config installed. Install plugins with :PlugInstall"

vim_plug:
	@sh ${DOWNLOAD_VIMPLUG}

nvim_plug:
	@sh ${DOWNLOAD_NVIMPLUG}

ohmyzsh:
	sh ${DOWNLOAD_OMZ}

tmux_plugins:
	@sh ${DOWNLOAD_TPM}

