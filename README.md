# Salvapantallas Personalizado para GNOME (Wayland / X11)

Daemon ligero en Bash que detecta la inactividad del sistema en escritorios **GNOME** mediante D-Bus (`org.gnome.Mutter.IdleMonitor`) y ejecuta un salvapantallas personalizado. 

A diferencia de soluciones basadas en `swayidle` o `xautolock`, este proyecto funciona de forma nativa tanto en **Wayland** como en **X11**, e incluye protección contra toques accidentales exigiendo **2 segundos de movimiento continuo** para restaurar la sesión.

## Características

- Compatible con **GNOME en Wayland y X11**.
- Ejecución persistente en segundo plano mediante `systemd --user`.
- **Anti-toques accidentales:** Requiere movimiento sostenido durante 2 segundos para cerrar el salvapantallas.
- Fácilmente personalizable para lanzar vídeos (`mpv`), animaciones de terminal (`cmatrix`, `asciiquarium`) o scripts propios.

## Estructura del proyecto

- `salvapantallas.sh`: Define qué ocurre al `iniciar` y `detener` el salvapantallas.
- `vigilante.sh`: Monitoriza el tiempo de inactividad vía D-Bus y gestiona el retardo de 2 segundos.
- `salvapantallas.service`: Unidad de `systemd --user` para la ejecución en segundo plano.
- `install.sh` / `uninstall.sh`: Scripts automatizados de instalación y limpieza.

## Requisitos

- Entorno de escritorio **GNOME**.
- `dbus-send` (incluido por defecto en la mayoría de distribuciones Linux).
- `mpv` (si utilizas la plantilla por defecto para reproducir vídeo).

## Instalación

1. Clona este repositorio:
   ```bash
   git clone [https://github.com/gsandur/salvapantallas-gnome.git](https://github.com/gsandur/salvapantallas-gnome.git)
   cd salvapantallas-gnome
