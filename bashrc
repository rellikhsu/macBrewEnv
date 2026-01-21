#bash completion
# Google Cloud SDK bash completion (portable)
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/google-cloud-sdk/completion.bash.inc" ]; then
        . "$HOME/google-cloud-sdk/completion.bash.inc"
    fi
fi

# Setup HOMEBREW_PREFIX if not already set (e.g. non-interactive shell or profile skipped)
if [ -z "$HOMEBREW_PREFIX" ]; then
    if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

# Load profile.d scripts from the correct Homebrew location
if [ -n "$HOMEBREW_PREFIX" ] && [ -d "$HOMEBREW_PREFIX/etc/profile.d" ]; then
    for file in "$HOMEBREW_PREFIX"/etc/profile.d/*.sh; do
    	if [ -f "$file" ]; then
        	. "$file"
		fi
	done
fi

#bash-git-prompt
if [ -n "$HOMEBREW_PREFIX" ] && [ -f "$HOMEBREW_PREFIX/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR="$HOMEBREW_PREFIX/opt/bash-git-prompt/share"
  source "$HOMEBREW_PREFIX/opt/bash-git-prompt/share/gitprompt.sh"
fi

#
export PS1="\[$(tput setaf 15)\]\u\[$(tput setaf 81)\]@\[$(tput setaf 8)\]\h\[$(tput setaf 34)\](\T)\[$(tput setaf 226)\][\w]\[$(tput sgr0)\]$"
export LANG=en_US.UTF-8
export LANGUAGE=en_US:us
export GREP_COLORS='ms=01;32:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36'
export HISTFILESIZE=10000
export HISTSIZE=10000
export EDITOR="/usr/bin/vim"
#export LESS_TERMCAP_mb=$'\E[01;31m'
#export LESS_TERMCAP_md=$'\E[01;38;5;208m'
#export LESS_TERMCAP_me=$'\E[0m'
#export LESS_TERMCAP_se=$'\E[0m'
#export LESS_TERMCAP_so=$'\E[01;44;33m'
#export LESS_TERMCAP_ue=$'\E[0m'
#export LESS_TERMCAP_us=$'\E[04;38;5;111m'
export BASH_SILENCE_DEPRECATION_WARNING=1
export CLOUDSDK_PYTHON_SITEPACKAGES=1
shopt -s autocd
shopt -s cdable_vars
shopt -s cdspell
shopt -s cmdhist
shopt -s histappend
shopt -s hostcomplete
unset PROMPT_COMMAND

#my aliases
case `uname` in
        Darwin|*BSD)
        export LSCOLORS="gxfxcxdxbxegedabagacad"
        alias ls='ls -FG'
        alias l='ls -alhiFG'
        alias ll='ls -alhiFG'
        #alias count='du -d1 | sort -g'
        ;;
        Linux)
        alias ls='ls -F --color=always'
        alias l='ls -alhiF --color=always'
        alias ll='ls -alhiF --color=always'
        alias count='find . -maxdepth 1 -type d -exec du -s {} \; | sort -g'
        ;;
esac

alias ...='cd ../..'
alias ..='cd ..'
alias e='/usr/bin/clear && exit'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias s='sync;sync;sync'
alias top='zenith'
