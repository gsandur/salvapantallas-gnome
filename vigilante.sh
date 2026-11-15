#!/bin/bash

# --- CONFIGURACIÓN ---
TIEMPO_INACTIVIDAD=180000  # Tiempo para activar el salvapantallas (en ms: 15000 = 15s)
SEGUNDOS_PARA_VOLVER=1    # Segundos de movimiento continuo necesarios para desactivarlo
SCRIPT_SALVAPANTALLAS="$HOME/.salvapantallas/salvapantallas.sh"
# ---------------------

ACTIVO=0
MOVIMIENTO_CONTADOR=0

while true; do
    # Consulta los milisegundos de inactividad en GNOME Mutter
    INACTIVO=$(dbus-send --print-reply --dest=org.gnome.Mutter.IdleMonitor \
        /org/gnome/Mutter/IdleMonitor/Core \
        org.gnome.Mutter.IdleMonitor.GetIdletime 2>/dev/null | awk '/uint64/ {print $2}')

    # Si hay un error puntual leyendo D-Bus, espera y reintenta
    if [ -z "$INACTIVO" ]; then
        sleep 1
        continue
    fi

    if [ "$ACTIVO" -eq 0 ]; then
        # Estado normal: esperando inactividad
        if [ "$INACTIVO" -ge "$TIEMPO_INACTIVIDAD" ]; then
            "$SCRIPT_SALVAPANTALLAS" iniciar &
            ACTIVO=1
            MOVIMIENTO_CONTADOR=0
        fi
    else
        # Salvapantallas activo: comprobando movimiento sostenido
        if [ "$INACTIVO" -lt 1500 ]; then
            MOVIMIENTO_CONTADOR=$((MOVIMIENTO_CONTADOR + 1))
            if [ "$MOVIMIENTO_CONTADOR" -ge "$SEGUNDOS_PARA_VOLVER" ]; then
                "$SCRIPT_SALVAPANTALLAS" detener
                ACTIVO=0
                MOVIMIENTO_CONTADOR=0
            fi
        else
            # Reinicia el contador si fue un toque accidental o micro-movimiento
            MOVIMIENTO_CONTADOR=0
        fi
    fi

    sleep 1
done
