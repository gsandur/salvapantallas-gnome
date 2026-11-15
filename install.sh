#!/bin/bash

# 1. Instalar cmatriz para mostrar lluvia de caracteres
echo "¿Desea instalar cmatrix para mostrar salvapantallas?(si/no)"
read respuesta

# Convertir la respuesta a minúsculas
respuesta=$(echo "$respuesta" | tr '[:upper:]' '[:lower:]')

if [ "$respuesta" = "si" ] || [ "$respuesta" = "s" ]; then
    echo "Instalando Salvapantallas para GNOME..."
    # 0. Instalar cmatrix como tema del salvapantallas
    apt install cmatrix
    # 1. Copiar scripts al directorio del usuario
    cp salvapantallas.sh "$HOME/.salvapantallas.sh"
    cp vigilante.sh "$HOME/.vigilante.sh"
    # 2. Dar permisos de ejecución
    chmod +x "$HOME/.salvapantallas.sh"
    chmod +x "$HOME/.vigilante.sh"
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

