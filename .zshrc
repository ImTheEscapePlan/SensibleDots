# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
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

# insert custom aliases here
alias ls='eza --icons --color=always --group-directories-first'
alias ll='eza -al --icons --git --group-directories-first'
alias lt='eza --tree --level=2 --icons'
alias vim='nvim'
# comment out vim alias line if you want to use regular vim
# end of aliases

export EDITOR=nvim
export VISUAL=nvim
export SYSTEMD_EDITOR=nvim
export TERMINAL="kitty"
export TERMCMD="kitty"
export XDG_CONFIG_HOME="$HOME/.config"
ZVM_INIT_MODE=sourcing
# Editor/Visual 'Export' sections can be changed to use vim

source '/usr/share/zsh-antidote/antidote.zsh'
antidote load

eval "$(fzf --zsh)"
eval "$(zoxide init zsh --cmd cd)"
eval "$(starship init zsh)"
eval "$(zsh-patina activate)"
fastfetch
