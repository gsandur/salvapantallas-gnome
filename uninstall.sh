#!/bin/bash

echo "Desinstalando Salvapantallas Personalizado..."

# 1. Detener y deshabilitar el servicio
systemctl --user disable --now salvapantallas.service 2>/dev/null

# 2. Eliminar servicio y directorio de instalación
rm -f "$HOME/.config/systemd/user/salvapantallas.service"
rm -rf "$HOME/.salvapantallas"

# 3. Limpiar archivo temporal PID si quedó abierto
rm -f /tmp/salvapantallas.pid

# 4. Recargar systemd
systemctl --user daemon-reload

echo "Desinstalación completada. Todos los archivos y servicios han sido eliminados."