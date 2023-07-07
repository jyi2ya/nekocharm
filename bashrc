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

    export HOME="$HOME/$NEKONAME"
    mkdir -p "$HOME"

    export PATH="$HOME/.local/bin/:$PATH"
    export LIBRARY_PATH="$HOME/.local/lib/:$LIBRARY_PATH"
    export LD_LIBRARY_PATH="$HOME/.local/lib/:$LD_LIBRARY_PATH"
    export C_INCLUDE_PATH="$HOME/.local/include/ncurses/:$HOME/.local/include/:$C_INCLUDE_PATH"
    export NEKOACTIVATED=1

    mkdir -p ~/.local/tmux
    export TMUX_TMPDIR="$HOME/.local/tmux"

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
