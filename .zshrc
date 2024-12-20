#
# ~/.zshrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return



alias sps='sudo pacman -S'
alias spsy='sudo pacman -Sy'
alias spsyu='sudo pacman -Syu'
alias sprs='sudo pacman -Rs'
alias spq='sudo pacman -Q'
alias spqs='sudo pacman -Qs'

alias ls='ls --color=auto'
alias ll='ls --color=auto -l'
alias la='ls --color=auto -a'
alias lla='ls --color=auto -la'

alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -color=auto'

export LESS='-R --use-color -Dd+r$Du+b$'
export MANPAGER='less -R --use-color -Dd+r -Du+b'
export MANROFFOPT='-P -c'



fpath+=($HOME/.config/pure)
autoload -U promptinit
promptinit
prompt pure
#PROMPT=''
#RPROMPT=''



HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory



autoload -Uz compinit
compinit

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh



bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[3~' bindkey "^[[3~" delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[3;5~' delete-word
bindkey '^H' backward-delete-word


eval "$(zoxide init zsh)"
