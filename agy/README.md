# Antigravity AGY

Quick bar launcher for the Antigravity Agent CLI (`agy`) with dedicated floating HUD terminal support in Niri.

## Plugin

| Field | Value |
| --- | --- |
| ID | `nicomaure/agy` |
| Entries | Bar widget: `bar` |

## Requirements

Install `alacritty` on `PATH`.

Install the `agy` CLI on `PATH` (or `~/.local/bin/agy`).

For the floating HUD window on Niri, add the window rule in `~/.config/niri/cfg/rules.kdl`:

```kdl
// BEGIN AGY_NIRI_NOCTALIA
window-rule {
    match app-id="^agy-terminal$"
    open-floating true
    geometry-corner-radius 16
    clip-to-geometry true
    default-column-width { fixed 1100; }
    default-window-height { fixed 720; }
}
// END AGY_NIRI_NOCTALIA
```

## Usage

Add the **Antigravity AGY** widget to your Noctalia Bar under **Settings** (<kbd>Mod</kbd>+<kbd>Shift</kbd>+<kbd>S</kbd>) -> **Bar** -> **Widgets**.

- **Left click:** Launches `agy` in your project folder (`~/Proyectos/agy` if available) inside a floating Alacritty terminal.
- **Right click:** Launches `agy` in your user home directory (`$HOME`).

## Settings

| Setting | Type | Default | Description |
| --- | --- | --- | --- |
| `show_label` | `bool` | `true` | Show the AGY text label next to the icon in the bar. |
| `project_dir` | `string` | `~/Proyectos/agy` | Default workspace directory opened on left click. |

## Notes

- **Process Lifecycle:** The widget runs as a lightweight Luau bar entry with 0% CPU consumption while idle. It only spawns Alacritty upon interaction. When the terminal window is closed, all resources are completely freed.
- **Compositor Support:** Designed for Niri Wayland Compositor, but functions on any Wayland compositor with Alacritty installed.
- **Privacy & Security:** Runs entirely locally without network telemetry or remote code execution.
