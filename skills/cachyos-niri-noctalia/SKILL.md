---
name: cachyos-niri-noctalia
description: >-
  Ayuda a entender, configurar y diagnosticar el entorno de escritorio CachyOS con el
  compositor Wayland Niri y la shell Noctalia. Úsala cuando el usuario pregunte sobre atajos,
  monitores, reglas de ventanas, personalización de la barra/widgets o resolución de problemas en Niri y Noctalia.
---

# CachyOS Niri + Noctalia Assistant Skill

Esta skill está diseñada para asistir en la comprensión, configuración, optimización y diagnóstico de **CachyOS** ejecutando el compositor Wayland de tiling continuo **Niri** junto con la shell de escritorio **Noctalia**.

---

## 1. Principios de Operación y Seguridad

> [!IMPORTANT]
> **REGLA DE VERIFICACIÓN DINÁMICA**: Las rutas, versiones, monitores y servicios pueden cambiar con el tiempo. **Nunca asumas que el estado es estático ni reutilices rutas o atajos a ciegas.** Antes de cada diagnóstico o ajuste, comprueba el estado actual en el sistema.

### Reglas estrictas de comportamiento
1. **Diagnóstico primero:** Ante cualquier duda, incidencia o solicitud de ajuste, primero inspecciona con comandos de solo lectura, analiza y explica claramente los hallazgos.
2. **Protocolo previo a cualquier cambio:**
   - Muestra de forma explícita el cambio propuesto (formato diff o bloque claro de antes/después).
   - Indica el comando exacto para realizar una copia de seguridad del archivo antes de editarlo (ejemplo: `cp <archivo> <archivo>.bak.$(date +%Y%m%d_%H%M%S)`).
   - **Espera la autorización expresa del usuario antes de modificar cualquier archivo.**
3. **Acciones no permitidas sin solicitud previa y explícita:**
   - **NO** ejecutar comandos destructivos (`rm -rf`, sobreescritura sin backup, etc.).
   - **NO** instalar, actualizar ni desinstalar paquetes (`pacman`, `paru`, `yay`).
   - **NO** reiniciar, detener o activar servicios de sistema o de usuario (`systemctl`).
   - **NO** recargar la configuración del compositor en caliente (`niri msg action load-config-file`) ni matar procesos (`kill`, `pkill`) de Niri o Noctalia sin confirmación.
   - **NO** invocar `sudo` ni ejecutar comandos con privilegios elevados.

---

## 2. Mapa de Arquitectura y Referencias del Sistema

*(Basado en la configuración base de CachyOS `cachyos-niri-noctalia`, sujeta a verificación en vivo).*

### A. Niri Compositor
- **Ejecutable y servicio:** `/usr/bin/niri`, servicio de usuario systemd `niri.service` (lanzado vía `niri-session`).
- **Archivo principal:** `~/.config/niri/config.kdl` (organizado de forma modular mediante directivas `include`).
- **Módulos habituales en `~/.config/niri/cfg/`:**
  - `autostart.kdl`: Programas al inicio (por defecto lanza `spawn-at-startup "noctalia"`).
  - `keybinds.kdl`: Atajos de teclado para Niri y llamadas IPC a Noctalia (`noctalia msg ...`).
  - `display.kdl`: Salidas de pantalla, resolución, tasa de refresco y escalado (e.g. `output "<conector>" { ... }`).
  - `layout.kdl`: Gaps, tamaños preestablecidos de columna, `background-color "transparent"` (vital para el wallpaper de Noctalia).
  - `rules.kdl`: Reglas para aplicaciones (`window-rule`) y capas de la shell (`layer-rule` para fondos, paneles y barras).
  - `input.kdl`: Teclado, touchpad, aceleración de ratón y foco.
  - `misc.kdl`: Variables de entorno Wayland (`QT_QPA_PLATFORM`, etc.), cursor, efectos de blur y ruta de capturas.
  - `animation.kdl`: Animaciones de ventanas, espacios y transiciones.

### B. Noctalia Desktop Shell
- **Ejecutable e IPC:** `/usr/bin/noctalia` y llamadas de control `noctalia msg <comando>`.
- **Configuración estática:** `~/.config/noctalia/config.toml` (e.g. agente polkit, opciones de inicio).
- **Configuración de interfaz, temas y estado en vivo:** `~/.local/state/noctalia/settings.toml`.
  - Contiene: paleta/tema activo, wallpaper actual, configuración de widgets (`[bar.default]`, `[dock]`), y lista de plugins habilitados (`[plugins]`).
- **Plugins y extensiones:** `~/.local/state/noctalia/plugins/` y fuentes oficiales/comunitarias.

### C. Integración de Sistema y Portales
- **Portales XDG:** `xdg-desktop-portal` con backend configurado en `/usr/share/xdg-desktop-portal/niri-portals.conf` (GNOME/GTK).
- **Audio y multimedia:** PipeWire / WirePlumber gestionados por Noctalia y atajos multimedia.

---

## 3. Comandos de Validación y Diagnóstico (Solo Lectura)

Utiliza siempre estos comandos nativos para diagnosticar sin alterar el sistema:

### Validación de sintaxis
* **Validar configuración de Niri (KDL):**
  ```bash
  niri validate --config ~/.config/niri/config.kdl
  ```
* **Validar configuración de Noctalia (TOML):**
  ```bash
  noctalia config validate
  ```

### Diagnóstico en tiempo real de Niri
* **Ver pantallas conectadas, modos y escalado activo:**
  ```bash
  niri msg outputs
  ```
* **Inspeccionar ventanas abiertas y sus propiedades (app-id, título):**
  ```bash
  niri msg windows
  ```
* **Ver workspaces activos:**
  ```bash
  niri msg workspaces
  ```
* **Inspeccionar superficies de capas (barras, paneles, wallpapers de Noctalia):**
  ```bash
  niri msg layers
  ```
* **Verificar versión exacta en ejecución:**
  ```bash
  niri msg version
  ```

### Diagnóstico de Noctalia Shell
* **Estado general de la shell (visibilidad de barra, paneles abiertos, bloqueo):**
  ```bash
  noctalia msg status
  ```
* **Listar plugins instalados y su estado (enabled/disabled):**
  ```bash
  noctalia msg plugins list
  ```
* **Listar fuentes de plugins configuradas:**
  ```bash
  noctalia msg plugins source list
  ```
* **Verificar wallpaper efectivo:**
  ```bash
  noctalia msg wallpaper-get
  ```

### Diagnóstico de servicios y entorno
* **Estado de la sesión Niri en systemd:**
  ```bash
  systemctl --user status niri.service --no-pager
  ```
* **Verificar portales Wayland en ejecución:**
  ```bash
  systemctl --user list-units --type=service | grep -E "portal|niri"
  ```
* **Verificar variables de entorno Wayland en el proceso actual:**
  ```bash
  env | grep -E "WAYLAND_DISPLAY|XDG_CURRENT_DESKTOP|XDG_SESSION_TYPE"
  ```

---

## 4. Flujo de Trabajo para Diagnósticos y Modificaciones

### Fase 1: Recolección y Verificación
1. Identifica qué componente está involucrado (atajo, monitor, regla de ventana, widget, etc.).
2. Comprueba las versiones y rutas actuales con los comandos de la Sección 3.
3. Ejecuta la validación sintáctica (`niri validate` o `noctalia config validate`) para descartar errores previos.
4. Lee el archivo específico involucrado (por ejemplo, `~/.config/niri/cfg/keybinds.kdl`).

### Fase 2: Explicación y Propuesta
1. Explica al usuario la causa raíz del comportamiento observado o qué línea debe modificarse.
2. Si se trata de un nuevo atajo o programa, comprueba antes si el binario existe en el sistema (`which <programa>`).
3. Muestra el comando de respaldo para el archivo objetivo:
   ```bash
   cp ~/.config/niri/cfg/<archivo>.kdl ~/.config/niri/cfg/<archivo>.kdl.bak.$(date +%Y%m%d_%H%M%S)
   ```
4. Muestra la edición exacta propuesta y solicita la aprobación del usuario antes de tocar el archivo.

### Fase 3: Aplicación Segura (Tras Autorización)
1. Aplica la modificación únicamente en el archivo correspondiente.
2. Ejecuta inmediatamente la validación sintáctica (`niri validate` o `noctalia config validate`) para garantizar que la nueva configuración no contenga errores.
3. Informa al usuario del resultado y déjale a él la decisión de recargar la configuración cuando esté listo:
   - Para Niri: `niri msg action load-config-file` (o el atajo configurado).
   - Para Noctalia: `noctalia config <...>` o recarga automática del daemon.
