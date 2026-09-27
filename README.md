# Antigravity AGY for Noctalia Bar & Niri

A native bar launcher and floating HUD integration for the **[Antigravity CLI](https://github.com/) (`agy`)** AI agent on **[Noctalia Desktop Shell](https://noctalia.dev)** and the **[Niri Wayland Compositor](https://github.com/YaLTeR/niri)**.

Includes a dedicated bar widget, floating window rules, desktop launcher, and an integrated Antigravity Skill (`cachyos-niri-noctalia`) that teaches your agent how to diagnose, configure, and operate your desktop environment safely.

---

## Plugin

| Field | Value |
| --- | --- |
| ID | `nicomaure/agy` |
| Entries | Bar widget: `bar` |

---

## Features

- **One-Click Agent Access:** Clean ✨ **AGY** bar widget in Noctalia with customizable glyph and label.
- **Floating HUD Terminal:** Niri window rule ensures `agy` opens in a centered, floating window (`1100x720`) with rounded corners without disturbing your tiling layout.
- **Dual Launch Actions:**
  - **Left click:** Launches `agy` in your project workspace (`~/Proyectos/agy` if present, or current working directory).
  - **Right click:** Launches `agy` in your user home directory (`$HOME`).
- **Antigravity Desktop Skill:** Equips `agy` with the `/cachyos-niri-noctalia` skill to inspect display outputs, keybindings, window rules, and bar widgets with zero-risk read-only diagnostics.
- **Zero Resource Consumption:** Runs inside Noctalia's native Luau runtime. 0% CPU and negligible memory while idle; all terminal resources are freed immediately upon exit.
- **100% Portable:** Dynamically resolves `$HOME` and `$PATH` with no hardcoded usernames or fixed paths.

---

## Requirements

- **[Noctalia Desktop Shell](https://noctalia.dev)** (`noctalia`)
- **[Niri Wayland Compositor](https://github.com/YaLTeR/niri)** (`niri`)
- **Alacritty** terminal emulator (`alacritty`)
- **Antigravity CLI** (`agy`) installed on `PATH` or in `~/.local/bin/agy`

---

## Installation

### Automatic Install (Recommended)

Clone the repository and run the installer:

```bash
git clone https://github.com/nicomaure/agy_niri_noctalia.git
cd agy_niri_noctalia
chmod +x install.sh
./install.sh
```

The installer automatically:
1. Installs the plugin into `~/.config/noctalia/plugins/local/agy` and enables it.
2. Adds the floating HUD window rule to `~/.config/niri/cfg/rules.kdl` (with an automatic backup).
3. Installs the desktop launcher to `~/.local/share/applications/agy.desktop` (for Noctalia Launcher and Dock).
4. Installs the `cachyos-niri-noctalia` Skill to `~/.gemini/config/skills/` for system-wide agent discovery.

### Adding the Widget to your Bar

1. Open Noctalia Settings (<kbd>Mod</kbd>+<kbd>Shift</kbd>+<kbd>S</kbd>).
2. Navigate to **Bar** $\to$ **Widgets**.
3. Drag **Antigravity AGY** to your preferred position (center or end).

### Reloading Niri

Apply the new floating rule immediately:

```bash
niri msg action load-config-file
```

---

## Manual Installation

If you prefer configuring it manually or integrating it into your dotfiles:

### 1. Noctalia Plugin
```bash
mkdir -p ~/.config/noctalia/plugins/local/agy
cp -r agy/* ~/.config/noctalia/plugins/local/agy/

noctalia msg plugins source add local path ~/.config/noctalia/plugins/local
noctalia msg plugins enable nicomaure/agy
```

### 2. Niri Window Rule
Add to `~/.config/niri/cfg/rules.kdl`:

```kdl
// Floating HUD window for AGY CLI
window-rule {
    match app-id="agy-terminal"
    open-floating true
    default-column-width { fixed 1100; }
    default-window-height { fixed 720; }
}
```

### 3. Antigravity Skill
```bash
mkdir -p ~/.gemini/config/skills/cachyos-niri-noctalia
cp -r skills/cachyos-niri-noctalia/* ~/.gemini/config/skills/cachyos-niri-noctalia/
```

### 4. Desktop Entry
```bash
mkdir -p ~/.local/share/applications
cp desktop/agy.desktop ~/.local/share/applications/
update-desktop-database ~/.local/share/applications/
```

---

## Usage

- **Click the ✨ AGY widget** on your Noctalia Bar to spawn your agent HUD.
- **Inside the AGY terminal**, interact normally or invoke the desktop skill:
  ```text
  /cachyos-niri-noctalia
  ```
  Ask the agent to inspect displays, check shortcut conflicts, create window rules, or adjust Noctalia settings.

---

## Settings

| Setting | Type | Default | Description |
| --- | --- | --- | --- |
| `show_label` | `bool` | `true` | Show the AGY text label next to the icon in the bar. |

Settings can be toggled visually under Noctalia Settings (<kbd>Mod</kbd>+<kbd>Shift</kbd>+<kbd>S</kbd>) $\to$ **Plugins** $\to$ **Antigravity AGY**.

---

## Notes

- **Process Lifecycle:** The widget runs as a lightweight Luau bar entry with 0% CPU consumption while idle. It spawns Alacritty on demand.
- **Compositor Support:** Designed specifically for Niri Wayland Compositor, but compatible with any Wayland environment with Alacritty.
- **Privacy & Security:** Runs entirely locally with zero telemetry, zero background network calls, and no remote code execution.

---

## Uninstallation

To remove the integration cleanly:

```bash
chmod +x uninstall.sh
./uninstall.sh
```

Then remove the widget from your bar via Noctalia Settings (<kbd>Mod</kbd>+<kbd>Shift</kbd>+<kbd>S</kbd>) $\to$ **Bar** $\to$ **Widgets**.

---

## Author

Created and maintained by **[nicomaure.com.ar](https://nicomaure.com.ar)**.
