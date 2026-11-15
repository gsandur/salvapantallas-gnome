#!/bin/bash
CONFIG_FILE="$HOME/.salvapantallas.conf"
PID_FILE="/tmp/salvapantallas.pid"

# Cargar configuración (por defecto cmatrix si no existe el archivo)
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    MODO="cmatrix"
fi

case "$1" in
    iniciar)
        # Evita abrir múltiples instancias si ya está corriendo
        if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
            exit 0
        fi

        if [ "$MODO" = "media" ] && [ -f "$MEDIA" ]; then
            mpv --fs --loop --no-audio --no-osc --no-osd-bar --input-default-bindings=no "$MEDIA" >/dev/null 2>&1 &
            echo $! > "$PID_FILE"
        else
            gnome-terminal --full-screen --hide-menubar -- cmatrix -b -C green >/dev/null 2>&1 &
            echo $! > "$PID_FILE"
        fi
        ;;

    detener)
        if [ -f "$PID_FILE" ]; then
            kill "$(cat "$PID_FILE")" 2>/dev/null
            rm -f "$PID_FILE"
        fi
        # Limpieza segura de los procesos hijos según el modo
        pkill -f "cmatrix -b -C green" 2>/dev/null
        pkill -f "mpv --fs --loop" 2>/dev/null
        ;;

    *)
        echo "Uso: $0 {iniciar|detener}"
        exit 1
        ;;
esac
