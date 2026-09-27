#!/usr/bin/env bash
# ==============================================================================
# Script de instalación del Combo Antigravity (AGY) para Noctalia + Niri
# Incluye:
#  1. Widget de Noctalia Bar
#  2. Regla de ventana flotante para Niri
#  3. Lanzador .desktop para Noctalia Launcher y Dock
#  4. Skill de Antigravity (cachyos-niri-noctalia) para que AGY comprenda el entorno
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.config/noctalia/plugins/local/agy"
LOCAL_SOURCE_DIR="$HOME/.config/noctalia/plugins/local"

echo "=============================================================================="
echo "🚀 Instalando Combo Antigravity (AGY) para Noctalia + Niri en CachyOS..."
echo "=============================================================================="

# 1. Comprobación de dependencias básicas
if ! command -v noctalia >/dev/null 2>&1; then
    echo "⚠️  ADVERTENCIA: 'noctalia' no está en el PATH. Asegúrate de tener Noctalia instalado."
fi

if ! command -v alacritty >/dev/null 2>&1; then
    echo "⚠️  ADVERTENCIA: 'alacritty' no está instalado. El widget usa Alacritty como terminal predeterminado."
fi

if ! command -v agy >/dev/null 2>&1 && [ ! -x "$HOME/.local/bin/agy" ]; then
    echo "ℹ️  Nota: 'agy' aún no está instalado o no se encuentra en PATH (~/.local/bin/agy)."
fi

# 2. Copiar archivos del plugin de Noctalia
echo "==> [1/4] Copiando archivos del plugin a: $TARGET_DIR"
mkdir -p "$TARGET_DIR"
cp -r "$SCRIPT_DIR/plugin/"* "$TARGET_DIR/"

# 3. Registrar la fuente local y habilitar el plugin en Noctalia
if command -v noctalia >/dev/null 2>&1; then
    echo "==> [2/4] Registrando fuente local en Noctalia y habilitando plugin..."
    noctalia msg plugins source add local path "$LOCAL_SOURCE_DIR" 2>/dev/null || true
    noctalia msg plugins enable local/agy || true
fi

# 4. Instalar acceso directo de escritorio .desktop
DESKTOP_DIR="$HOME/.local/share/applications"
if [ -d "$SCRIPT_DIR/desktop" ]; then
    echo "==> [3/4] Instalando lanzador de escritorio en $DESKTOP_DIR..."
    mkdir -p "$DESKTOP_DIR"
    cp "$SCRIPT_DIR/desktop/agy.desktop" "$DESKTOP_DIR/"
    if command -v update-desktop-database >/dev/null 2>&1; then
        update-desktop-database "$DESKTOP_DIR" >/dev/null 2>&1 || true
    fi
fi

# 5. Configurar regla de ventana flotante en Niri (si existe la configuración)
NIRI_RULES="$HOME/.config/niri/cfg/rules.kdl"
if [ -f "$NIRI_RULES" ]; then
    if ! grep -q 'app-id="agy-terminal"' "$NIRI_RULES"; then
        echo "==> [4/4] Añadiendo regla de ventana flotante en $NIRI_RULES..."
        cp "$NIRI_RULES" "$NIRI_RULES.bak.$(date +%Y%m%d_%H%M%S)"
        cat >> "$NIRI_RULES" << 'EOF'

// Ventana flotante estilo HUD para el CLI de AGY
window-rule {
    match app-id="agy-terminal"
    open-floating true
    default-column-width { fixed 1100; }
    default-window-height { fixed 720; }
}
EOF
        echo "    Regla añadida (respaldo creado en $NIRI_RULES.bak.*)."
        if command -v niri >/dev/null 2>&1; then
            niri validate --config "$HOME/.config/niri/config.kdl" >/dev/null 2>&1 && echo "    Configuración de Niri validada con éxito."
        fi
    else
        echo "==> [4/4] La regla para 'agy-terminal' ya existe en Niri."
    fi
fi

# 6. Instalar Skill de Antigravity (cachyos-niri-noctalia)
SKILL_SRC="$SCRIPT_DIR/skills/cachyos-niri-noctalia"
if [ -d "$SKILL_SRC" ]; then
    # Ubicación global de discovery de skills de AGY: ~/.gemini/config/skills/
    GLOBAL_SKILLS_DIR="$HOME/.gemini/config/skills/cachyos-niri-noctalia"
    echo "==> [+] Instalando Skill de Antigravity en $GLOBAL_SKILLS_DIR..."
    mkdir -p "$GLOBAL_SKILLS_DIR"
    cp -r "$SKILL_SRC/"* "$GLOBAL_SKILLS_DIR/"
    echo "    ✅ Skill 'cachyos-niri-noctalia' instalada globalmente para agy."
fi

echo ""
echo "=============================================================================="
echo "🎉 ¡Instalación del Combo completada con éxito!"
echo ""
echo "Acciones para empezar a usarlo:"
echo "1. Mostrar el botón en la barra:"
echo "   - Abre Ajustes de Noctalia (Mod+Shift+S) -> 'Bar' -> 'Widgets'."
echo "   - Arrastra 'Antigravity AGY' a tu barra (centro o derecha)."
echo "   (O edita ~/.local/state/noctalia/settings.toml añadiendo 'agy' a [bar.default])."
echo ""
echo "2. Aplicar la regla de ventana en Niri ahora mismo:"
echo "   niri msg action load-config-file"
echo ""
echo "3. Usar el asistente especializado con AGY:"
echo "   - Haz clic en el botón de la barra para abrir AGY."
echo "   - Escribe en AGY: /cachyos-niri-noctalia para que diagnostique o configure tu entorno."
echo "=============================================================================="
