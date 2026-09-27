--!nonstrict
-- Bar widget para lanzar Antigravity Agent CLI (agy) de forma portable

local function render()
  barWidget.setGlyph("sparkles")
  barWidget.setText("AGY")
  barWidget.setTooltip("Antigravity Agent CLI (Clic: abrir en proyecto | Clic derecho: abrir en home)")
end

function update()
  render()
end

function onClick()
  -- Intenta abrir en ~/Proyectos/agy si existe, o en el directorio actual
  noctalia.runAsync("alacritty --class agy-terminal -T 'Antigravity AGY' -e sh -c 'if [ -d \"$HOME/Proyectos/agy\" ]; then cd \"$HOME/Proyectos/agy\"; fi; if command -v agy >/dev/null 2>&1; then agy; elif [ -x \"$HOME/.local/bin/agy\" ]; then \"$HOME/.local/bin/agy\"; else echo \"Error: agy no encontrado en PATH ni en ~/.local/bin/agy\"; read -p \"Presiona Enter para cerrar...\"; fi'")
end

function onRightClick()
  -- Clic derecho: abrir directamente en el HOME del usuario
  noctalia.runAsync("alacritty --class agy-terminal -T 'Antigravity AGY' -e sh -c 'cd \"$HOME\"; if command -v agy >/dev/null 2>&1; then agy; elif [ -x \"$HOME/.local/bin/agy\" ]; then \"$HOME/.local/bin/agy\"; else echo \"Error: agy no encontrado en PATH ni en ~/.local/bin/agy\"; read -p \"Presiona Enter para cerrar...\"; fi'")
end

render()
