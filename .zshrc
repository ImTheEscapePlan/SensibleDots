# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/ctrlescape/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	command rm -f -- "$tmp"
}

export EDITOR=vim
export VISUAL=vim
export SYSTEMD_EDITOR=vim
export TERMCMD="kitty"
export XDG_CONFIG_HOME="$HOME/.config"

source '/usr/share/zsh-antidote/antidote.zsh'
antidote load

eval "$(starship init zsh)"
fastfetch
