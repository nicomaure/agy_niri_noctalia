#!/usr/bin/env bash
# ==============================================================================
# Installation Script: Antigravity (AGY) Combo for Noctalia + Niri
# Author: nicomaure.com.ar
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.config/noctalia/plugins/local/agy"
LOCAL_SOURCE_DIR="$HOME/.config/noctalia/plugins/local"

echo "=============================================================================="
echo "🚀 Installing Antigravity (AGY) Combo for Noctalia & Niri..."
echo "=============================================================================="

# 1. Dependency checks
if ! command -v noctalia >/dev/null 2>&1; then
    echo "⚠️  WARNING: 'noctalia' was not found on PATH. Ensure Noctalia is installed."
fi

if ! command -v alacritty >/dev/null 2>&1; then
    echo "⚠️  WARNING: 'alacritty' was not found on PATH. The HUD terminal defaults to Alacritty."
fi

if ! command -v agy >/dev/null 2>&1 && [ ! -x "$HOME/.local/bin/agy" ]; then
    echo "ℹ️  Notice: 'agy' CLI was not found on PATH nor in ~/.local/bin/agy."
    echo "   Ensure you have Antigravity CLI installed to run the agent."
fi

# 2. Install agy-hud helper script
echo "==> [1/5] Installing launcher helper: ~/.local/bin/agy-hud"
mkdir -p "$HOME/.local/bin"
cp "$SCRIPT_DIR/bin/agy-hud" "$HOME/.local/bin/agy-hud"
chmod +x "$HOME/.local/bin/agy-hud"

# 3. Install Noctalia bar plugin
echo "==> [2/5] Installing Noctalia plugin: $TARGET_DIR"
mkdir -p "$TARGET_DIR"
cp -r "$SCRIPT_DIR/agy/"* "$TARGET_DIR/"

if command -v noctalia >/dev/null 2>&1; then
    echo "    Registering local source in Noctalia..."
    if ! noctalia msg plugins source add local path "$LOCAL_SOURCE_DIR" 2>/dev/null; then
        echo "    (Source 'local' already registered or updated)"
    fi
    echo "    Enabling plugin 'nicomaure/agy'..."
    noctalia msg plugins enable nicomaure/agy || echo "⚠️  Could not automatically enable plugin via IPC. You can enable it from Settings."
fi

# 4. Install Desktop Entry
DESKTOP_DIR="$HOME/.local/share/applications"
if [ -d "$SCRIPT_DIR/desktop" ]; then
    echo "==> [3/5] Installing desktop launcher: $DESKTOP_DIR/agy.desktop"
    mkdir -p "$DESKTOP_DIR"
    cp "$SCRIPT_DIR/desktop/agy.desktop" "$DESKTOP_DIR/"
    if command -v update-desktop-database >/dev/null 2>&1; then
        update-desktop-database "$DESKTOP_DIR" >/dev/null 2>&1 || true
    fi
fi

# 5. Configure Niri floating HUD rule
echo "==> [4/5] Checking Niri configuration for floating HUD rule..."
NIRI_TARGET=""
if [ -f "$HOME/.config/niri/cfg/rules.kdl" ]; then
    NIRI_TARGET="$HOME/.config/niri/cfg/rules.kdl"
elif [ -f "$HOME/.config/niri/config.kdl" ]; then
    NIRI_TARGET="$HOME/.config/niri/config.kdl"
fi

if [ -n "$NIRI_TARGET" ]; then
    if grep -q "BEGIN AGY_NIRI_NOCTALIA" "$NIRI_TARGET"; then
        echo "    Rule already present in $NIRI_TARGET."
    else
        echo "    Adding delimited floating rule to $NIRI_TARGET..."
        cp "$NIRI_TARGET" "$NIRI_TARGET.bak.$(date +%Y%m%d_%H%M%S)"
        cat >> "$NIRI_TARGET" << 'EOF'

// BEGIN AGY_NIRI_NOCTALIA
// Floating HUD window for AGY CLI
window-rule {
    match app-id="^agy-terminal$"
    open-floating true
    geometry-corner-radius 16
    clip-to-geometry true
    default-column-width { fixed 1100; }
    default-window-height { fixed 720; }
}
// END AGY_NIRI_NOCTALIA
EOF
        echo "    Rule added successfully (backup created at $NIRI_TARGET.bak.*)."
        if command -v niri >/dev/null 2>&1; then
            if niri validate --config "$HOME/.config/niri/config.kdl" >/dev/null 2>&1; then
                echo "    Niri configuration validated successfully."
            else
                echo "⚠️  Niri validation reported warnings/errors. Please review $NIRI_TARGET."
            fi
        fi
    fi
else
    echo "ℹ️  No Niri configuration file found at ~/.config/niri/cfg/rules.kdl or ~/.config/niri/config.kdl."
    echo "   If you use Niri, you can manually add the rule from niri/rules.kdl.example."
fi

# 6. Install Antigravity Skill
SKILL_SRC="$SCRIPT_DIR/skills/cachyos-niri-noctalia"
if [ -d "$SKILL_SRC" ]; then
    GLOBAL_SKILLS_DIR="$HOME/.gemini/config/skills/cachyos-niri-noctalia"
    echo "==> [5/5] Installing Antigravity Desktop Skill: $GLOBAL_SKILLS_DIR"
    mkdir -p "$GLOBAL_SKILLS_DIR"
    cp -r "$SKILL_SRC/"* "$GLOBAL_SKILLS_DIR/"
    echo "    Skill 'cachyos-niri-noctalia' installed."
fi

echo ""
echo "=============================================================================="
echo "🎉 Installation completed successfully!"
echo ""
echo "Next steps:"
echo "1. Show the widget in Noctalia Bar:"
echo "   - Open Noctalia Settings (Mod+Shift+S) -> 'Bar' -> 'Widgets'."
echo "   - Drag 'Antigravity AGY' to your bar (center or right)."
echo ""
echo "2. Reload Niri configuration (if running Niri):"
echo "   niri msg action load-config-file"
echo ""
echo "3. Try the desktop skill inside AGY:"
echo "   Click the AGY icon and type /cachyos-niri-noctalia"
echo "=============================================================================="
