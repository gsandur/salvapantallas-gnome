#!/bin/bash

PID_FILE="/tmp/salvapantallas.pid"

case "$1" in
    iniciar)
        if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
            exit 0
        fi

        # Abre gnome-terminal en pantalla completa ejecutando cmatrix en verde
        gnome-terminal --full-screen --hide-menubar -- cmatrix -b -C green >/dev/null 2>&1 &
        echo $! > "$PID_FILE"
        ;;

    detener)
        if [ -f "$PID_FILE" ]; then
            kill "$(cat "$PID_FILE")" 2>/dev/null
            rm -f "$PID_FILE"
        fi
        pkill -f "cmatrix -b -C green" 2>/dev/null
        ;;

    *)
        echo "Uso: $0 {iniciar|detener}"
        exit 1
        ;;
esac
