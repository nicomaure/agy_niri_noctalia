--!nonstrict
-- Bar widget entry for Antigravity AGY launcher

local function sanitize(str: string): string
  return string.gsub(str, "[\"`\$\\]", "")
end

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
  local rawDir = noctalia.getConfig("project_dir") or "~/Proyectos/agy"
  local cleanDir = sanitize(rawDir)
  noctalia.runAsync(`alacritty --class agy-terminal -T "Antigravity AGY" -e agy-hud "{cleanDir}"`)
end

function onRightClick()
  noctalia.runAsync('alacritty --class agy-terminal -T "Antigravity AGY" -e agy-hud home')
end

render()
