#!/bin/bash

nekoactivate() {
    if [ -n "$NEKOACTIVATED" ]; then
        echo "neko already activated" >&2
        return
    fi

    export HOME="$HOME/.nekoneko"
    export PATH="$HOME/.local/bin/:$PATH"
    export LIBRARY_PATH="$HOME/.local/lib/:$LIBRARY_PATH"
    export LD_LIBRARY_PATH="$HOME/.local/lib/:$LD_LIBRARY_PATH"
    export C_INCLUDE_PATH="$HOME/.local/include/ncurses/:$HOME/.local/include/:$C_INCLUDE_PATH"
    export NEKOACTIVATED=1
}

nekocharm() {
    nekoactivate
    cd ~ || true
    if command -v tmux >/dev/null && [ -z "$TMUX" ]; then
        tmux attach-session -t nekoneko || tmux new-session -e NEKOTMUX=tmuxlogin -s nekoneko
        exit
    fi
}

if [ "$NEKOTMUX" = tmuxlogin ]; then
    nekoactivate
    export NEKOTMUX=tmuxlogined
    cd ~ || true
    exec bash
fi
