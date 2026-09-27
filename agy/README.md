# Antigravity AGY

Quick bar launcher for the Antigravity Agent CLI (`agy`) with dedicated floating HUD terminal support in Niri.

## Plugin

| Field | Value |
| --- | --- |
| ID | `nicomaure/agy` |
| Entries | Bar widget: `bar` |

## Requirements

- `alacritty` available on `PATH`.
- `agy` (Antigravity CLI) available on `PATH`.

If either is missing, the widget shows an error notification instead of launching.

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

Add the **Antigravity AGY** widget to your Noctalia Bar under **Settings** (Mod+Shift+S) -> **Bar** -> **Widgets**.

- **Left click:** Launches `agy` in your project folder (`~/Proyectos/agy` if available) inside a floating Alacritty terminal.
- **Right click:** Launches `agy` in your user home directory (`$HOME`).

## Settings

| Setting | Type | Default | Description |
| --- | --- | --- | --- |
| `show_label` | `bool` | `true` | Show the AGY text label next to the icon in the bar. |
| `project_dir` | `string` | `~/Proyectos/agy` | Default workspace directory opened on left click. |

## Notes

- **Process Lifecycle:** The widget runs as a lightweight Luau bar entry with 0% CPU consumption while idle. It only spawns Alacritty upon interaction. When the terminal window is closed, all resources are completely freed.
- **Spawned Processes:** On click it launches `alacritty` (argv-exec, no shell) running `agy`. No network calls, no filesystem writes.
- **Compositor Support:** Designed for Niri Wayland Compositor, but functions on any Wayland compositor with Alacritty installed.
- **Privacy & Security:** Runs entirely locally without network telemetry or remote code execution.
- **Full Desktop Integration:** This plugin pairs with the `cachyos-niri-noctalia` agent skill — it teaches `agy` how to diagnose and configure your Niri + Noctalia desktop safely (read-only diagnostics, backup-before-edit rules). Get it plus the automated Niri window rule and desktop launcher from the companion repository: [nicomaure/agy_niri_noctalia](https://github.com/nicomaure/agy_niri_noctalia).
