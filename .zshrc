# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=45000
setopt appendhistory
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/n/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

source ~/.aliases
export DISPLAY=:0
set -o vi
# xrdb ~/.Xresources
setopt completealiases

#Turn on 256 color support
if [ "x$TERM" = "xxterm" ]
then
    export TERM="xterm-256color"
fi

autoload -Uz promptinit
autoload -U colors && colors

promptinit
prompt adam1 '24' '24'


#Numeric Keypad
bindkey "^[OH" beginning-of-line
bindkey "^[OF" end-of-line
bindkey -s "^[5~" "Prior"
bindkey -s "^[6~" "Next"
bindkey -s "^[Oo" "/"
bindkey -s "^[Oj" "*"
bindkey -s "^[Om" "-"
bindkey -s "^[Ok" "+"
