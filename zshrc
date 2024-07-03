# zsh options
setopt auto_cd
setopt auto_menu
setopt auto_param_slash
setopt auto_remove_slash

setopt nobeep
setopt nolist_beep

setopt HIST_SAVE_NO_DUPS # Don't write duplicate events to history file

# Auto-completion
autoload -U compinit; compinit
_comp_options+=(globdots) # Include hidden files in completion

# Configure Zsh with Vi mode
# bindkey -v
# export KEYTIMEOUT=1
# autoload -Uz edit-command-line
# zle -N edit-command-line
# bindkey -M vicmd v edit-command-line

# Prompt style
PS1="%B%F{cyan}[%1~] > %f%b"

source ~/.config/dotfiles/$(uname)-zsh-conf

if [[ -f ${ZDOTDIR:a}/zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source ${ZDOTDIR:a}/zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
