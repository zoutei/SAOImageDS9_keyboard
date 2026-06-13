[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1041781.svg)](https://doi.org/10.5281/zenodo.1041781)

![alt-text](http://ds9.si.edu/doc/sun.gif "SAOImageDS9")
# SAOImageDS9

SAOImageDS9 is an astronomical imaging and data visualization application (see the [official repository](https://github.com/SAOImageDS9/SAOImageDS9) and the [official website](https://ds9.si.edu/)). This repository is a customized version that supports configurable keyboard shortcuts.

## Downloads

You can download the compiled binaries from the [v8.7_keyboard Release Page](https://github.com/zoutei/SAOImageDS9_keyboard/releases/tag/v8.7_keyboard).

- **macOS (Apple Silicon)**: [Download SAOImageDS9.8.7.dmg](https://github.com/zoutei/SAOImageDS9_keyboard/releases/download/v8.7_keyboard/SAOImageDS9.8.7.dmg).
  - Built specifically for Apple Silicon and compiled on the latest macOS.
  - This is a native **Aqua application** (using the macOS native GUI) and does not require XQuartz (unlike the Darwin X11 version).
  - *Note:* If you encounter "unknown developer" or "damaged application" warnings after installation, run:
    ```bash
    xattr -c /Applications/SAOImageDS9.app
    ```
- **Linux**: Pre-compiled binaries are built for the latest Ubuntu version.
- **Other Platforms**: For other platforms, you will need to compile the application yourself from source using `make`.

## Custom Features: Keyboard Shortcuts & None Edit Mode Pan

This custom fork of SAOImageDS9 includes custom features designed to streamline data analysis workflows.

### 1. Customizable Keyboard Shortcuts
You can map keyboard sequences to predefined actions. Shortcuts support multi-key sequences (e.g., press `C` then `9` to set 90% scale).

#### Default Bindings
- `L` / `l`: Toggle scale and limits lock across all frames.
- `I` / `i`: Toggle frame lock by **Image** (pixel coordinates).
- `W` / `w`: Toggle frame lock by **WCS** (World Coordinate System).
- `C9` / `c9`: Set the scale limits mode to **90%**.
- `C1` / `c1`: Set the manual user limits range from **-10 to 10**.
- `C5` / `c5`: Set the manual user limits range from **-5 to 5**.
- `C2` / `c2`: Set the manual user limits range from **-20 to 20**.
- `D` / `d`: Delete the current active frame.
- `B` / `b`: Switch display to **Blink** mode.
- `S` / `s`: Switch display to **Single** mode.
- `T` / `t`: Switch display to **Tile** mode.
- `P` / `p`: Switch interaction mode to **Pan**.
- `r` (lowercase): Switch interaction mode to **Region** (Pointer).
- `R` (uppercase): Open a region file (`MarkerLoad`).
- `N` / `n`: Switch interaction mode to **None**.

#### Case Sensitivity
Shortcut key sequences are matched case-sensitively first.
- If you define actions for both lowercase and uppercase versions of a key (e.g., `r` and `R`), they will execute separate actions.
- If a shortcut is defined for only one case (e.g., lowercase `l`), the matching logic falls back to case-insensitive matching if the other case is pressed (so pressing `L` will trigger the shortcut mapped to `l`).
- Action names (e.g., `lock_scale_limits`, `scale`, etc.) are case-sensitive.

#### How to Configure Custom Shortcuts
You can customize these shortcut mappings by modifying or creating a configuration file named `shortcuts.cfg`.
DS9 searches for this configuration file in the following order:
1. The path specified by the environment variable `DS9_SHORTCUTS_CFG`.
2. `$HOME/.ds9/shortcuts.cfg`
3. `$HOME/.ds9.shortcuts`
4. `shortcuts.cfg` in the current working directory.

**Example `shortcuts.cfg` format:**
```ini
# Prefix timeout delay in milliseconds (default is 500)
timeout = 500

# Bind keys to actions
L = lock_scale_limits
I = lock_frame image
W = lock_frame wcs
C9 = scale 90
C1 = range -10 10
r = mode region
R = MarkerLoad
```


### 2. None Edit Mode Drag-to-Pan
When in `None` interaction mode (configured via the `Edit` menu or shortcut `N`), you can now click and drag with the left mouse button to pan the image directly without switching tools.
- To enable or disable this feature, open **Preferences** -> **Pan/Zoom** -> **None Edit Mode** and toggle **Drag to Pan**.

## About SAOImageDS9

SAOImageDS9 is an astronomical imaging and data visualization application. DS9 supports FITS images and binary tables, multiple frame buffers, region manipulation, and many scale algorithms and colormaps. It provides for easy communication with external analysis tasks and is highly configurable and extensible via XPA and SAMP.

DS9 is a stand-alone application. It requires no installation or support files. All versions and platforms support a consistent set of GUI and functional capabilities.

DS9 supports advanced features such as 2-D, 3-D and RGB frame buffers, mosaic images, tiling, blinking, geometric markers, colormap manipulation, scaling, arbitrary zoom, cropping, rotation, pan, and a variety of coordinate systems.

The GUI for DS9 is user configurable. GUI elements such as the coordinate display, panner, magnifier, horizontal and vertical graphs, button bar, and color bar can be configured via menus or the command line.

SAOImageDS9 is fully funded by the Chandra X-ray Science Center (CXC) and is licensed in part under the GNU General Public License, version 3.
