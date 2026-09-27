#!/usr/bin/env bash
# ==============================================================================
# Uninstallation Script: Antigravity (AGY) Combo for Noctalia + Niri
# Author: nicomaure.com.ar
# ==============================================================================

set -e

echo "=============================================================================="
echo "🧹 Uninstalling Antigravity (AGY) Combo..."
echo "=============================================================================="

# 1. Disable in Noctalia
if command -v noctalia >/dev/null 2>&1; then
    echo "==> [1/6] Disabling plugin in Noctalia..."
    noctalia msg plugins disable nicomaure/agy 2>/dev/null || noctalia msg plugins disable local/agy 2>/dev/null || true
fi

# 2. Remove Noctalia plugin files
TARGET_DIR="$HOME/.config/noctalia/plugins/local/agy"
if [ -d "$TARGET_DIR" ]; then
    echo "==> [2/6] Removing plugin files: $TARGET_DIR..."
    rm -rf "$TARGET_DIR"
fi

# 3. Remove Desktop Entry
DESKTOP_FILE="$HOME/.local/share/applications/agy.desktop"
if [ -f "$DESKTOP_FILE" ]; then
    echo "==> [3/6] Removing desktop launcher: $DESKTOP_FILE..."
    rm -f "$DESKTOP_FILE"
    if command -v update-desktop-database >/dev/null 2>&1; then
        update-desktop-database "$HOME/.local/share/applications" >/dev/null 2>&1 || true
    fi
fi

# 4. Remove agy-hud helper binary
HELPER_BIN="$HOME/.local/bin/agy-hud"
if [ -f "$HELPER_BIN" ]; then
    echo "==> [4/6] Removing launcher helper: $HELPER_BIN..."
    rm -f "$HELPER_BIN"
fi

# 5. Remove Niri delimited rule cleanly
echo "==> [5/6] Checking and removing Niri delimited rule..."
remove_niri_rule() {
    local target="$1"
    if [ -f "$target" ] && grep -q "BEGIN AGY_NIRI_NOCTALIA" "$target"; then
        echo "    Removing rule from $target..."
        cp "$target" "$target.bak.$(date +%Y%m%d_%H%M%S)"
        if command -v python3 >/dev/null 2>&1; then
            python3 -c '
import re, sys
path = sys.argv[1]
with open(path, "r") as f:
    content = f.read()
new_content = re.sub(r"\n?\s*// BEGIN AGY_NIRI_NOCTALIA[\s\S]*?// END AGY_NIRI_NOCTALIA\n?", "\n", content)
with open(path, "w") as f:
    f.write(new_content)
' "$target"
        elif command -v sed >/dev/null 2>&1; then
            sed -i '/\/\/ BEGIN AGY_NIRI_NOCTALIA/,/\/\/ END AGY_NIRI_NOCTALIA/d' "$target"
        else
            echo "⚠️  Neither python3 nor sed found. Please remove delimited rule manually."
        fi
        echo "    Rule cleanly removed (backup saved at $target.bak.*)."
        if command -v niri >/dev/null 2>&1; then
            if [ -f "$HOME/.config/niri/config.kdl" ]; then
                niri validate --config "$HOME/.config/niri/config.kdl" >/dev/null 2>&1 || true
            elif [ -f "$target" ]; then
                niri validate --config "$target" >/dev/null 2>&1 || true
            fi
        fi
    fi
}

remove_niri_rule "$HOME/.config/niri/cfg/rules.kdl"
remove_niri_rule "$HOME/.config/niri/config.kdl"

# 6. Remove Antigravity Skill
SKILL_DIR="$HOME/.gemini/config/skills/cachyos-niri-noctalia"
if [ -d "$SKILL_DIR" ]; then
    echo "==> [6/6] Removing Antigravity skill: $SKILL_DIR..."
    rm -rf "$SKILL_DIR"
fi

echo ""
echo "=============================================================================="
echo "✅ Clean uninstallation completed."
echo "Note: If the widget was added to your Noctalia Bar, you can remove it in:"
echo "  Noctalia Settings (Mod+Shift+S) -> Bar -> Widgets."
echo "=============================================================================="
