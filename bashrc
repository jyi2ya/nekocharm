#!/bin/bash

nekoactivate() {
    if [ -n "$NEKOACTIVATED" ]; then
        echo "neko already activated" >&2
        return 1
    fi

    if [ -z "$NEKONAME" ]; then
        echo '$NEKONAME not set' >&2
        return 1
    fi

    export PATH="$HOME/.local/bin/:$PATH"
    export MANPATH="$HOME/.local/share/man:$MANPATH";
    export INFOPATH="$HOME/.local/share/info:$INFOPATH";
    export LIBRARY_PATH="$HOME/.local/lib/:$LIBRARY_PATH"
    export LD_LIBRARY_PATH="$HOME/.local/lib/:$LD_LIBRARY_PATH"
    export C_INCLUDE_PATH="$HOME/.local/include/ncurses/:$HOME/.local/include/:$C_INCLUDE_PATH"

    export HOME="$HOME/$NEKONAME"
    mkdir -p "$HOME"

    export PATH="$HOME/.local/bin/:$PATH"
    export MANPATH="$HOME/.local/share/man:$MANPATH";
    export INFOPATH="$HOME/.local/share/info:$INFOPATH";
    export LIBRARY_PATH="$HOME/.local/lib/:$LIBRARY_PATH"
    export LD_LIBRARY_PATH="$HOME/.local/lib/:$LD_LIBRARY_PATH"
    export C_INCLUDE_PATH="$HOME/.local/include/ncurses/:$HOME/.local/include/:$C_INCLUDE_PATH"

    export HOMEBREW_PREFIX="$HOME/.local/brew";
    export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar";
    export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX/Homebrew";

    export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH";
    export MANPATH="$HOMEBREW_PREFIX/share/man:$MANPATH";
    export INFOPATH="$HOMEBREW_PREFIX/share/info:$INFOPATH";
    export LIBRARY_PATH="$HOMEBREW_PREFIX/lib/:$LIBRARY_PATH"
    export LD_LIBRARY_PATH="$HOMEBREW_PREFIX/lib/:$LD_LIBRARY_PATH"
    export C_INCLUDE_PATH="$HOMEBREW_PREFIX/include/ncurses/:$HOMEBREW_PREFIX/.local/include/:$C_INCLUDE_PATH"

    mkdir -p ~/.local/tmux
    export TMUX_TMPDIR="$HOME/.local/tmux"

    export NEKOACTIVATED=1

    return 0
}

nekocharm() {
    nekoactivate || return 1
    cd ~ || true
    exec bash
}

if [ -n "$NEKONAME" ]; then
    nekocharm
fi
