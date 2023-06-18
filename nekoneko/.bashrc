#!/bin/sh

case $- in
    *i*) ;;
      *) return;;
esac

jf() {
    tmux attach-session -t X || tmux new-session -s X
}

alias fj=jf
#!/bin/sh

umask 022

# safety
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
alias rm='rm -I --preserve-root'
alias chown='chown'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# Git
alias cg='cd `git rev-parse --show-toplevel || echo .`'
alias gaA='git add -A'
alias gad='git add'
alias gbc='git branch'
alias gcm='git commit'
alias gco='git checkout'
alias gst='git status'
alias glg='git log --graph'
alias gmg='git merge'
alias gdf='git diff'
alias gps='git push'
alias gpl='git pull'
alias gin='git init'
alias gbl='git blame'
alias grm='git rm'

if command -v xclip >/dev/null; then
    gcl() {
        if [ -n "$1" ]; then
            git clone "$@"
        else
            git clone "$(xclip -selection clipboard -o)"
        fi
    }
else
    alias gcl='git clone'
fi

# gcc
alias cc='cc -std=c11 -Wall -Werror -Wshadow -Og -g -fsanitize=address -pedantic'

# rust
alias cr='cargo run'
alias crr='cargo run --release'
alias co='cargo doc --open'
alias cb='cargo build --release'
alias ci='cargo init'
alias cl='cargo rustc -- --emit=llvm-ir'
alias cu='cargo update'
alias rc='rustc'

rr() {
	[ $# = 0 ] && return

    (
    rr_fname="/tmp/rust_run_$$.bin"
    rustc "$@" -o "$rr_fname" || return
    eval "$rr_fname"
    rm -f "$rr_fname"
    )
}

cn() {
	[ $# = 0 ] && return
	cargo new "$@"
	for cn_opt in "$@"; do
		if [ -d "$cn_opt" ]; then
			cd "$cn_opt" || return # make shellcheck happy
			return
		fi
	done
}

# apt
alias apt='sudo apt'
alias sa='apt'
alias au='sudo apt update && sudo apt upgrade && sudo apt full-upgrade && sudo apt-file update && apt autoremove'
alias ai='sudo apt install'
alias ali='apt list --installed'
alias al='apt list'
alias af='apt-file -x find'
alias ap='apt purge'
alias aar='apt autoremove'

# docker
alias dr='docker run'
alias dps='docker ps'
alias sd='sudo docker'
alias sdr='sudo docker run'
alias dl='docker load'
alias di='docker image'
alias dc='docker container'

# poweroff & reboot
alias reboot='sudo reboot'
alias rbt='reboot'
alias poweroff='sudo poweroff'

# ls
alias la='ls -A'
alias ll='ls -lh'
alias lt='ls -hsS1'
alias ls='ls -F'

# grep
alias xg='xargs -0 grep'
alias gv='grep -v'
alias gi='grep -i'
alias giv='grep -vi'
alias ge='egrep'

# Single-char aliases
alias a='ls -A'

c() {
	if [ -t 0 ] && [ "$#" -ge 2 ]; then
		cp "$@"
	else
		clip "$@"
	fi
}

alias d='docker'
alias e='unar'

f() {
	if [ -t 0 ]; then
        if [ $# -eq 0 ]; then
            find .
        elif [ $# -eq 1 ] && [ -d "$1" ]; then
            find "$@"
        else
            f_want_find=n
            for f_local_i in "$@"; do
                if [ "${f_local_i%"${f_local_i#?}"}" != '-' ] && ! [ -e "$f_local_i" ] && ! [ -h "$f_local_i" ]; then
                    f_want_find=y
                    break
                fi
            done
            if [ "$f_want_find" = y ]; then
                find "$@"
            else
                file "$@"
            fi
        fi
    else
		file -
    fi
}

g() {
    if [ $# = 0 ]; then
        git status
    else
        grep "$@"
    fi
}

alias h='head'
alias i='sudo apt install'

j() {
    if [ $# = 0 ]; then
        jobs -l
    else
        diary-add "$@"
    fi
}

alias k='kubectl'

l() {
    if [ -t 0 ]; then
        if [ -t 1 ]; then
            if [ $# = 0 ]; then
                command ls -F
            else
                command ls -Flh "$@"
            fi
        else
            if [ $# = 0 ]; then
                command ls -1
            else
                command ls -d1 "$@"
            fi
        fi
    else
        wc -l "$@"
    fi
}

m() {
	if [ $# = 0 ]; then
        make
	elif [ $# = 1 ] && [ -f "$1" ]; then
		mv "$1" .
    elif [ $# = 1 ]; then
        man "$1"
    else
		mv "$@"
	fi
}

alias o='xdg-open'

p_func() {
	if [ -t 0 ]; then
        if [ $# = 0 ]; then
            pueue status
        elif [ -r "$1" ]; then
            less "$@"
        else
            pueue "$@"
        fi
	else
        if [ $# = 0 ]; then
            less "$@"
        elif [ $# = 1 ] && [ "$1" = '-R' ]; then
            less "$@"
        else
            parallel "$@"
        fi
	fi
}

alias p='p_func '

alias r='rm'

s() {
    if [ -t 0 ]; then
        ssh "$@"
    else
        sort "$@"
    fi
}

t() {
    if [ -t 0 ]; then
        task "$@"
    else
        tail "$@"
    fi
}

u() {
    if [ -t 0 ]; then
        au "$@"
    else
        uniq "$@"
    fi
}

alias v='vi'

w() {
    if [ -t 0 ]; then
        if [ $# = 0 ]; then
            command w
        else
            command -v "$@"
        fi
    else
        wc "$@"
    fi
}

alias x='xargs '
alias y='yes'

# Tools
alias ....='cd ../../../'
alias ...='cd ../..'
alias bc='bc -lq'
alias chomp='tr -d "\n"'
alias cls='clear'
alias cow='curseofwar -W18 -H20'
alias cpv='rsync -ah --info=progress2'
alias cr='cargo run'
alias ct='column -t'
alias fmt='fmt -s'
alias gb='iconv -fgb18030 -tutf8'
alias ipa='ip a'
alias jt='jrnl @tech'
alias mkd='mkdir'
alias nms='nms -cs -f white'
alias nsend='nc -Nnvlp 6737 -q 1'
alias pad='pueue add '
alias rl='exec dash'
alias root='sudo su -'
alias sck='shellcheck -Cauto -s sh'
alias sr='sort -R'
alias tf='tail -f'
alias vdf='vimdiff'
alias wk='genact -m cc'
alias gl='glow -s light -p'
alias wl='wc -l'
alias pp='parallel --pipe -k '
alias pr='parallel'
alias tsi='ts -i "%H:%M:%.S"'
alias mj='make -j$(nproc)'

idle() {
    chrt -i -p $$
    renice -n 19 -p $$
}

vw() {
    vi "$(which "$@")"
}

fw() {
    file "$(which "$@")"
}

ag() {
    ag_pattern="$1"
    [ -z "$ag_pattern" ] && return
    shift
    if [ -z "$*" ]; then
        find . -type f -exec grep -P -H "$ag_pattern" '{}' \;
    else
        find . -type f -a \( "$@" \) -exec grep -P -H "$ag_pattern" '{}' \;
    fi
}

md()
{
	if [ -z "$2" ]; then
		mkdir "$1" || return
		cd "$1" || return # make shellcheck happy
	else
		mkdir "$@"
	fi
}

fk() {
    if command -v fzf; then
        fk_pid=$(ps -ef | sed 1d | fzf -m --tac | awk '{print $2}')

        if [ -n "$fk_pid" ]; then
            echo "$fk_pid" | xargs kill -"${1:-9}"
        fi
    fi
}

oe() {
    [ -z "$1" ] && return 1
    nohup xdg-open "$@" >/dev/null 2>&1 &
    exit
}

# Vim
if command -v vi >/dev/null; then
    EDITOR="vi"
fi

if command -v vim >/dev/null; then
    EDITOR="vim"
    alias vi='vim'
fi

export EDITOR

# Fix typo
alias lw='wl'
alias sl='ls'
alias iv='vi'
alias josb='jobs'
alias lr='rl'
alias dm='md'
alias ig='gi'
alias oo='o'
alias ooo='o'
alias cla='cal'

for path in "$HOME/.bin" "$HOME/.local/bin" "$HOME/bin"; do
    PATH="$path${PATH:+":"}$PATH"
done

export PATH

PS1="$USER@$(uname -n)"
if [ "$(id -u)" = 0 ]; then
    PS1="$PS1 # "
else
    PS1="$PS1 \$ "
fi

mkdir -p ~/.cargo/sccache
export RUSTC_WRAPPER="sccache"
export SCCACHE_DIR="$HOME/.cargo/sccache"
export SCCACHE_MAX_FRAME_LENGTH="104857600"
export SCCACHE_CACHE_SIZE="64G"
#!/bin/sh

alias rl='exec busybox ash'

HISTFILE="$HOME/.ash_history"
HISTFILESIZE=999999999

LAST_LS=$(command ls -xw 80 | sum)
LAST_PWD="$PWD"

_prompt_show_return_value()
{
    prompt_return_value=$?
	test $prompt_return_value -ne 0 && printf '[%s] ' $prompt_return_value
}

_prompt_smart_ls()
{
	smart_ls_this_ls=$(command ls -xw 80 | sum)
	if [ "$LAST_LS" != "$smart_ls_this_ls" ] || [ "$LAST_PWD" != "$PWD" ]; then
		LAST_LS="$smart_ls_this_ls"
		LAST_PWD="$PWD"
        ls -xw 80
        printf "@"
        return
	fi
}

_prompt_fish_path()
{
    awk 'BEGIN {
    pwd = ENVIRON["PWD"];
    home = ENVIRON["HOME"];
    split(pwd, pwd_items, "/");
    split(home, home_items, "/");

    i = 1;
    while (i <= length(home_items) && pwd_items[i] == home_items[i])
        ++i;

    if (i > length(home_items)) {
        printf("~");
    } else {
        i = 2;
    }

    while (i <= length(pwd_items) - 2) {
        printf("/%s", substr(pwd_items[i], 1, 2));
        ++i;
    }

    while (i <= length(pwd_items)) {
        printf("/%s", pwd_items[i]);
        ++i;
    }

    exit(0);
}'
}

PS1='$(_prompt_smart_ls)$(_prompt_show_return_value)\H \A $(_prompt_fish_path)\n\$ '
# bash-preexec.sh -- Bash support for ZSH-like 'preexec' and 'precmd' functions.
# https://github.com/rcaloras/bash-preexec
#
#
# 'preexec' functions are executed before each interactive command is
# executed, with the interactive command as its argument. The 'precmd'
# function is executed before each prompt is displayed.
#
# Author: Ryan Caloras (ryan@bashhub.com)
# Forked from Original Author: Glyph Lefkowitz
#
# V0.5.0
#

# General Usage:
#
#  1. Source this file at the end of your bash profile so as not to interfere
#     with anything else that's using PROMPT_COMMAND.
#
#  2. Add any precmd or preexec functions by appending them to their arrays:
#       e.g.
#       precmd_functions+=(my_precmd_function)
#       precmd_functions+=(some_other_precmd_function)
#
#       preexec_functions+=(my_preexec_function)
#
#  3. Consider changing anything using the DEBUG trap or PROMPT_COMMAND
#     to use preexec and precmd instead. Preexisting usages will be
#     preserved, but doing so manually may be less surprising.
#
#  Note: This module requires two Bash features which you must not otherwise be
#  using: the "DEBUG" trap, and the "PROMPT_COMMAND" variable. If you override
#  either of these after bash-preexec has been installed it will most likely break.

# Tell shellcheck what kind of file this is.
# shellcheck shell=bash

# Make sure this is bash that's running and return otherwise.
# Use POSIX syntax for this line:
if [ -z "${BASH_VERSION-}" ]; then
    return 1;
fi

# We only support Bash 3.1+.
# Note: BASH_VERSINFO is first available in Bash-2.0.
if [[ -z "${BASH_VERSINFO-}" || BASH_VERSINFO[0] -lt 3 || BASH_VERSINFO[0] -eq 3 && BASH_VERSINFO[1] -lt 1 ]]; then
    return 1
fi

# Avoid duplicate inclusion
if [[ -n "${bash_preexec_imported:-}" ]]; then
    return 0
fi
bash_preexec_imported="defined"

# WARNING: This variable is no longer used and should not be relied upon.
# Use ${bash_preexec_imported} instead.
# shellcheck disable=SC2034
__bp_imported="${bash_preexec_imported}"

# Should be available to each precmd and preexec
# functions, should they want it. $? and $_ are available as $? and $_, but
# $PIPESTATUS is available only in a copy, $BP_PIPESTATUS.
# TODO: Figure out how to restore PIPESTATUS before each precmd or preexec
# function.
__bp_last_ret_value="$?"
BP_PIPESTATUS=("${PIPESTATUS[@]}")
__bp_last_argument_prev_command="$_"

__bp_inside_precmd=0
__bp_inside_preexec=0

# Initial PROMPT_COMMAND string that is removed from PROMPT_COMMAND post __bp_install
__bp_install_string=$'__bp_trap_string="$(trap -p DEBUG)"\ntrap - DEBUG\n__bp_install'

# Fails if any of the given variables are readonly
# Reference https://stackoverflow.com/a/4441178
__bp_require_not_readonly() {
  local var
  for var; do
    if ! ( unset "$var" 2> /dev/null ); then
      echo "bash-preexec requires write access to ${var}" >&2
      return 1
    fi
  done
}

# Remove ignorespace and or replace ignoreboth from HISTCONTROL
# so we can accurately invoke preexec with a command from our
# history even if it starts with a space.
__bp_adjust_histcontrol() {
    local histcontrol
    histcontrol="${HISTCONTROL:-}"
    histcontrol="${histcontrol//ignorespace}"
    # Replace ignoreboth with ignoredups
    if [[ "$histcontrol" == *"ignoreboth"* ]]; then
        histcontrol="ignoredups:${histcontrol//ignoreboth}"
    fi;
    export HISTCONTROL="$histcontrol"
}

# This variable describes whether we are currently in "interactive mode";
# i.e. whether this shell has just executed a prompt and is waiting for user
# input.  It documents whether the current command invoked by the trace hook is
# run interactively by the user; it's set immediately after the prompt hook,
# and unset as soon as the trace hook is run.
__bp_preexec_interactive_mode=""

# These arrays are used to add functions to be run before, or after, prompts.
declare -a precmd_functions
declare -a preexec_functions

# Trims leading and trailing whitespace from $2 and writes it to the variable
# name passed as $1
__bp_trim_whitespace() {
    local var=${1:?} text=${2:-}
    text="${text#"${text%%[![:space:]]*}"}"   # remove leading whitespace characters
    text="${text%"${text##*[![:space:]]}"}"   # remove trailing whitespace characters
    printf -v "$var" '%s' "$text"
}


# Trims whitespace and removes any leading or trailing semicolons from $2 and
# writes the resulting string to the variable name passed as $1. Used for
# manipulating substrings in PROMPT_COMMAND
__bp_sanitize_string() {
    local var=${1:?} text=${2:-} sanitized
    __bp_trim_whitespace sanitized "$text"
    sanitized=${sanitized%;}
    sanitized=${sanitized#;}
    __bp_trim_whitespace sanitized "$sanitized"
    printf -v "$var" '%s' "$sanitized"
}

# This function is installed as part of the PROMPT_COMMAND;
# It sets a variable to indicate that the prompt was just displayed,
# to allow the DEBUG trap to know that the next command is likely interactive.
__bp_interactive_mode() {
    __bp_preexec_interactive_mode="on";
}


# This function is installed as part of the PROMPT_COMMAND.
# It will invoke any functions defined in the precmd_functions array.
__bp_precmd_invoke_cmd() {
    # Save the returned value from our last command, and from each process in
    # its pipeline. Note: this MUST be the first thing done in this function.
    # BP_PIPESTATUS may be unused, ignore
    # shellcheck disable=SC2034

    __bp_last_ret_value="$?" BP_PIPESTATUS=("${PIPESTATUS[@]}")

    # Don't invoke precmds if we are inside an execution of an "original
    # prompt command" by another precmd execution loop. This avoids infinite
    # recursion.
    if (( __bp_inside_precmd > 0 )); then
      return
    fi
    local __bp_inside_precmd=1

    # Invoke every function defined in our function array.
    local precmd_function
    for precmd_function in "${precmd_functions[@]}"; do

        # Only execute this function if it actually exists.
        # Test existence of functions with: declare -[Ff]
        if type -t "$precmd_function" 1>/dev/null; then
            __bp_set_ret_value "$__bp_last_ret_value" "$__bp_last_argument_prev_command"
            # Quote our function invocation to prevent issues with IFS
            "$precmd_function"
        fi
    done

    __bp_set_ret_value "$__bp_last_ret_value"
}

# Sets a return value in $?. We may want to get access to the $? variable in our
# precmd functions. This is available for instance in zsh. We can simulate it in bash
# by setting the value here.
__bp_set_ret_value() {
    return ${1:+"$1"}
}

__bp_in_prompt_command() {

    local prompt_command_array
    IFS=$'\n;' read -rd '' -a prompt_command_array <<< "${PROMPT_COMMAND:-}"

    local trimmed_arg
    __bp_trim_whitespace trimmed_arg "${1:-}"

    local command trimmed_command
    for command in "${prompt_command_array[@]:-}"; do
        __bp_trim_whitespace trimmed_command "$command"
        if [[ "$trimmed_command" == "$trimmed_arg" ]]; then
            return 0
        fi
    done

    return 1
}

# This function is installed as the DEBUG trap.  It is invoked before each
# interactive prompt display.  Its purpose is to inspect the current
# environment to attempt to detect if the current command is being invoked
# interactively, and invoke 'preexec' if so.
__bp_preexec_invoke_exec() {

    # Save the contents of $_ so that it can be restored later on.
    # https://stackoverflow.com/questions/40944532/bash-preserve-in-a-debug-trap#40944702
    __bp_last_argument_prev_command="${1:-}"
    # Don't invoke preexecs if we are inside of another preexec.
    if (( __bp_inside_preexec > 0 )); then
      return
    fi
    local __bp_inside_preexec=1

    # Checks if the file descriptor is not standard out (i.e. '1')
    # __bp_delay_install checks if we're in test. Needed for bats to run.
    # Prevents preexec from being invoked for functions in PS1
    if [[ ! -t 1 && -z "${__bp_delay_install:-}" ]]; then
        return
    fi

    if [[ -n "${COMP_LINE:-}" ]]; then
        # We're in the middle of a completer. This obviously can't be
        # an interactively issued command.
        return
    fi
    if [[ -z "${__bp_preexec_interactive_mode:-}" ]]; then
        # We're doing something related to displaying the prompt.  Let the
        # prompt set the title instead of me.
        return
    else
        # If we're in a subshell, then the prompt won't be re-displayed to put
        # us back into interactive mode, so let's not set the variable back.
        # In other words, if you have a subshell like
        #   (sleep 1; sleep 2)
        # You want to see the 'sleep 2' as a set_command_title as well.
        if [[ 0 -eq "${BASH_SUBSHELL:-}" ]]; then
            __bp_preexec_interactive_mode=""
        fi
    fi

    if  __bp_in_prompt_command "${BASH_COMMAND:-}"; then
        # If we're executing something inside our prompt_command then we don't
        # want to call preexec. Bash prior to 3.1 can't detect this at all :/
        __bp_preexec_interactive_mode=""
        return
    fi

    local this_command
    this_command=$(
        export LC_ALL=C
        HISTTIMEFORMAT='' builtin history 1 | sed '1 s/^ *[0-9][0-9]*[* ] //'
    )

    # Sanity check to make sure we have something to invoke our function with.
    if [[ -z "$this_command" ]]; then
        return
    fi

    # Invoke every function defined in our function array.
    local preexec_function
    local preexec_function_ret_value
    local preexec_ret_value=0
    for preexec_function in "${preexec_functions[@]:-}"; do

        # Only execute each function if it actually exists.
        # Test existence of function with: declare -[fF]
        if type -t "$preexec_function" 1>/dev/null; then
            __bp_set_ret_value "${__bp_last_ret_value:-}"
            # Quote our function invocation to prevent issues with IFS
            "$preexec_function" "$this_command"
            preexec_function_ret_value="$?"
            if [[ "$preexec_function_ret_value" != 0 ]]; then
                preexec_ret_value="$preexec_function_ret_value"
            fi
        fi
    done

    # Restore the last argument of the last executed command, and set the return
    # value of the DEBUG trap to be the return code of the last preexec function
    # to return an error.
    # If `extdebug` is enabled a non-zero return value from any preexec function
    # will cause the user's command not to execute.
    # Run `shopt -s extdebug` to enable
    __bp_set_ret_value "$preexec_ret_value" "$__bp_last_argument_prev_command"
}

__bp_install() {
    # Exit if we already have this installed.
    if [[ "${PROMPT_COMMAND:-}" == *"__bp_precmd_invoke_cmd"* ]]; then
        return 1;
    fi

    trap '__bp_preexec_invoke_exec "$_"' DEBUG

    # Preserve any prior DEBUG trap as a preexec function
    local prior_trap
    # we can't easily do this with variable expansion. Leaving as sed command.
    # shellcheck disable=SC2001
    prior_trap=$(sed "s/[^']*'\(.*\)'[^']*/\1/" <<<"${__bp_trap_string:-}")
    unset __bp_trap_string
    if [[ -n "$prior_trap" ]]; then
        eval '__bp_original_debug_trap() {
          '"$prior_trap"'
        }'
        preexec_functions+=(__bp_original_debug_trap)
    fi

    # Adjust our HISTCONTROL Variable if needed.
    __bp_adjust_histcontrol

    # Issue #25. Setting debug trap for subshells causes sessions to exit for
    # backgrounded subshell commands (e.g. (pwd)& ). Believe this is a bug in Bash.
    #
    # Disabling this by default. It can be enabled by setting this variable.
    if [[ -n "${__bp_enable_subshells:-}" ]]; then

        # Set so debug trap will work be invoked in subshells.
        set -o functrace > /dev/null 2>&1
        shopt -s extdebug > /dev/null 2>&1
    fi;

    local existing_prompt_command
    # Remove setting our trap install string and sanitize the existing prompt command string
    existing_prompt_command="${PROMPT_COMMAND:-}"
    existing_prompt_command="${existing_prompt_command//${__bp_install_string}[;$'\n']}" # Edge case of appending to PROMPT_COMMAND
    existing_prompt_command="${existing_prompt_command//$__bp_install_string}"
    __bp_sanitize_string existing_prompt_command "$existing_prompt_command"

    # Install our hooks in PROMPT_COMMAND to allow our trap to know when we've
    # actually entered something.
    PROMPT_COMMAND=$'__bp_precmd_invoke_cmd\n'
    if [[ -n "$existing_prompt_command" ]]; then
        PROMPT_COMMAND+=${existing_prompt_command}$'\n'
    fi;
    PROMPT_COMMAND+='__bp_interactive_mode'

    # Add two functions to our arrays for convenience
    # of definition.
    precmd_functions+=(precmd)
    preexec_functions+=(preexec)

    # Invoke our two functions manually that were added to $PROMPT_COMMAND
    __bp_precmd_invoke_cmd
    __bp_interactive_mode
}

# Sets an installation string as part of our PROMPT_COMMAND to install
# after our session has started. This allows bash-preexec to be included
# at any point in our bash profile.
__bp_install_after_session_init() {
    # bash-preexec needs to modify these variables in order to work correctly
    # if it can't, just stop the installation
    __bp_require_not_readonly PROMPT_COMMAND HISTCONTROL HISTTIMEFORMAT || return

    local sanitized_prompt_command
    __bp_sanitize_string sanitized_prompt_command "${PROMPT_COMMAND:-}"
    if [[ -n "$sanitized_prompt_command" ]]; then
        PROMPT_COMMAND=${sanitized_prompt_command}$'\n'
    fi;
    PROMPT_COMMAND+=${__bp_install_string}
}

# Run our install so long as we're not delaying it.
if [[ -z "${__bp_delay_install:-}" ]]; then
    __bp_install_after_session_init
fi;
#!/bin/bash

alias -- -='cd -'
alias rl='exec bash'

shopt -s autocd
shopt -s checkwinsize
shopt -s dotglob
# shopt -s failglob
shopt -s globstar
shopt -s histappend

HISTSIZE="-1"
HISTFILESIZE="-1"
HISTFILE="$HOME/.bash_history"
HISTTIMEFORMAT="%F %T "
HISTCONTROL=ignoredups
INPUTRC=/etc/inputrc

export PAGER="less"
export LESS="-R -i -g -W"
export LESSOPEN='|/usr/bin/lesspipe %s'
export LESSCLOSE='/usr/bin/lesspipe %s %s'
# color man
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

LAST_LS=$(command ls | sum)
LAST_PWD="$PWD"
_prompt_smart_ls()
{
	local this_ls
	this_ls=$(command ls | sum)
	if [ "$LAST_LS" != "$this_ls" ] || [ "$LAST_PWD" != "$PWD" ]; then
		LAST_LS="$this_ls"
		LAST_PWD="$PWD"
		ls
		return
	fi
}

_prompt_slow_command_tracer_init()
{
    CMD_START_TIME="$SECONDS"
    if [ -n "$DISPLAY" ]; then
        CMD_ACTIVE_WINDOW=$(xdotool getactivewindow 2>/dev/null)
    fi
}

_prompt_set_return_value() {
    prompt_return_value=$?
}

_prompt_show_return_value()
{
	test $prompt_return_value -ne 0 && printf '[%s] ' $prompt_return_value
}

_prompt_slow_command()
{
    local time_diff=$((SECONDS - CMD_START_TIME))
    local active_window
    local urgency="low"
    if [ "$prompt_return_value" != 0 ]; then
        urgency=critical
    fi

    if [ -n "$DISPLAY" ]; then
        active_window=$(xdotool getactivewindow 2>/dev/null)
        if [ -n "$CMD_ACTIVE_WINDOW" ] && [ "$active_window" != "$CMD_ACTIVE_WINDOW" ]; then
            notify-send -u "$urgency" "DONE $(date -u +%H:%M:%S --date="@$time_diff")" "$(fc -nl 0 | sed 's/^[[:space:]]*//')"
        fi
    fi
    [ $time_diff -lt 10  ] && return
    echo -n ">"
    date -u +%H:%M:%S --date="@$time_diff" | awk -F':' '{
    if ($1) printf("%dh ", $1);
    if ($1 || $2) printf("%dm ", $2);
    printf("%ds", $3);
}'
    echo -n "< "
    return
}

_prompt_append_history() {
    history -a
}

preexec_functions+=(_prompt_slow_command_tracer_init)
precmd_functions+=(_prompt_smart_ls)
precmd_functions+=(_prompt_append_history)
precmd_functions+=(_prompt_set_return_value)

if [ -f /etc/bash_completion ]; then
    # shellcheck source=/dev/null
    source /etc/bash_completion
fi

if [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
    # shellcheck source=/dev/null
	source /usr/share/git-core/contrib/completion/git-prompt.sh
fi

if command -v __git_ps1 > /dev/null; then
    PS1='$(_prompt_show_return_value)$(_prompt_slow_command)\H \A$(__git_ps1) $(_prompt_fish_path)\n\j '
else
    PS1='$(_prompt_show_return_value)$(_prompt_slow_command)\H \A $(_prompt_fish_path)\n\j '
fi
# Copyright (c) 2009 rupa deadwyler. Licensed under the WTFPL license, Version 2

# maintains a jump-list of the directories you actually use
#
# INSTALL:
#     * put something like this in your .bashrc/.zshrc:
#         . /path/to/z.sh
#     * cd around for a while to build up the db
#     * PROFIT!!
#     * optionally:
#         set $_Z_CMD in .bashrc/.zshrc to change the command (default z).
#         set $_Z_DATA in .bashrc/.zshrc to change the datafile (default ~/.z).
#         set $_Z_NO_RESOLVE_SYMLINKS to prevent symlink resolution.
#         set $_Z_NO_PROMPT_COMMAND if you're handling PROMPT_COMMAND yourself.
#         set $_Z_EXCLUDE_DIRS to an array of directories to exclude.
#         set $_Z_OWNER to your username if you want use z while sudo with $HOME kept
#
# USE:
#     * z foo     # cd to most frecent dir matching foo
#     * z foo bar # cd to most frecent dir matching foo and bar
#     * z -r foo  # cd to highest ranked dir matching foo
#     * z -t foo  # cd to most recently accessed dir matching foo
#     * z -l foo  # list matches instead of cd
#     * z -e foo  # echo the best match, don't cd
#     * z -c foo  # restrict matches to subdirs of $PWD

[ -d "${_Z_DATA:-$HOME/.z}" ] && {
    echo "ERROR: z.sh's datafile (${_Z_DATA:-$HOME/.z}) is a directory."
}

_z() {

    local datafile="${_Z_DATA:-$HOME/.z}"

    # if symlink, dereference
    [ -h "$datafile" ] && datafile=$(readlink "$datafile")

    # bail if we don't own ~/.z and $_Z_OWNER not set
    [ -z "$_Z_OWNER" -a -f "$datafile" -a ! -O "$datafile" ] && return

    _z_dirs () {
        local line
        while read line; do
            # only count directories
            [ -d "${line%%\|*}" ] && echo "$line"
        done < "$datafile"
        return 0
    }

    # add entries
    if [ "$1" = "--add" ]; then
        shift

        # $HOME isn't worth matching
        [ "$*" = "$HOME" ] && return

        # don't track excluded directory trees
        local exclude
        for exclude in "${_Z_EXCLUDE_DIRS[@]}"; do
            case "$*" in "$exclude*") return;; esac
        done

        # maintain the data file
        local tempfile="$datafile.$RANDOM"
        _z_dirs | awk -v path="$*" -v now="$(date +%s)" -F"|" '
            BEGIN {
                rank[path] = 1
                time[path] = now
            }
            $2 >= 1 {
                # drop ranks below 1
                if( $1 == path ) {
                    rank[$1] = $2 + 1
                    time[$1] = now
                } else {
                    rank[$1] = $2
                    time[$1] = $3
                }
                count += $2
            }
            END {
                if( count > 9000 ) {
                    # aging
                    for( x in rank ) print x "|" 0.99*rank[x] "|" time[x]
                } else for( x in rank ) print x "|" rank[x] "|" time[x]
            }
        ' 2>/dev/null >| "$tempfile"
        # do our best to avoid clobbering the datafile in a race condition.
        if [ $? -ne 0 -a -f "$datafile" ]; then
            env rm -f "$tempfile"
        else
            [ "$_Z_OWNER" ] && chown $_Z_OWNER:"$(id -ng $_Z_OWNER)" "$tempfile"
            env mv -f "$tempfile" "$datafile" || env rm -f "$tempfile"
        fi

    # tab completion
    elif [ "$1" = "--complete" -a -s "$datafile" ]; then
        _z_dirs | awk -v q="$2" -F"|" '
            BEGIN {
                q = substr(q, 3)
                if( q == tolower(q) ) imatch = 1
                gsub(/ /, ".*", q)
            }
            {
                if( imatch ) {
                    if( tolower($1) ~ q ) print $1
                } else if( $1 ~ q ) print $1
            }
        ' 2>/dev/null

    else
        # list/go
        local echo fnd last list opt typ
        while [ "$1" ]; do case "$1" in
            --) while [ "$1" ]; do shift; fnd="$fnd${fnd:+ }$1";done;;
            -*) opt=${1:1}; while [ "$opt" ]; do case ${opt:0:1} in
                    c) fnd="^$PWD $fnd";;
                    e) echo=1;;
                    h) echo "${_Z_CMD:-z} [-cehlrtx] args" >&2; return;;
                    l) list=1;;
                    r) typ="rank";;
                    t) typ="recent";;
                    x) sed -i -e "\:^${PWD}|.*:d" "$datafile";;
                esac; opt=${opt:1}; done;;
             *) fnd="$fnd${fnd:+ }$1";;
        esac; last=$1; [ "$#" -gt 0 ] && shift; done
        [ "$fnd" -a "$fnd" != "^$PWD " ] || list=1

        # if we hit enter on a completion just go there
        case "$last" in
            # completions will always start with /
            /*) [ -z "$list" -a -d "$last" ] && builtin cd "$last" && return;;
        esac

        # no file yet
        [ -f "$datafile" ] || return

        local cd
        cd="$( < <( _z_dirs ) awk -v t="$(date +%s)" -v list="$list" -v typ="$typ" -v q="$fnd" -F"|" '
            function frecent(rank, time) {
                # relate frequency and time
                dx = t - time
                if( dx < 3600 ) return rank * 4
                if( dx < 86400 ) return rank * 2
                if( dx < 604800 ) return rank / 2
                return rank / 4
            }
            function output(matches, best_match, common) {
                # list or return the desired directory
                if( list ) {
                    cmd = "sort -g >&2"
                    for( x in matches ) {
                        if( matches[x] ) {
                            printf "%-10s %s\n", matches[x], x | cmd
                        }
                    }
                    if( common ) {
                        printf "%-10s %s\n", "common:", common > "/dev/stderr"
                    }
                } else {
                    if( common ) best_match = common
                    print best_match
                }
            }
            function common(matches) {
                # find the common root of a list of matches, if it exists
                for( x in matches ) {
                    if( matches[x] && (!short || length(x) < length(short)) ) {
                        short = x
                    }
                }
                if( short == "/" ) return
                for( x in matches ) if( matches[x] && index(x, short) != 1 ) {
                    return
                }
                return short
            }
            BEGIN {
                gsub(" ", ".*", q)
                hi_rank = ihi_rank = -9999999999
            }
            {
                if( typ == "rank" ) {
                    rank = $2
                } else if( typ == "recent" ) {
                    rank = $3 - t
                } else rank = frecent($2, $3)
                if( $1 ~ q ) {
                    matches[$1] = rank
                } else if( tolower($1) ~ tolower(q) ) imatches[$1] = rank
                if( matches[$1] && matches[$1] > hi_rank ) {
                    best_match = $1
                    hi_rank = matches[$1]
                } else if( imatches[$1] && imatches[$1] > ihi_rank ) {
                    ibest_match = $1
                    ihi_rank = imatches[$1]
                }
            }
            END {
                # prefer case sensitive
                if( best_match ) {
                    output(matches, best_match, common(matches))
                } else if( ibest_match ) {
                    output(imatches, ibest_match, common(imatches))
                }
            }
        ')"

        [ $? -eq 0 ] && [ "$cd" ] && {
          if [ "$echo" ]; then echo "$cd"; else builtin cd "$cd"; fi
        }
    fi
}

alias ${_Z_CMD:-z}='_z 2>&1'

[ "$_Z_NO_RESOLVE_SYMLINKS" ] || _Z_RESOLVE_SYMLINKS="-P"

if type compctl >/dev/null 2>&1; then
    # zsh
    [ "$_Z_NO_PROMPT_COMMAND" ] || {
        # populate directory list, avoid clobbering any other precmds.
        if [ "$_Z_NO_RESOLVE_SYMLINKS" ]; then
            _z_precmd() {
                (_z --add "${PWD:a}" &)
            }
        else
            _z_precmd() {
                (_z --add "${PWD:A}" &)
            }
        fi
        [[ -n "${precmd_functions[(r)_z_precmd]}" ]] || {
            precmd_functions[$(($#precmd_functions+1))]=_z_precmd
        }
    }
    _z_zsh_tab_completion() {
        # tab completion
        local compl
        read -l compl
        reply=(${(f)"$(_z --complete "$compl")"})
    }
    compctl -U -K _z_zsh_tab_completion _z
elif type complete >/dev/null 2>&1; then
    # bash
    # tab completion
    complete -o filenames -C '_z --complete "$COMP_LINE"' "${_Z_CMD:-z}"
    [ "$_Z_NO_PROMPT_COMMAND" ] || {
        # populate directory list. avoid clobbering other PROMPT_COMMANDs.
        grep "_z --add" <<< "$PROMPT_COMMAND" >/dev/null || {
            PROMPT_COMMAND="$PROMPT_COMMAND"$'\n''(_z --add "$(command pwd '$_Z_RESOLVE_SYMLINKS' 2>/dev/null)" 2>/dev/null &);'
        }
    }
fi
#!/bin/bash

fz() {
	local dir
	dir="$(z | sed 's/^[0-9. \t]*//' |fzf -1 -0 --no-sort --tac +m)" && \
		cd "$dir" || return 1
}

# Key bindings
# ------------
__fzf_select__() {
  local cmd="${FZF_CTRL_T_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | cut -b3-"}"
  eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m "$@" | while read -r item; do
    printf '%q ' "$item"
  done
  echo
}

if [[ $- =~ i ]]; then

__fzf_use_tmux__() {
  [ -n "$TMUX_PANE" ] && [ "${FZF_TMUX:-0}" != 0 ] && [ ${LINES:-40} -gt 15 ]
}

__fzfcmd() {
  __fzf_use_tmux__ &&
    echo "fzf-tmux -d${FZF_TMUX_HEIGHT:-40%}" || echo "fzf"
}

__fzf_select_tmux__() {
  local height
  height=${FZF_TMUX_HEIGHT:-40%}
  if [[ $height =~ %$ ]]; then
    height="-p ${height%\%}"
  else
    height="-l $height"
  fi

  tmux split-window $height "cd $(printf %q "$PWD"); FZF_DEFAULT_OPTS=$(printf %q "$FZF_DEFAULT_OPTS") PATH=$(printf %q "$PATH") FZF_CTRL_T_COMMAND=$(printf %q "$FZF_CTRL_T_COMMAND") FZF_CTRL_T_OPTS=$(printf %q "$FZF_CTRL_T_OPTS") bash -c 'source \"${BASH_SOURCE[0]}\"; RESULT=\"\$(__fzf_select__ --no-height)\"; tmux setb -b fzf \"\$RESULT\" \\; pasteb -b fzf -t $TMUX_PANE \\; deleteb -b fzf || tmux send-keys -t $TMUX_PANE \"\$RESULT\"'"
}

fzf-file-widget() {
  if __fzf_use_tmux__; then
    __fzf_select_tmux__
  else
    local selected="$(__fzf_select__)"
    READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
    READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
  fi
}

__fzf_cd__() {
  local cmd dir
  cmd="${FZF_ALT_C_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type d -print 2> /dev/null | cut -b3-"}"
  dir=$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m) && printf 'cd %q' "$dir"
}

__fzf_history__() (
  local line
  shopt -u nocaseglob nocasematch
  line=$(
    HISTTIMEFORMAT= builtin history |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS --tac --sync -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS +m" $(__fzfcmd) |
    command grep '^ *[0-9]') &&
    if [[ $- =~ H ]]; then
      sed 's/^ *\([0-9]*\)\** .*/!\1/' <<< "$line"
    else
      sed 's/^ *\([0-9]*\)\** *//' <<< "$line"
    fi
)

if command -v fzf >/dev/null; then
if [[ ! -o vi ]]; then
  # Required to refresh the prompt after fzf
  bind '"\er": redraw-current-line'
  bind '"\e^": history-expand-line'

  # CTRL-T - Paste the selected file path into the command line
  if [ $BASH_VERSINFO -gt 3 ]; then
    bind -x '"\C-t": "fzf-file-widget"'
  elif __fzf_use_tmux__; then
    bind '"\C-t": " \C-u \C-a\C-k`__fzf_select_tmux__`\e\C-e\C-y\C-a\C-d\C-y\ey\C-h"'
  else
    bind '"\C-t": " \C-u \C-a\C-k`__fzf_select__`\e\C-e\C-y\C-a\C-y\ey\C-h\C-e\er \C-h"'
  fi

  # CTRL-R - Paste the selected command from history into the command line
  bind '"\C-r": " \C-e\C-u\C-y\ey\C-u`__fzf_history__`\e\C-e\er\e^"'

  # ALT-C - cd into the selected directory
  bind '"\ec": " \C-e\C-u`__fzf_cd__`\e\C-e\er\C-m"'
else
  # We'd usually use "\e" to enter vi-movement-mode so we can do our magic,
  # but this incurs a very noticeable delay of a half second or so,
  # because many other commands start with "\e".
  # Instead, we bind an unused key, "\C-x\C-a",
  # to also enter vi-movement-mode,
  # and then use that thereafter.
  # (We imagine that "\C-x\C-a" is relatively unlikely to be in use.)
  bind '"\C-x\C-a": vi-movement-mode'

  bind '"\C-x\C-e": shell-expand-line'
  bind '"\C-x\C-r": redraw-current-line'
  bind '"\C-x^": history-expand-line'

  # CTRL-T - Paste the selected file path into the command line
  # - FIXME: Selected items are attached to the end regardless of cursor position
  if [ $BASH_VERSINFO -gt 3 ]; then
    bind -x '"\C-t": "fzf-file-widget"'
  elif __fzf_use_tmux__; then
    bind '"\C-t": "\C-x\C-a$a \C-x\C-addi`__fzf_select_tmux__`\C-x\C-e\C-x\C-a0P$xa"'
  else
    bind '"\C-t": "\C-x\C-a$a \C-x\C-addi`__fzf_select__`\C-x\C-e\C-x\C-a0Px$a \C-x\C-r\C-x\C-axa "'
  fi
  bind -m vi-command '"\C-t": "i\C-t"'

  # CTRL-R - Paste the selected command from history into the command line
  bind '"\C-r": "\C-x\C-addi`__fzf_history__`\C-x\C-e\C-x\C-r\C-x^\C-x\C-a$a"'
  bind -m vi-command '"\C-r": "i\C-r"'

  # ALT-C - cd into the selected directory
  bind '"\ec": "\C-x\C-addi`__fzf_cd__`\C-x\C-e\C-x\C-r\C-m"'
  bind -m vi-command '"\ec": "ddi`__fzf_cd__`\C-x\C-e\C-x\C-r\C-m"'
fi
fi

fi
#     ____      ____
#    / __/___  / __/
#   / /_/_  / / /_
#  / __/ / /_/ __/
# /_/   /___/_/-completion.bash
#
# - $FZF_TMUX               (default: 0)
# - $FZF_TMUX_HEIGHT        (default: '40%')
# - $FZF_COMPLETION_TRIGGER (default: '**')
# - $FZF_COMPLETION_OPTS    (default: empty)

if [[ $- =~ i ]]; then

# To use custom commands instead of find, override _fzf_compgen_{path,dir}
if ! declare -f _fzf_compgen_path > /dev/null; then
  _fzf_compgen_path() {
    echo "$1"
    command find -L "$1" \
      -name .git -prune -o -name .svn -prune -o \( -type d -o -type f -o -type l \) \
      -a -not -path "$1" -print 2> /dev/null | sed 's@^\./@@'
  }
fi

if ! declare -f _fzf_compgen_dir > /dev/null; then
  _fzf_compgen_dir() {
    command find -L "$1" \
      -name .git -prune -o -name .svn -prune -o -type d \
      -a -not -path "$1" -print 2> /dev/null | sed 's@^\./@@'
  }
fi

###########################################################

# To redraw line after fzf closes (printf '\e[5n')
bind '"\e[0n": redraw-current-line'

__fzfcmd_complete() {
  [ -n "$TMUX_PANE" ] && [ "${FZF_TMUX:-0}" != 0 ] && [ ${LINES:-40} -gt 15 ] &&
    echo "fzf-tmux -d${FZF_TMUX_HEIGHT:-40%}" || echo "fzf"
}

__fzf_orig_completion_filter() {
  sed 's/^\(.*-F\) *\([^ ]*\).* \([^ ]*\)$/export _fzf_orig_completion_\3="\1 %s \3 #\2"; [[ "\1" = *" -o nospace "* ]] \&\& [[ ! "$__fzf_nospace_commands" = *" \3 "* ]] \&\& __fzf_nospace_commands="$__fzf_nospace_commands \3 ";/' |
  awk -F= '{OFS = FS} {gsub(/[^A-Za-z0-9_= ;]/, "_", $1);}1'
}

_fzf_opts_completion() {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  opts="
    -x --extended
    -e --exact
    --algo
    -i +i
    -n --nth
    --with-nth
    -d --delimiter
    +s --no-sort
    --tac
    --tiebreak
    -m --multi
    --no-mouse
    --bind
    --cycle
    --no-hscroll
    --jump-labels
    --height
    --literal
    --reverse
    --margin
    --inline-info
    --prompt
    --header
    --header-lines
    --ansi
    --tabstop
    --color
    --no-bold
    --history
    --history-size
    --preview
    --preview-window
    -q --query
    -1 --select-1
    -0 --exit-0
    -f --filter
    --print-query
    --expect
    --sync"

  case "${prev}" in
  --tiebreak)
    COMPREPLY=( $(compgen -W "length begin end index" -- "$cur") )
    return 0
    ;;
  --color)
    COMPREPLY=( $(compgen -W "dark light 16 bw" -- "$cur") )
    return 0
    ;;
  --history)
    COMPREPLY=()
    return 0
    ;;
  esac

  if [[ "$cur" =~ ^-|\+ ]]; then
    COMPREPLY=( $(compgen -W "${opts}" -- "$cur") )
    return 0
  fi

  return 0
}

_fzf_handle_dynamic_completion() {
  local cmd orig_var orig ret orig_cmd orig_complete
  cmd="$1"
  shift
  orig_cmd="$1"
  orig_var="_fzf_orig_completion_$cmd"
  orig="${!orig_var##*#}"
  if [ -n "$orig" ] && type "$orig" > /dev/null 2>&1; then
    $orig "$@"
  elif [ -n "$_fzf_completion_loader" ]; then
    orig_complete=$(complete -p "$orig_cmd" 2> /dev/null)
    _completion_loader "$@"
    ret=$?
    # _completion_loader may not have updated completion for the command
    if [ "$(complete -p "$orig_cmd" 2> /dev/null)" != "$orig_complete" ]; then
      eval "$(complete | command grep " -F.* $orig_cmd$" | __fzf_orig_completion_filter)"
      if [[ "$__fzf_nospace_commands" = *" $orig_cmd "* ]]; then
        eval "${orig_complete/ -F / -o nospace -F }"
      else
        eval "$orig_complete"
      fi
    fi
    return $ret
  fi
}

__fzf_generic_path_completion() {
  local cur base dir leftover matches trigger cmd fzf
  fzf="$(__fzfcmd_complete)"
  cmd="${COMP_WORDS[0]//[^A-Za-z0-9_=]/_}"
  COMPREPLY=()
  trigger=${FZF_COMPLETION_TRIGGER-'**'}
  cur="${COMP_WORDS[COMP_CWORD]}"
  if [[ "$cur" == *"$trigger" ]]; then
    base=${cur:0:${#cur}-${#trigger}}
    eval "base=$base"

    [[ $base = *"/"* ]] && dir="$base"
    while true; do
      if [ -z "$dir" ] || [ -d "$dir" ]; then
        leftover=${base/#"$dir"}
        leftover=${leftover/#\/}
        [ -z "$dir" ] && dir='.'
        [ "$dir" != "/" ] && dir="${dir/%\//}"
        matches=$(eval "$1 $(printf %q "$dir")" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_COMPLETION_OPTS" $fzf $2 -q "$leftover" | while read -r item; do
          printf "%q$3 " "$item"
        done)
        matches=${matches% }
        [[ -z "$3" ]] && [[ "$__fzf_nospace_commands" = *" ${COMP_WORDS[0]} "* ]] && matches="$matches "
        if [ -n "$matches" ]; then
          COMPREPLY=( "$matches" )
        else
          COMPREPLY=( "$cur" )
        fi
        printf '\e[5n'
        return 0
      fi
      dir=$(dirname "$dir")
      [[ "$dir" =~ /$ ]] || dir="$dir"/
    done
  else
    shift
    shift
    shift
    _fzf_handle_dynamic_completion "$cmd" "$@"
  fi
}

_fzf_complete() {
  local cur selected trigger cmd fzf post
  post="$(caller 0 | awk '{print $2}')_post"
  type -t "$post" > /dev/null 2>&1 || post=cat
  fzf="$(__fzfcmd_complete)"

  cmd="${COMP_WORDS[0]//[^A-Za-z0-9_=]/_}"
  trigger=${FZF_COMPLETION_TRIGGER-'**'}
  cur="${COMP_WORDS[COMP_CWORD]}"
  if [[ "$cur" == *"$trigger" ]]; then
    cur=${cur:0:${#cur}-${#trigger}}

    selected=$(cat | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_COMPLETION_OPTS" $fzf $1 -q "$cur" | $post | tr '\n' ' ')
    selected=${selected% } # Strip trailing space not to repeat "-o nospace"
    printf '\e[5n'

    if [ -n "$selected" ]; then
      COMPREPLY=("$selected")
      return 0
    fi
  else
    shift
    _fzf_handle_dynamic_completion "$cmd" "$@"
  fi
}

_fzf_path_completion() {
  __fzf_generic_path_completion _fzf_compgen_path "-m" "" "$@"
}

# Deprecated. No file only completion.
_fzf_file_completion() {
  _fzf_path_completion "$@"
}

_fzf_dir_completion() {
  __fzf_generic_path_completion _fzf_compgen_dir "" "/" "$@"
}

_fzf_complete_kill() {
  [ -n "${COMP_WORDS[COMP_CWORD]}" ] && return 1

  local selected fzf
  fzf="$(__fzfcmd_complete)"
  selected=$(command ps -ef | sed 1d | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-50%} --min-height 15 --reverse $FZF_DEFAULT_OPTS --preview 'echo {}' --preview-window down:3:wrap $FZF_COMPLETION_OPTS" $fzf -m | awk '{print $2}' | tr '\n' ' ')
  printf '\e[5n'

  if [ -n "$selected" ]; then
    COMPREPLY=( "$selected" )
    return 0
  fi
}

_fzf_complete_telnet() {
  _fzf_complete '+m' "$@" < <(
    command grep -v '^\s*\(#\|$\)' /etc/hosts | command grep -Fv '0.0.0.0' |
        awk '{if (length($2) > 0) {print $2}}' | sort -u
  )
}

_fzf_complete_ssh() {
  _fzf_complete '+m' "$@" < <(
    cat <(cat ~/.ssh/config ~/.ssh/config.d/* /etc/ssh/ssh_config 2> /dev/null | command grep -i '^host ' | command grep -v '[*?]' | awk '{for (i = 2; i <= NF; i++) print $1 " " $i}') \
        <(command grep -oE '^[[a-z0-9.,:-]+' ~/.ssh/known_hosts | tr ',' '\n' | tr -d '[' | awk '{ print $1 " " $1 }') \
        <(command grep -v '^\s*\(#\|$\)' /etc/hosts | command grep -Fv '0.0.0.0') |
        awk '{if (length($2) > 0) {print $2}}' | sort -u
  )
}

_fzf_complete_unset() {
  _fzf_complete '-m' "$@" < <(
    declare -xp | sed 's/=.*//' | sed 's/.* //'
  )
}

_fzf_complete_export() {
  _fzf_complete '-m' "$@" < <(
    declare -xp | sed 's/=.*//' | sed 's/.* //'
  )
}

_fzf_complete_unalias() {
  _fzf_complete '-m' "$@" < <(
    alias | sed 's/=.*//' | sed 's/.* //'
  )
}

# fzf options
complete -o default -F _fzf_opts_completion fzf

d_cmds="${FZF_COMPLETION_DIR_COMMANDS:-cd pushd rmdir}"
a_cmds="
  awk cat diff diff3
  emacs emacsclient ex file ftp g++ gcc gvim head hg java
  javac ld less more mvim nvim patch perl python ruby
  sed sftp sort source tail tee uniq vi view vim wc xdg-open
  basename bunzip2 bzip2 chmod chown curl cp dirname du
  find git grep gunzip gzip hg jar
  ln ls mv open rm rsync scp
  svn tar unzip zip"
x_cmds="kill ssh telnet unset unalias export"

# Preserve existing completion
eval "$(complete |
  sed -E '/-F/!d; / _fzf/d; '"/ ($(echo $d_cmds $a_cmds $x_cmds | sed 's/ /|/g; s/+/\\+/g'))$/"'!d' |
  __fzf_orig_completion_filter)"

if type _completion_loader > /dev/null 2>&1; then
  _fzf_completion_loader=1
fi

_fzf_defc() {
  local cmd func opts orig_var orig def
  cmd="$1"
  func="$2"
  opts="$3"
  orig_var="_fzf_orig_completion_${cmd//[^A-Za-z0-9_]/_}"
  orig="${!orig_var}"
  if [ -n "$orig" ]; then
    printf -v def "$orig" "$func"
    eval "$def"
  else
    complete -F "$func" $opts "$cmd"
  fi
}

# Anything
for cmd in $a_cmds; do
  _fzf_defc "$cmd" _fzf_path_completion "-o default -o bashdefault"
done

# Directory
for cmd in $d_cmds; do
  _fzf_defc "$cmd" _fzf_dir_completion "-o nospace -o dirnames"
done

unset _fzf_defc

# Kill completion
complete -F _fzf_complete_kill -o nospace -o default -o bashdefault kill

# Host completion
complete -F _fzf_complete_ssh -o default -o bashdefault ssh
complete -F _fzf_complete_telnet -o default -o bashdefault telnet

# Environment variables / Aliases
complete -F _fzf_complete_unset -o default -o bashdefault unset
complete -F _fzf_complete_export -o default -o bashdefault export
complete -F _fzf_complete_unalias -o default -o bashdefault unalias

unset cmd d_cmds a_cmds x_cmds

fi
#!/bin/bash

##  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
##  automagical shell alias completion;
##  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

##  ============================================================================
##  Copyright (C) 2016-2021 Cyker Way
##
##  This program is free software: you can redistribute it and/or modify it
##  under the terms of the GNU General Public License as published by the Free
##  Software Foundation, either version 3 of the License, or (at your option)
##  any later version.
##
##  This program is distributed in the hope that it will be useful, but WITHOUT
##  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
##  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
##  more details.
##
##  You should have received a copy of the GNU General Public License along with
##  this program.  If not, see <http://www.gnu.org/licenses/>.
##  ============================================================================

##  ============================================================================
##  # environment variables
##
##  these are envars read by this script; users are advised to set these envars
##  before sourcing this script to customize its behavior, even though some may
##  still work if set after sourcing this script; these envar names must follow
##  this naming convention: all letters uppercase, no leading underscore, words
##  separated by one underscore;
##  ============================================================================

##  bool: true iff auto unmask alias commands; set it to false if auto unmask
##  feels too slow, or custom unmask is necessary to make an unusual behavior;
COMPAL_AUTO_UNMASK="${COMPAL_AUTO_UNMASK:-0}"

##  ============================================================================
##  # variables
##  ============================================================================

##  register for keeping function return value;
__compal__retval=

##  refcnt for alias expansion; expand aliases iff `_refcnt == 0`;
__compal__refcnt=0

##  an associative array of vanilla completions, keyed by command names;
##
##  when we say this array stores "parsed" cspecs, we actually mean the cspecs
##  have been parsed and indexed by command names in this array; cspec strings
##  themselves have no difference between this array and `_raw_vanilla_cspecs`;
##
##  example:
##
##      _vanilla_cspecs["tee"]="complete -F _longopt tee"
##      _vanilla_cspecs["type"]="complete -c type"
##      _vanilla_cspecs["unalias"]="complete -a unalias"
##      ...
##
declare -A __compal__vanilla_cspecs

##  a set of raw vanilla completions, keyed by cspec; these raw cspecs will be
##  parsed and loaded into `_vanilla_cspecs` on use; we need this lazy loading
##  because parsing all cspecs on sourcing incurs a large performance overhead;
##
##  vanilla completions are alias-free and fetched before `_complete_alias` is
##  set as the completion function for alias commands; the way we enforce this
##  partial order is to init this array on source; the sourcing happens before
##  `complete -F _complete_alias ...` for obvious reasons;
##
##  this is made a set, not an array, to avoid duplication when this script is
##  sourced repeatedly; each sourcing overwrites previous ones on duplication;
##
##  example:
##
##      _raw_vanilla_cspecs["complete -F _longopt tee"]=""
##      _raw_vanilla_cspecs["complete -c type"]=""
##      _raw_vanilla_cspecs[""complete -a unalias"]=""
##      ...
##
declare -A __compal__raw_vanilla_cspecs

##  ============================================================================
##  # functions
##  ============================================================================

##  debug bash programmable completion variables;
__compal__debug() {
    echo
    echo "#COMP_WORDS=${#COMP_WORDS[@]}"
    echo "COMP_WORDS=("
    for x in "${COMP_WORDS[@]}"; do
        echo "'$x'"
    done
    echo ")"
    echo "COMP_CWORD=${COMP_CWORD}"
    echo "COMP_LINE='${COMP_LINE}'"
    echo "COMP_POINT=${COMP_POINT}"
    echo
}

##  debug vanilla cspecs;
##
##  $1
##  :   if "key" dump keys, else dump values;
__compal__debug_vanilla_cspecs() {
    if [[ "$1" == "key" ]]; then
        for x in "${!__compal__vanilla_cspecs[@]}"; do
            echo "$x"
        done
    else
        for x in "${__compal__vanilla_cspecs[@]}"; do
            echo "$x"
        done
    fi
}

##  debug raw vanilla cspecs;
__compal__debug_raw_vanilla_cspecs() {
    for x in "${!__compal__raw_vanilla_cspecs[@]}"; do
        echo "$x"
    done
}

##  debug `_split_cmd_line`;
##
##  this function is very easy to use; just call it with a string argument in an
##  interactive shell and look at the result; some interesting string arguments:
##
##  -   (fail) `&> /dev/null ping`
##  -   (fail) `2> /dev/null ping`
##  -   (fail) `2>&1 > /dev/null ping`
##  -   (fail) `> /dev/null ping`
##  -   (work) `&>/dev/null ping`
##  -   (work) `2>&1 >/dev/null ping`
##  -   (work) `2>&1 ping`
##  -   (work) `2>/dev/null ping`
##  -   (work) `>/dev/null ping`
##  -   (work) `FOO=foo true && BAR=bar ping`
##  -   (work) `echo & echo & ping`
##  -   (work) `echo ; echo ; ping`
##  -   (work) `echo | echo | ping`
##  -   (work) `ping &> /dev/null`
##  -   (work) `ping &>/dev/null`
##  -   (work) `ping 2> /dev/null`
##  -   (work) `ping 2>&1 > /dev/null`
##  -   (work) `ping 2>&1 >/dev/null`
##  -   (work) `ping 2>&1`
##  -   (work) `ping 2>/dev/null`
##  -   (work) `ping > /dev/null`
##  -   (work) `ping >/dev/null`
##
##  these failed examples are not an emergency because you can easily find their
##  equivalents in those working ones; and we will check for emergency on failed
##  examples added in the future;
##
##  $1
##  :   command line string;
__compal__debug_split_cmd_line() {
    ##  command line string;
    local str="$1"

    __compal__split_cmd_line "$str"

    for x in "${__compal__retval[@]}"; do
        echo "'$x'"
    done
}

##  print an error message;
##
##  $1
##  :   error message;
__compal__error() {
    printf "error: %s\n" "$1" >&2
}

##  test whether an element is in array;
##
##  $@
##  :   ( elem arr[0] arr[1] ... )
__compal__inarr() {
    for e in "${@:2}"; do
        [[ "$e" == "$1" ]] && return 0
    done
    return 1
}

##  split command line into words;
##
##  the `bash` reference implementation shows how bash splits command line into
##  word list `COMP_WORDS`:
##
##  -   git repo <https://git.savannah.gnu.org/cgit/bash.git>;
##  -   commit `ce23728687ce9e584333367075c9deef413553fa`;
##  -   function `bashline.c:attempt_shell_completion`;
##  -   function `bashline.c:find_cmd_end`;
##  -   function `bashline.c:find_cmd_start`;
##  -   function `pcomplete.c:command_line_to_word_list`;
##  -   function `pcomplete.c:programmable_completions`;
##  -   function `subst.c:skip_to_delim`;
##  -   function `subst.c:split_at_delims`;
##
##  this function shall give similar result as `bash` reference implementation
##  for common use cases, but will not strive for full compatibility, which is
##  too complicated when written in bash; we will support additional use cases
##  as they show up and prove worthy;
##
##  another reason we not pursue full compatibility is, even bash itself fails
##  on some use cases, such as `ping 2>&1` and `ping &>/dev/null`; ironically,
##  if we define an alias and complete using `_complete_alias`, then it works:
##
##      $ alias ping='ping 2>&1'
##      $ complete -F _complete_alias ping
##      $ ping <tab>
##      {ip}
##      {ip}
##      {ip}
##
##  warn: the output of this function is *not* a faithful split of the input;
##  this function drops redirections and assignments, and only keeps the last
##  command in the last pipeline;
##
##  warn: this function is made for alias body expansion; as such it does not
##  support commmand substitutions, etc.; if you run its output as argv, then
##  you run at your own risk; quotes and escapes may also disturb the result;
##
##  $1
##  :   command line string;
__compal__split_cmd_line() {
    ##  command line string;
    local str="$1"

    ##  an array that will contain words after split;
    local words=()

    ##  alloc a temp stack to track open and close chars when splitting;
    local sta=()

    ##  we adopt some bool flags to handle redirections and assignments at the
    ##  beginning of the command line, if any; we can simply drop redirections
    ##  and assignments for sake of alias completion; for detail, read `SIMPLE
    ##  COMMAND EXPANSION` in `man bash`;

    ##  bool: check (outmost) redirection or assignment;
    local check_redass=1

    ##  bool: found (outmost) redirection or assignment in current word;
    local found_redass=0

    ##  examine each char of `str`; test branches are ordered; this order has
    ##  two importances: first is to respect substring relationship (eg: `&&`
    ##  must be tested before `&`); second is to test in optimistic order for
    ##  speeding up the testing; the first importance is compulsory and takes
    ##  precedence;
    local i=0 j=0
    for (( ; j < ${#str}; j++ )); do
        if (( ${#sta[@]} == 0 )); then
            if [[ "${str:j:1}" =~ [_a-zA-Z0-9] ]]; then
                :
            elif [[ $' \t\n' == *"${str:j:1}"* ]]; then
                if (( i < j )); then
                    if (( $found_redass == 1 )); then
                        if (( $check_redass == 0 )); then
                            words+=( "${str:i:j-i}" )
                        fi
                        found_redass=0
                    else
                        ##  no redass in current word; stop checking;
                        check_redass=0
                        words+=( "${str:i:j-i}" )
                    fi
                fi
                (( i = j + 1 ))
            elif [[ ":" == *"${str:j:1}"* ]]; then
                if (( i < j )); then
                    if (( $found_redass == 1 )); then
                        if (( $check_redass == 0 )); then
                            words+=( "${str:i:j-i}" )
                        fi
                        found_redass=0
                    else
                        ##  no redass in current word; stop checking;
                        check_redass=0
                        words+=( "${str:i:j-i}" )
                    fi
                fi
                words+=( "${str:j:1}" )
                (( i = j + 1 ))
            elif [[ '$(' == "${str:j:2}" ]]; then
                sta+=( ')' )
                (( j++ ))
            elif [[ '`' == "${str:j:1}" ]]; then
                sta+=( '`' )
            elif [[ '(' == "${str:j:1}" ]]; then
                sta+=( ')' )
            elif [[ '{' == "${str:j:1}" ]]; then
                sta+=( '}' )
            elif [[ '"' == "${str:j:1}" ]]; then
                sta+=( '"' )
            elif [[ "'" == "${str:j:1}" ]]; then
                sta+=( "'" )
            elif [[ '\ ' == "${str:j:2}" ]]; then
                (( j++ ))
            elif [[ '\$' == "${str:j:2}" ]]; then
                (( j++ ))
            elif [[ '\`' == "${str:j:2}" ]]; then
                (( j++ ))
            elif [[ '\"' == "${str:j:2}" ]]; then
                (( j++ ))
            elif [[ '\\' == "${str:j:2}" ]]; then
                (( j++ ))
            elif [[ "\'" == "${str:j:2}" ]]; then
                (( j++ ))
            elif [[ '&>' == "${str:j:2}" ]]; then
                found_redass=1
                (( j++ ))
            elif [[ '>&' == "${str:j:2}" ]]; then
                found_redass=1
                (( j++ ))
            elif [[ "><=" == *"${str:j:1}"* ]]; then
                found_redass=1
            elif [[ '&&' == "${str:j:2}" ]]; then
                words=()
                check_redass=1
                (( i = j + 2 ))
            elif [[ '||' == "${str:j:2}" ]]; then
                words=()
                check_redass=1
                (( i = j + 2 ))
            elif [[ '&' == "${str:j:1}" ]]; then
                words=()
                check_redass=1
                (( i = j + 1 ))
            elif [[ '|' == "${str:j:1}" ]]; then
                words=()
                check_redass=1
                (( i = j + 1 ))
            elif [[ ';' == "${str:j:1}" ]]; then
                words=()
                check_redass=1
                (( i = j + 1 ))
            fi
        elif [[ "${sta[-1]}" == ')' ]]; then
            if [[ ')' == "${str:j:1}" ]]; then
                unset sta[-1]
            elif [[ '$(' == "${str:j:2}" ]]; then
                sta+=( ')' )
                (( j++ ))
            elif [[ '`' == "${str:j:1}" ]]; then
                sta+=( '`' )
            elif [[ '(' == "${str:j:1}" ]]; then
                sta+=( ')' )
            elif [[ '{' == "${str:j:1}" ]]; then
                sta+=( '}' )
            elif [[ '"' == "${str:j:1}" ]]; then
                sta+=( '"' )
            elif [[ "'" == "${str:j:1}" ]]; then
                sta+=( "'" )
            elif [[ '\ ' == "${str:j:2}" ]]; then
                (( j++ ))
            elif [[ '\$' == "${str:j:2}" ]]; then
                (( j++ ))
            elif [[ '\`' == "${str:j:2}" ]]; then
                (( j++ ))
            elif [[ '\"' == "${str:j:2}" ]]; then
                (( j++ ))
            elif [[ '\\' == "${str:j:2}" ]]; then
                (( j++ ))
            elif [[ "\'" == "${str:j:2}" ]]; then
                (( j++ ))
            fi
        elif [[ "${sta[-1]}" == '}' ]]; then
            if [[ '}' == "${str:j:1}" ]]; then
                unset sta[-1]
            elif [[ '$(' == "${str:j:2}" ]]; then
                sta+=( ')' )
                (( j++ ))
            elif [[ '`' == "${str:j:1}" ]]; then
                sta+=( '`' )
            elif [[ '(' == "${str:j:1}" ]]; then
                sta+=( ')' )
            elif [[ '{' == "${str:j:1}" ]]; then
                sta+=( '}' )
            elif [[ '"' == "${str:j:1}" ]]; then
                sta+=( '"' )
            elif [[ "'" == "${str:j:1}" ]]; then
                sta+=( "'" )
            elif [[ '\ ' == "${str:j:2}" ]]; then
                (( j++ ))
            elif [[ '\$' == "${str:j:2}" ]]; then
                (( j++ ))
            elif [[ '\`' == "${str:j:2}" ]]; then
                (( j++ ))
            elif [[ '\"' == "${str:j:2}" ]]; then
                (( j++ ))
            elif [[ '\\' == "${str:j:2}" ]]; then
                (( j++ ))
            elif [[ "\'" == "${str:j:2}" ]]; then
                (( j++ ))
            fi
        elif [[ "${sta[-1]}" == '`' ]]; then
            if [[ '`' == "${str:j:1}" ]]; then
                unset sta[-1]
            elif [[ '$(' == "${str:j:2}" ]]; then
                sta+=( ')' )
                (( j++ ))
            elif [[ '(' == "${str:j:1}" ]]; then
                sta+=( ')' )
            elif [[ '{' == "${str:j:1}" ]]; then
                sta+=( '}' )
            elif [[ '"' == "${str:j:1}" ]]; then
                sta+=( '"' )
            elif [[ "'" == "${str:j:1}" ]]; then
                sta+=( "'" )
            elif [[ '\ ' == "${str:j:2}" ]]; then
                (( j++ ))
            elif [[ '\$' == "${str:j:2}" ]]; then
                (( j++ ))
            elif [[ '\`' == "${str:j:2}" ]]; then
                (( j++ ))
            elif [[ '\"' == "${str:j:2}" ]]; then
                (( j++ ))
            elif [[ '\\' == "${str:j:2}" ]]; then
                (( j++ ))
            elif [[ "\'" == "${str:j:2}" ]]; then
                (( j++ ))
            fi
        elif [[ "${sta[-1]}" == "'" ]]; then
            if [[ "'" == "${str:j:1}" ]]; then
                unset sta[-1]
            fi
        elif [[ "${sta[-1]}" == '"' ]]; then
            if [[ '"' == "${str:j:1}" ]]; then
                unset sta[-1]
            elif [[ '$(' == "${str:j:2}" ]]; then
                sta+=( ')' )
                (( j++ ))
            elif [[ '`' == "${str:j:1}" ]]; then
                sta+=( '`' )
            elif [[ '\$' == "${str:j:2}" ]]; then
                (( j++ ))
            elif [[ '\`' == "${str:j:2}" ]]; then
                (( j++ ))
            elif [[ '\"' == "${str:j:2}" ]]; then
                (( j++ ))
            elif [[ '\\' == "${str:j:2}" ]]; then
                (( j++ ))
            fi
        fi
    done

    ##  append the last word;
    if (( i < j )); then
        if (( $found_redass == 1 )); then
            if (( $check_redass == 0 )); then
                words+=( "${str:i:j-i}" )
            fi
            found_redass=0
        else
            ##  no redass in current word; stop checking;
            check_redass=0
            words+=( "${str:i:j-i}" )
        fi
    fi

    ##  unset the temp stack;
    unset sta

    ##  return value;
    __compal__retval=( "${words[@]}" )
}

##  expand aliases in command line;
##
##  $1
##  :   beg word index;
##  $2
##  :   end word index;
##  $3
##  :   ignored word index (can be null);
##  $4
##  :   number of used aliases;
##  ${@:4}
##  :   used aliases;
##  $?
##  :   difference of `${#COMP_WORDS}` before and after expansion;
__compal__expand_alias() {
    local beg="$1" end="$2" ignore="$3" n_used="$4"; shift 4
    local used=( "${@:1:$n_used}" ); shift "$n_used"

    if (( $beg == $end )) ; then
        ##  case 1: range is empty;
        __compal__retval=0
    elif [[ -n "$ignore" ]] && (( $beg == $ignore )); then
        ##  case 2: beg index is ignored; pass it;
        __compal__expand_alias \
            "$(( $beg + 1 ))" \
            "$end" \
            "$ignore" \
            "${#used[@]}" \
            "${used[@]}"
    elif ! alias "${COMP_WORDS[$beg]}" &>/dev/null; then
        ##  case 3: command is not an alias;
        __compal__retval=0
    elif ( __compal__inarr "${COMP_WORDS[$beg]}" "${used[@]}" ); then
        ##  case 4: command is an used alias;
        __compal__retval=0
    else
        ##  case 5: command is an unused alias;

        ##  get alias name;
        local cmd="${COMP_WORDS[$beg]}"

        ##  get alias body;
        local str0; str0="$(alias "$cmd")"
        str0="$(echo "${str0#*=}" | command xargs)"

        ##  split alias body into words;
        __compal__split_cmd_line "$str0"
        local words0=( "${__compal__retval[@]}" )

        ##  rebuild alias body; we need this because function `_split_cmd_line`
        ##  drops redirections and assignments, and only keeps the last command
        ##  in the last pipeline, in `words0`; therefore `str0` is not a simple
        ##  concat of `words0`; we rebuild this simple concat as `nstr0`; maybe
        ##  it is easier to view `str0` as raw and `nstr0` as genuine;
        local nstr0="${words0[*]}"

        ##  find index range of word `$COMP_WORDS[$beg]` in string `$COMP_LINE`;
        local i=0 j=0
        for (( i = 0; i <= $beg; i++ )); do
            for (( ; j <= ${#COMP_LINE}; j++ )); do
                [[ "${COMP_LINE:j}" == "${COMP_WORDS[i]}"* ]] && break
            done
            (( i == $beg )) && break
            (( j += ${#COMP_WORDS[i]} ))
        done

        ##  now `j` is at the beginning of word `$COMP_WORDS[$beg]`; and we know
        ##  the index range is `[j, j+${#cmd})`;

        ##  update `$COMP_LINE` and `$COMP_POINT`;
        COMP_LINE="${COMP_LINE:0:j}${nstr0}${COMP_LINE:j+${#cmd}}"
        if (( $COMP_POINT < j )); then
            :
        elif (( $COMP_POINT < j + ${#cmd} )); then
            ##  set current cursor position to the end of replacement string;
            (( COMP_POINT = j + ${#nstr0} ))
        else
            (( COMP_POINT += ${#nstr0} - ${#cmd} ))
        fi

        ##  update `$COMP_WORDS` and `$COMP_CWORD`;
        COMP_WORDS=(
            "${COMP_WORDS[@]:0:beg}"
            "${words0[@]}"
            "${COMP_WORDS[@]:beg+1}"
        )
        if (( $COMP_CWORD < $beg )); then
            :
        elif (( $COMP_CWORD < $beg + 1 )); then
            ##  set current word index to the last of replacement words;
            (( COMP_CWORD = $beg + ${#words0[@]} - 1 ))
        else
            (( COMP_CWORD += ${#words0[@]} - 1 ))
        fi

        ##  update `$ignore` if it is not empty; if so, we know `$ignore` is not
        ##  equal to `$beg` because we checked that in case 2; we need to update
        ##  `$ignore` only when `$ignore > $beg`; save this condition in a local
        ##  var `$ignore_gt_beg` because we need it later;
        if [[ -n "$ignore" ]]; then
            local ignore_gt_beg=0
            if (( $ignore > $beg )); then
                ignore_gt_beg=1
                (( ignore += ${#words0[@]} - 1 ))
            fi
        fi

        ##  recursively expand part 0;
        local used0=( "${used[@]}" "$cmd" )
        __compal__expand_alias \
            "$beg" \
            "$(( $beg + ${#words0[@]} ))" \
            "$ignore" \
            "${#used0[@]}" \
            "${used0[@]}"
        local diff0="$__compal__retval"

        ##  update `$ignore` if it is not empty and `$ignore_gt_beg` is true;
        if [[ -n "$ignore" ]] && (( $ignore_gt_beg == 1 )); then
            (( ignore += $diff0 ))
        fi

        ##  recursively expand part 1; must check `str0` not `nstr0`;
        if [[ -n "$str0" ]] && [[ "${str0: -1}" == ' ' ]]; then
            local used1=( "${used[@]}" )
            __compal__expand_alias \
                "$(( $beg + ${#words0[@]} + $diff0 ))" \
                "$(( $end + ${#words0[@]} - 1 + $diff0 ))" \
                "$ignore" \
                "${#used1[@]}" \
                "${used1[@]}"
            local diff1="$__compal__retval"
        else
            local diff1=0
        fi

        ##  return value;
        __compal__retval=$(( ${#words0[@]} - 1 + diff0 + diff1 ))
    fi
}

##  run a cspec using its args in argv fashion;
##
##  despite as described in `man bash`, `complete -p` does not always print an
##  existing completion in a way that can be reused as input; what complicates
##  the matter here are quotes and escapes;
##
##  as an example, when `complete -p` prints:
##
##      $ complete -p
##      complete -F _known_hosts "/tmp/aaa   bbb"
##
##  copy-paste running the above output gives wrong result:
##
##      $ complete -F _known_hosts "/tmp/aaa   bbb"
##      $ complete -p
##      complete -F _known_hosts /tmp/aaa   bbb
##
##  the correct command to give the same `complete -p` result is:
##
##      $ complete -F _known_hosts '"/tmp/aaa   bbb"'
##      $ complete -p
##      complete -F _known_hosts "/tmp/aaa   bbb"
##
##  to see another issue, this command gives a different result:
##
##      $ complete -F _known_hosts '/tmp/aaa\ \ \ bbb'
##      $ complete -p
##      complete -F _known_hosts /tmp/aaa\ \ \ bbb
##
##  note that these two `complete -p` results are *not* the same:
##
##      complete -F _known_hosts "/tmp/aaa   bbb"
##      complete -F _known_hosts /tmp/aaa\ \ \ bbb
##
##  despite this is true:
##
##      [[ "/tmp/aaa   bbb" == /tmp/aaa\ \ \ bbb ]]
##
##  so we must parse the `complete -p` result and run parsed result;
##
##  using `_split_cmd_line` to parse a cspec should be ok, because a cspec has
##  only one command without redirections or assignments, also without command
##  substitutions, etc.; we can then rerun this cspec in an argv fashion using
##  this function;
##
##  $@
##  :   cspec args;
__compal__run_cspec_args() {
    local cspec_args=( "$@" )

    ##  ensure this is indeed a cspec;
    if [[ "${cspec_args[0]}" == "complete" ]]; then
        ##  run parsed completion command;
        "${cspec_args[@]}"
    else
        __compal__error "not a complete command: ${cspec_args[*]}"
    fi
}

##  the "auto" implementation of `_unmask_alias`;
##
##  this function is called only when using auto unmask;
##
##  $1
##  :   alias command;
__compal__unmask_alias_auto() {
    local cmd="$1"

    ##  load vanilla completion of this command;
    local cspec="${__compal__vanilla_cspecs[$cmd]}"

    if [[ -n "$cspec" ]]; then
        ##  a vanilla cspec for this command is found; due to some issues with
        ##  `complete -p` we cannot eval this cspec directly; instead, we need
        ##  to parse and run it in argv fashion; see `_run_cspec_args` comment;
        __compal__split_cmd_line "$cspec"
        local cspec_args=( "${__compal__retval[@]}" )
        __compal__run_cspec_args "${cspec_args[@]}"
    else
        ##  a (parsed) vanilla cspec for this command is not found; search raw
        ##  vanilla cspecs for this command; if a matched raw vanilla cspec is
        ##  found, then parse, save and run it; search is a loop because these
        ##  raw cspecs are not parsed yet;
        for _cspec in "${!__compal__raw_vanilla_cspecs[@]}"; do
            if [[ "$_cspec" == *" $cmd" ]]; then
                __compal__split_cmd_line "$_cspec"
                local _cspec_args=( "${__compal__retval[@]}" )

                ##  ensure this cspec has the correct command;
                local _cspec_cmd="${_cspec_args[-1]}"
                if [[ "$_cspec_cmd" == "$cmd" ]]; then
                    __compal__vanilla_cspecs["$_cspec_cmd"]="$_cspec"
                    unset __compal__raw_vanilla_cspecs["$_cspec"]
                    __compal__run_cspec_args "${_cspec_args[@]}"
                    return
                fi
            fi
        done

        ##  no vanilla cspec for this command is found; we remove the current
        ##  cspec for this command (which should be `_complete_alias`), which
        ##  effectively uses the default cspec (ie: `complete -D`) to process
        ##  this command; we do not fallback to `_completion_loader`, because
        ##  the default cspec could be something else, and here we want to be
        ##  consistent;
        complete -r "$cmd"
    fi
}

##  the "manual" implementation of `_unmask_alias`;
##
##  this function is called only when using manual unmask;
##
##  users may edit this function to customize vanilla command completions;
##
##  $1
##  :   alias command;
__compal__unmask_alias_manual() {
    local cmd="$1"

    case "$cmd" in
        bind)
            complete -A binding "$cmd"
            ;;
        help)
            complete -A helptopic "$cmd"
            ;;
        set)
            complete -A setopt "$cmd"
            ;;
        shopt)
            complete -A shopt "$cmd"
            ;;
        bg)
            complete -A stopped -P '"%' -S '"' "$cmd"
            ;;
        service)
            complete -F _service "$cmd"
            ;;
        unalias)
            complete -a "$cmd"
            ;;
        builtin)
            complete -b "$cmd"
            ;;
        command|type|which)
            complete -c "$cmd"
            ;;
        fg|jobs|disown)
            complete -j -P '"%' -S '"' "$cmd"
            ;;
        groups|slay|w|sux)
            complete -u "$cmd"
            ;;
        readonly|unset)
            complete -v "$cmd"
            ;;
        traceroute|traceroute6|tracepath|tracepath6|fping|fping6|telnet|rsh|\
            rlogin|ftp|dig|mtr|ssh-installkeys|showmount)
            complete -F _known_hosts "$cmd"
            ;;
        aoss|command|do|else|eval|exec|ltrace|nice|nohup|padsp|then|time|\
            tsocks|vsound|xargs)
            complete -F _command "$cmd"
            ;;
        fakeroot|gksu|gksudo|kdesudo|really)
            complete -F _root_command "$cmd"
            ;;
        a2ps|awk|base64|bash|bc|bison|cat|chroot|colordiff|cp|csplit|cut|date|\
            df|diff|dir|du|enscript|env|expand|fmt|fold|gperf|grep|grub|head|\
            irb|ld|ldd|less|ln|ls|m4|md5sum|mkdir|mkfifo|mknod|mv|netstat|nl|\
            nm|objcopy|objdump|od|paste|pr|ptx|readelf|rm|rmdir|sed|seq|\
            sha{,1,224,256,384,512}sum|shar|sort|split|strip|sum|tac|tail|tee|\
            texindex|touch|tr|uname|unexpand|uniq|units|vdir|wc|who)
            complete -F _longopt "$cmd"
            ;;
        *)
            _completion_loader "$cmd"
            ;;
    esac
}

##  set completion function of an alias command to the vanilla one;
##
##  $1
##  :   alias command;
__compal__unmask_alias() {
    local cmd="$1"

    ##  ensure current completion function of this command is `_complete_alias`;
    if [[ "$(complete -p "$cmd")" != *"-F _complete_alias"* ]]; then
        __compal__error "cannot unmask alias command: $cmd"
        return
    fi

    ##  decide which unmask function to call;
    if (( "$COMPAL_AUTO_UNMASK" == 1 )); then
        __compal__unmask_alias_auto "$@"
    else
        __compal__unmask_alias_manual "$@"
    fi
}

##  set completion function of an alias command to `_complete_alias`; doing so
##  overwrites the original completion function for this command, if any; this
##  makes `_complete_alias` look like a "mask" on the alias command; then, why
##  is this function called a "remask"? because this function is always called
##  in pair with (and after) a corresponding "unmask" function; the 1st "mask"
##  happens when user directly runs `complete -F _complete_alias ...`;
##
##  $1
##  :   alias command;
__compal__remask_alias() {
    local cmd="$1"

    complete -F _complete_alias "$cmd"
}

##  delegate completion to `bash-completion`;
__compal__delegate() {
    ##  `_command_offset` is a meta-command completion function provided by
    ##  `bash-completion`; the documentation does not say it will work with
    ##  argument `0`, but looking at its code (version 2.11) it should;
    _command_offset 0
}

##  delegate completion to `bash-completion`, within a transient context in
##  which the input alias command is unmasked;
##
##  this function expects current completion function of this command to be
##  `_complete_alias`;
##
##  $1
##  :   alias command to be unmasked;
__compal__delegate_in_context() {
    local cmd="$1"

    ##  unmask alias:
    __compal__unmask_alias "$cmd"

    ##  do actual completion;
    __compal__delegate

    ##  remask alias:
    __compal__remask_alias "$cmd"
}

##  save vanilla completions; run this function when this script is sourced;
##  this ensures vanilla completions of alias commands are fetched and saved
##  before they are overwritten by `complete -F _complete_alias`;
##
##  this function saves raw cspecs and does not parse them; for other useful
##  comments about parsing and running cspecs see function `_run_cspec_args`;
##
##  running this function on source is mandatory only when using auto unmask;
##  when using manual unmask, it is safe to skip this function on source;
__compal__save_vanilla_cspecs() {
    ##  get default cspec;
    local def_cspec; def_cspec="$(complete -p -D 2>/dev/null)"

    ##  `complete -p` prints cspec for one command per line; so we can loop;
    while IFS= read -r cspec; do

        ##  skip default cspec;
        [[ "$cspec" != "$def_cspec" ]] || continue

        ##  skip `-F _complete_alias` cspecs;
        [[ "$cspec" != *"-F _complete_alias"* ]] || continue

        ##  now we have a vanilla cspec; save it in `_raw_vanilla_cspecs`;
        __compal__raw_vanilla_cspecs["$cspec"]=""

    done < <(complete -p 2>/dev/null)
}

##  completion function for non-alias commands; normally, the mere invocation of
##  this function indicates an error of command completion configuration because
##  we are invoking `_complete_alias` on a non-alias command; but there can be a
##  special case: `_command_offset` will try with command basename when there is
##  no completion for the command itself; an example is `sudo /bin/ls` when both
##  `sudo` and `ls` are aliases; this function takes care of this special case;
##
##  $1
##  :   the name of the command whose arguments are being completed;
##  $2
##  :   the word being completed;
##  $3
##  :   the word preceding the word being completed on the current command line;
__compal__complete_non_alias() {
    ##  get command name; must be non-alias;
    local cmd="${COMP_WORDS[0]}"

    ##  get command basename;
    local compcmd="${cmd##*/}"

    if alias "$compcmd" &>/dev/null; then
        ##  if command basename is an alias, delegate completion;
        __compal__delegate_in_context "$compcmd"
    else
        ##  else, this indicates an error;
        __compal__error "command is not an alias: $cmd"
    fi
}

##  completion function for alias commands;
##
##  $1
##  :   the name of the command whose arguments are being completed;
##  $2
##  :   the word being completed;
##  $3
##  :   the word preceding the word being completed on the current command line;
__compal__complete_alias() {
    ##  get command name; must be alias;
    local cmd="${COMP_WORDS[0]}"

    ##  we expand aliases only for the original command line (ie: the command
    ##  line on which user pressed `<tab>`); unfortunately, we may not have a
    ##  chance to see the original command line, and we have no way to ensure
    ##  that; we take an approximation: we expand aliases only in the outmost
    ##  call of this function, which implies only on the first occasion of an
    ##  alias command; we can ensure this condition using a refcnt and expand
    ##  aliases iff the refcnt is equal to 0; this approximation always works
    ##  correctly when the 1st word on the original command line is an alias;
    ##
    ##  this approximation may fail when the 1st word on the original command
    ##  line is not an alias; an example that expects files but gets ip addrs:
    ##
    ##      $ unalias sudo
    ##      $ complete -r sudo
    ##      $ alias ls='ping'
    ##      $ complete -F _complete_alias ls
    ##      $ sudo ls <tab>
    ##      {ip}
    ##      {ip}
    ##      {ip}
    ##      ...
    ##
    if (( __compal__refcnt == 0 )); then

        ##  find index range of word `$COMP_WORDS[$COMP_CWORD]` in string
        ##  `$COMP_LINE`; dont expand this word if `$COMP_POINT` (cursor
        ##  position) lies in this range because the word may be incomplete;
        local i=0 j=0
        for (( ; i <= $COMP_CWORD; i++ )); do
            for (( ; j <= ${#COMP_LINE}; j++ )); do
                [[ "${COMP_LINE:j}" == "${COMP_WORDS[i]}"* ]] && break
            done
            (( i == $COMP_CWORD )) && break
            (( j += ${#COMP_WORDS[i]} ))
        done

        ##  now `j` is at the beginning of word `$COMP_WORDS[$COMP_CWORD]`; and
        ##  we know the index range is `[j, j+${#COMP_WORDS[$COMP_CWORD]}]`; we
        ##  include the right endpoint to cover the case where cursor is at the
        ##  exact end of the word; compare the index range with `$COMP_POINT`;
        if (( j <= $COMP_POINT )) && \
            (( $COMP_POINT <= j + ${#COMP_WORDS[$COMP_CWORD]} )); then
            local ignore="$COMP_CWORD"
        else
            local ignore=""
        fi

        ##  expand aliases;
        __compal__expand_alias 0 "${#COMP_WORDS[@]}" "$ignore" 0
    fi

    ##  increase refcnt;
    (( __compal__refcnt++ ))

    ##  delegate completion in context; this actually contains several steps:
    ##
    ##  -   unmask alias:
    ##
    ##      since aliases have been fully expanded, no need to consider aliases
    ##      in the resulting command line; therefore, we now set the completion
    ##      function for this alias to the vanilla, alias-free one; this avoids
    ##      infinite recursion when using self-aliases (eg: `alias ls='ls -a'`);
    ##
    ##  -   do actual completion:
    ##
    ##      `_command_offset` is a meta-command completion function provided by
    ##      `bash-completion`; the documentation does not say it will work with
    ##      argument `0`, but looking at its code (version 2.11) it should;
    ##
    ##  -   remask alias:
    ##
    ##      reset this command completion function to `_complete_alias`;
    ##
    ##  these steps are put into one function `_delegate_in_context`;
    __compal__delegate_in_context "$cmd"

    ##  decrease refcnt;
    (( __compal__refcnt-- ))
}

##  this is the function to be set with `complete -F`; this function expects
##  alias commands, but can also handle non-alias commands in rare occasions;
##
##  as a standard completion function, this function can take 3 arguments as
##  described in `man bash`; they are currently not being used, though;
##
##  $1
##  :   the name of the command whose arguments are being completed;
##  $2
##  :   the word being completed;
##  $3
##  :   the word preceding the word being completed on the current command line;
_complete_alias() {
    ##  get command;
    local cmd="${COMP_WORDS[0]}"

    ##  complete command;
    if ! alias "$cmd" &>/dev/null; then
        __compal__complete_non_alias "$@"
    else
        __compal__complete_alias "$@"
    fi
}

##  main function;
__compal__main() {
    if (( "$COMPAL_AUTO_UNMASK" == 1 )); then
        ##  save vanilla completions;
        __compal__save_vanilla_cspecs
    fi
}

##  ============================================================================
##  # script
##  ============================================================================

##  run main function;
if [ -f /etc/bash_completion ]; then
__compal__main

##  ============================================================================
##  # complete user-defined aliases
##  ============================================================================

##  to complete specific aliases, uncomment and edit these lines;
#complete -F _complete_alias myalias1
#complete -F _complete_alias myalias2
#complete -F _complete_alias myalias3

##  to complete all aliases, run this line after all aliases have been defined;
complete -F _complete_alias "${!BASH_ALIASES[@]}"
fi

# # Workaround for bash-completion not supporting some Bash options.
# # We disable the unsupported options when typing a command line, and re-enable
# # them before Bash expands and executes the command line.
# function save_shell_options() {
# 	_saved_set="$(set +o)"
# 	_saved_shopt="$(shopt -p nullglob failglob)"
# 	set +o nounset
# 	shopt -u nullglob failglob
# }
# function restore_shell_options() {
# 	[ -z "${_saved_set+x}" ] && return
# 	eval "$_saved_set"
# 	eval "$_saved_shopt"
# 	unset _saved_set _saved_shopt
# }
# # We use the PROMPT_COMMAND var to run a command just before showing the prompt.
# # Note: For some reason, changes to shell options only take effect if this is
# # the *last* command executed by PROMPT_COMMAND.
# PROMPT_COMMAND="$PROMPT_COMMAND
# save_shell_options;"
# # We use the DEBUG trap to run a command after the command line is entered, but
# # before it is expanded by Bash.
# # Note: This is very hackish. The manual is not explicit as whether the trap is
# # actually called *before* expansion, even though that’s what happens in
# # practice. Moreover, the trap is called before each *simple* command, including
# # before commands in PROMPT_COMMAND.
# trap="$(trap -p DEBUG)" ; trap="${trap#trap -- }" ; trap="${trap% DEBUG}"
# eval "trap 'restore_shell_options;'$trap DEBUG"
# unset trap
# # We cannot use PS1 and PS0, as we would only have access to a subshell.
#!/bin/sh

if [ -r /proc/version ] && grep -q microsoft /proc/version; then
	alias xdg-open='explorer.exe'
	alias n='notepad.exe'
	PATH="$PATH:/mnt/d/bin:/mnt/c/Program Files (x86)/Arduino"
fi

mkdir -p ~/.local/share/vim/shada/
mkdir -p ~/.local/share/vim/swap/
mkdir -p ~/.local/share/vim/undo/

if command -v perl > /dev/null; then
    mkdir -p ~/.local/bin
    PATH="$HOME/.local/bin${PATH:+:${PATH}}"
    PERL5LIB="$HOME/.local/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
    PERL_LOCAL_LIB_ROOT="$HOME/.local${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
    PERL_MB_OPT="--install_base \"$HOME/.local\""
    PERL_MM_OPT="INSTALL_BASE=$HOME/.local"
    export PERL5LIB PERL_LOCAL_LIB_ROOT PERL_MB_OPT PERL_MM_OPT PATH
fi

if [ -r "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi
