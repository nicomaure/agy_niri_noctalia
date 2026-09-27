#!/usr/bin/env bash
# ==============================================================================
# Script de desinstalación de Antigravity (AGY) Combo para Noctalia + Niri
# ==============================================================================

set -e

echo "==> Desinstalando Antigravity (AGY) Combo de Noctalia..."

# 1. Deshabilitar en Noctalia
if command -v noctalia >/dev/null 2>&1; then
    echo "==> Deshabilitando plugin nicomaure/agy en Noctalia..."
    noctalia msg plugins disable nicomaure/agy 2>/dev/null || noctalia msg plugins disable local/agy 2>/dev/null || true
fi

# 2. Eliminar archivos del plugin
TARGET_DIR="$HOME/.config/noctalia/plugins/local/agy"
if [ -d "$TARGET_DIR" ]; then
    echo "==> Eliminando carpeta del plugin: $TARGET_DIR..."
    rm -rf "$TARGET_DIR"
fi

# 3. Eliminar lanzador .desktop
DESKTOP_FILE="$HOME/.local/share/applications/agy.desktop"
if [ -f "$DESKTOP_FILE" ]; then
    echo "==> Eliminando lanzador de escritorio: $DESKTOP_FILE..."
    rm -f "$DESKTOP_FILE"
    if command -v update-desktop-database >/dev/null 2>&1; then
        update-desktop-database "$HOME/.local/share/applications" >/dev/null 2>&1 || true
    fi
fi

# 4. Eliminar skill global de Antigravity
SKILL_DIR="$HOME/.gemini/config/skills/cachyos-niri-noctalia"
if [ -d "$SKILL_DIR" ]; then
    echo "==> Eliminando skill de Antigravity: $SKILL_DIR..."
    rm -rf "$SKILL_DIR"
fi

echo ""
echo "=============================================================================="
echo "✅ Desinstalación de archivos completada."
echo ""
echo "Nota: Si agregaste el widget a tu barra, puedes retirarlo desde:"
echo "  Ajustes de Noctalia (Mod+Shift+S) -> Bar -> Widgets."
echo "=============================================================================="
