--!nonstrict
-- Bar widget entry for Antigravity AGY launcher

local function render()
  local showLabel = noctalia.getConfig("show_label") ~= false
  barWidget.setGlyph("sparkles")
  if showLabel and not barWidget.isVertical() then
    barWidget.setText("AGY")
  else
    barWidget.setText("")
  end
  barWidget.setTooltip(noctalia.tr("bar.tooltip"))
end

function update()
  render()
end

function onClick()
  noctalia.runAsync("alacritty --class agy-terminal -T 'Antigravity AGY' -e sh -c 'if [ -d \"$HOME/Proyectos/agy\" ]; then cd \"$HOME/Proyectos/agy\"; fi; if command -v agy >/dev/null 2>&1; then agy; elif [ -x \"$HOME/.local/bin/agy\" ]; then \"$HOME/.local/bin/agy\"; else echo \"Error: agy CLI not found in PATH nor ~/.local/bin/agy\"; read -p \"Press Enter to close...\"; fi'")
end

function onRightClick()
  noctalia.runAsync("alacritty --class agy-terminal -T 'Antigravity AGY' -e sh -c 'cd \"$HOME\"; if command -v agy >/dev/null 2>&1; then agy; elif [ -x \"$HOME/.local/bin/agy\" ]; then \"$HOME/.local/bin/agy\"; else echo \"Error: agy CLI not found in PATH nor ~/.local/bin/agy\"; read -p \"Press Enter to close...\"; fi'")
end

render()
