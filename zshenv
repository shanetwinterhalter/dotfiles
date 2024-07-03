# XDG vars
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"

# Define editors
export EDITOR="nvim"
export VISUAL="nvim"

# ZSH config
export ZDOTDIR="$XDG_CONFIG_HOME/dotfiles"
export HISTFILE="$ZDOTDIR/.zhistory"
export HISTSIZE=10000
export SAVEHIST=10000

# VIM config
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/dotfiles/vim/vimrc" | source $MYVIMRC'
