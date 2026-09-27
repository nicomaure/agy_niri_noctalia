# 🚀 Combo Antigravity (AGY) para Noctalia Bar & Niri Compositor

Suite integral y portátil para **CachyOS / Arch Linux** que integra el agente CLI **Antigravity (`agy`)** en el entorno de escritorio **Niri (Wayland)** y la shell **Noctalia**, equipando al agente con una **Skill especializada** para comprender, diagnosticar y configurar el sistema.

---

## 🧩 ¿Qué incluye este Combo?

El paquete reúne cuatro piezas que funcionan en perfecta armonía:

1. **Widget para la Barra de Noctalia (`bar.luau`):**
   - Un botón nativo (✨ `AGY`) con icono personalizable y tooltip interactivo.
   - **Clic izquierdo:** Abre `agy` en tu proyecto (`~/Proyectos/agy` si existe, o en la carpeta actual).
   - **Clic derecho:** Abre `agy` directamente en tu carpeta de usuario (`$HOME`).
   - Cero consumo de CPU en reposo (corre dentro del motor Luau de Noctalia).

2. **Regla de Ventana Flotante para Niri (`rules.kdl`):**
   - Hace que la terminal de `agy` se abra en el centro de la pantalla (`1100x720`) como un **HUD / scratchpad flotante**, con esquinas redondeadas, sin romper el mosaico continuo de tus ventanas.

3. **Skill Especializada para Antigravity (`cachyos-niri-noctalia`):**
   - Se instala en el sistema de descubrimiento global de AGY (`~/.gemini/config/skills/`).
   - Le enseña a tu agente `agy` la arquitectura de CachyOS, los comandos de Niri (`niri msg ...`, `niri validate`), la configuración de Noctalia (IPC y TOML) y las reglas de seguridad antes de modificar archivos.
   - Se invoca dentro de `agy` escribiendo:
     ```text
     /cachyos-niri-noctalia
     ```

4. **Lanzador de Escritorio (`agy.desktop`):**
   - Permite buscar **Antigravity CLI** en el lanzador de Noctalia (<kbd>Mod</kbd>+<kbd>Ctrl</kbd>+<kbd>Enter</kbd>) y anclarlo directamente al Dock.

---

## 📋 Requisitos Previos

- **Noctalia Desktop Shell** (`noctalia`)
- **Niri Compositor** (`niri`)
- **Alacritty** (`alacritty`) como emulador de terminal predeterminado
- **Antigravity CLI** (`agy`) instalado (en `$PATH` o en `~/.local/bin/agy`)

---

## ⚡ Instalación en 1 Comando (Recomendada)

Clona o descomprime esta carpeta en cualquier equipo y ejecuta el instalador:

```bash
chmod +x install.sh
./install.sh
```

El script se encarga de:
1. Copiar y habilitar el plugin local en Noctalia (`~/.config/noctalia/plugins/local/agy`).
2. Instalar el lanzador de escritorio en `~/.local/share/applications/agy.desktop`.
3. Añadir la regla flotante a tu archivo `~/.config/niri/cfg/rules.kdl` (creando un backup previo).
4. Instalar la Skill `cachyos-niri-noctalia` en `~/.gemini/config/skills/` para que `agy` la use en cualquier proyecto.

### 📌 Añadir el botón a la barra:
1. Presiona <kbd>Mod</kbd>+<kbd>Shift</kbd>+<kbd>S</kbd> para abrir los Ajustes de Noctalia.
2. Ve a **Bar** $\to$ **Widgets**.
3. Arrastra **Antigravity AGY** al centro o al bloque derecho de tu barra.

### 🔄 Aplicar la regla de ventana en Niri:
```bash
niri msg action load-config-file
```

---

## 🛠️ Instalación Manual Paso a Paso

Si prefieres realizar la configuración manualmente o incorporarla a tus *dotfiles*:

### 1. Plugin de Noctalia
```bash
mkdir -p ~/.config/noctalia/plugins/local/agy
cp plugin/* ~/.config/noctalia/plugins/local/agy/

# Registrar fuente local y habilitar
noctalia msg plugins source add local path ~/.config/noctalia/plugins/local
noctalia msg plugins enable local/agy
```

### 2. Regla de Niri
Añade a `~/.config/niri/cfg/rules.kdl` (o `config.kdl`):
```kdl
// Ventana flotante estilo HUD para el CLI de AGY
window-rule {
    match app-id="agy-terminal"
    open-floating true
    default-column-width { fixed 1100; }
    default-window-height { fixed 720; }
}
```
Y recarga: `niri msg action load-config-file`.

### 3. Skill de Antigravity
```bash
mkdir -p ~/.gemini/config/skills/cachyos-niri-noctalia
cp -r skills/cachyos-niri-noctalia/* ~/.gemini/config/skills/cachyos-niri-noctalia/
```

### 4. Lanzador de Escritorio
```bash
mkdir -p ~/.local/share/applications
cp desktop/agy.desktop ~/.local/share/applications/
update-desktop-database ~/.local/share/applications/
```

---

## 🎯 Cómo Usar el Asistente

1. **Haz clic en el icono ✨ AGY** de tu barra de Noctalia (o presiona su atajo).
2. Se abrirá la ventana flotante de `agy`.
3. Escribe cualquier consulta sobre tu entorno, o invoca la skill directamente:
   ```text
   /cachyos-niri-noctalia
   ```
4. Ejemplos de uso con la skill:
   - *"¿Por qué mi monitor externo no escala bien?"*
   - *"Agrégale un atajo a Niri para abrir Zed"*
   - *"Configura un widget de volumen en la barra de Noctalia"*
   - *"Revisa si mis archivos de configuración tienen errores de sintaxis"*

El agente utilizará los comandos seguros de solo lectura (`niri msg ...`, `niri validate`, `noctalia config validate`) y te mostrará copias de seguridad antes de cualquier modificación.

---

## 🎨 Personalización

### Cambiar de terminal (Kitty, Foot, etc.)
En `~/.config/noctalia/plugins/local/agy/bar.luau`:
- **Para Kitty:** Cambia la llamada a `kitty --class agy-terminal -T 'Antigravity AGY' agy`
- **Para Foot:** Cambia la llamada a `foot --app-id agy-terminal -T 'Antigravity AGY' agy`

### Cambiar el icono o etiqueta del widget
En `bar.luau`:
- Glifo: Puedes usar cualquier icono de Tabler Icons (`"robot"`, `"sparkles"`, `"terminal"`, `"brand-google"`, `"code"`).
- Texto: Modifica `barWidget.setText("AGY")` o déjalo vacío `""` si solo quieres el icono.

---

## 🗑️ Desinstalación

Para retirar el paquete completo de forma limpia:

```bash
chmod +x uninstall.sh
./uninstall.sh
```

Y retira el widget de tu barra desde los Ajustes de Noctalia (<kbd>Mod</kbd>+<kbd>Shift</kbd>+<kbd>S</kbd>) $\to$ **Bar** $\to$ **Widgets**.

---

## 👤 Autor

Creado y mantenido por **[nicomaure.com.ar](https://nicomaure.com.ar)**.

