#!/bin/bash

#!/bin/bash
INSTALL_DIR="$HOME/.salvapantallas"
CONFIG_FILE="$INSTALL_DIR/salvapantallas.conf"

echo "=================================================="
echo "  Instalador de Salvapantallas para GNOME"
echo "=================================================="
echo ""
echo "Elige qué tipo de salvapantallas quieres configurar:"
echo "  1) Animación estilo Matrix en terminal (cmatrix)"
echo "  2) Vídeo o GIF personalizado en pantalla completa (mpv)"
echo ""
read -p "Selecciona una opción [1 o 2]: " OPCION

# Crear directorio de instalación oculto
mkdir -p "$INSTALL_DIR"

case "$OPCION" in
    1)
        if ! command -v cmatrix >/dev/null 2>&1; then
            echo ""
            echo "Aviso: 'cmatrix' no está instalado en tu sistema."
            echo "Instálalo ejecutando: sudo apt install cmatrix"
            exit 0
        fi
        echo "MODO=cmatrix" > "$CONFIG_FILE"
        echo "MEDIA=" >> "$CONFIG_FILE"
        echo "Configurado en modo Matrix."
        ;;
    2)
        echo ""
        read -p "Introduce la ruta completa del vídeo o GIF (ej. /home/$USER/Vídeos/fondo.mp4): " RUTA_MEDIA
        # Expande la virgulilla (~) si el usuario la escribió
        RUTA_MEDIA="${RUTA_MEDIA/#\~/$HOME}"

        if [ ! -f "$RUTA_MEDIA" ]; then
            echo "Error: No se encuentra el archivo '$RUTA_MEDIA'. Verifica la ruta e inténtalo de nuevo."
            exit 1
        fi

        if ! command -v mpv >/dev/null 2>&1; then
            echo ""
            echo "Aviso: 'mpv' no está instalado en tu sistema."
            echo "Instálalo ejecutando: sudo apt install mpv"
            exit 0
        fi

        echo "MODO=media" > "$CONFIG_FILE"
        echo "MEDIA=\"$RUTA_MEDIA\"" >> "$CONFIG_FILE"
        echo "Configurado con el archivo: $RUTA_MEDIA"
        ;;
    *)
        echo "Opción no válida. Instalación cancelada."
        exit 1
        ;;
esac

# 1. Instalar cmatriz para mostrar lluvia de caracteres
echo ""
echo "¿Desea instalar el servicio para mostrar salvapantallas?(si/no)"
read respuesta

# Convertir la respuesta a minúsculas
respuesta=$(echo "$respuesta" | tr '[:upper:]' '[:lower:]')

if [ "$respuesta" = "si" ] || [ "$respuesta" = "s" ]; then
    echo "Instalando Salvapantallas para GNOME..."
    # 1. Copiar scripts al directorio del usuario
    cp salvapantallas.sh "$INSTALL_DIR/salvapantallas.sh"
    cp vigilante.sh "$INSTALL_DIR/vigilante.sh"
    # 2. Dar permisos de ejecución
    chmod +x "$INSTALL_DIR/salvapantallas.sh"
    chmod +x "$INSTALL_DIR/vigilante.sh"
    # 3. Copiar el archivo de servicio de usuario en systemd
    mkdir -p "$HOME/.config/systemd/user"
    cp salvapantallas.service "$HOME/.config/systemd/user/salvapantallas.service"
    # 4. Recargar y activar el servicio
    systemctl --user daemon-reload
    systemctl --user enable --now salvapantallas.service
    echo "Instalación completada. Servicio iniciado."
    echo "Compruebe el estado con: systemctl --user status salvapantallas.service"
    echo "Reinicie el servicio con: systemctl --user restart salvapantallas.service"
    echo "Detenga el servicio con: systemctl --user stop salvapantallas.service"
    echo "Inicie el servicio con: systemctl --user start salvapantallas.service" 
elif [ "$respuesta" = "no" ] || [ "$respuesta" = "n" ]; then
    echo "Saliendo sin realizar cambios."
    exit 0
else
    echo "Opción no válida. Saliendo sin realizar cambios."
    exit 1
fi

