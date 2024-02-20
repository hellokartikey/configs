export ZSH="$HOME/.oh-my-zsh"

# Path
export PATH=$HOME/.local/bin:$PATH
export PATH=/var/lib/flatpak/exports/bin:$PATH
export PATH=$HOME/.local/share/flatpak/exports/bin:$PATH

# Theme
ZSH_THEME="ktheme"

# tmux
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_CONFIG=~/.config/tmux/tmux.conf

# Disable automatic updates
zstyle ':omz:update' mode disabled

# Plugins
plugins=(tmux virtualenv zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# man pages
export MANPATH="/usr/local/man:$MANPATH"

# Default editor
export EDITOR=nvim

# Alias
alias ls='ls --group-directories-first --color=tty'

# open command
function open () {
    xdg-open $@ &> /dev/null
}

# app command
function app () {
    ( $@ &> /dev/null & ) ;
}

