#
# ~/.bashrc
# Load using .bash_profile
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Set TERM
TERM='xterm-256color'

alias ls='ls --color=auto'

alias up='cd ..'

# Cycle through all candidates
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

# Store Return Value
PROMPT_COMMAND='RETURN_VALUE=$?;'

# Version Control Parse
__rc_prompt_git() {
    $(git rev-parse --is-inside-git-dir 2>/dev/null ) \
        && return 1
    $(git rev-parse --is-inside-work-tree 2>/dev/null ) \
        || return 1
    git status &>/dev/null
    branch=$(git symbolic-ref --quiet HEAD 2>/dev/null ) \
        || branch=$(git rev-parse --short HEAD 2>/dev/null ) \
        || branch='unknown'
    branch=${branch##*/}
    git diff --quiet --ignore-submodules --cached \
        || state=${state}+
    git diff-files --quiet --ignore-submodules -- \
        || state=${state}!f
    $(git rev-parse --verify refs/stash &>/dev/null ) \
        && state=${state}^
    [ -n "$(git ls-files --others --exclude-standard )" ] \
        && state=${state}?
    printf ' [git: %s]' "${branch:-unknown}${state}"
}

__rc_prompt_hg() {
    hg branch &>/dev/null || return 1
    BRANCH="$(hg branch 2>/dev/null)"
    [[ -n "$(hg status 2>/dev/null)" ]] && STATUS="!"
    printf ' [hg: %s]' "${BRANCH:-unknown}${STATUS}"
}

__rc_prompt_svn() {
    svn info &>/dev/null || return 1
    URL="$(svn info 2>/dev/null | \
        awk -F': ' '$1 == "URL" {print $2}')"
    ROOT="$(svn info 2>/dev/null | \
        awk -F': ' '$1 == "Repository Root" {print $2}')"
    BRANCH=${URL/$ROOT}
    BRANCH=${BRANCH#/}
    BRANCH=${BRANCH#branches/}
    BRANCH=${BRANCH%%/*}
    [[ -n "$(svn status 2>/dev/null)" ]] && STATUS="!"
    printf ' [svn: %s]' "${BRANCH:-unknown}${STATUS}"
}

VERSION_CONTROLLER='git'

__rc_prompt_vcs() {
	if [ $VERSION_CONTROLLER == 'git' ]; then
		__rc_prompt_git
	elif [ $VERSION_CONTROLLER == 'hg' ]; then
		__rc_prompt_hg
	elif [ $VERSION_CONTROLLER == 'svn' ]; then
		__rc_prompt_svn
	fi
}

__rc_status() {
	if [ $RETURN_VALUE != 0 ]; then
		cols=$(tput cols)
		cols=$(( $cols - 3 ))
		cols="\033[${cols}G"
		tput setaf 1
		printf "$cols'_'"
	fi
}

__rc_venv() {
	if [ -z "$VIRTUAL_ENV" ]; then
		printf '╭'
	else
		printf '╭─<%s>\n├' $(basename $VIRTUAL_ENV)
	fi
}

# Disable Default Virtual Env Prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

# PS Strings
PS1='\[$(tput bold)\]\[$(tput dim)\]\[$(tput setaf 6)\]$(__rc_venv)\w\[$(tput setaf 2)\]$(__rc_prompt_vcs)$(__rc_status)\n\[$(tput setaf 6)\]├\$ \[$(tput sgr0)\]'
PS2='\[$(tput dim)\]\[$(tput setaf 6)\]├\[$(tput bold)\]> \[$(tput sgr0)\]'

# mkdir and cd
cd_new_dir() {
	if [ -z $1 ]; then
		echo "Usage : cd_new_dir DIRECTORY_NAME"
	else
		dir_name=$1
		i=2
		while [ "${!i}" != "" ]
		do
			dir_name="$dir_name ${!i}"
			i=$(($i + 1))
		done
		mkdir "$dir_name"
		cd "$dir_name"
	fi
}

# Disable Duplicates in ~/.bash_history
export HISTCONTROL=ignoreboth:erasedups

export PATH="~/.local/bin/:$PATH"
