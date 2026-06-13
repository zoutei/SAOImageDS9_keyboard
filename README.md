 [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1041781.svg)](https://doi.org/10.5281/zenodo.1041781)

![alt-text](http://ds9.si.edu/doc/sun.gif "SAOImageDS9")
# SAOImageDS9

SAOImageDS9 is an astronomical imaging and data visualization application. DS9 supports FITS images and binary tables,  multiple frame buffers, region manipulation, and many scale algorithms and colormaps. It provides for easy communication with external analysis tasks and is highly configurable and extensible via XPA and SAMP.

DS9 is a stand-alone application. It requires no installation or support files. All versions and platforms support a consistent set of GUI and functional capabilities.

DS9 supports advanced features such as 2-D, 3-D and RGB frame buffers, mosaic images, tiling, blinking, geometric markers, colormap manipulation, scaling, arbitrary zoom, cropping, rotation, pan, and a variety of coordinate systems.

The GUI for DS9 is user configurable. GUI elements such as the coordinate display, panner, magnifier, horizontal and vertical graphs, button bar, and color bar can be configured via menus or the command line.

SAOImageDS9 is fully funded by the Chandra X-ray Science Center (CXC) and is licensed in part under the GNU General Public License, version 3.

## Downloads

You can download the compiled binaries from the [v8.7_keyboard Release Page](https://github.com/zoutei/SAOImageDS9_keyboard/releases/tag/v8.7_keyboard).

> [!NOTE]
> The macOS package is built as the Aqua version specifically for **Mac Apple Silicon**.

### IMPORTANT - READ ME
The installation for several versions may show warnings about "unknown developer" or "damaged application". If this is the case after the installation, run the following command at the prompt in a Terminal window:

**Aqua installation:**
```bash
xattr -c /Applications/SAOImageDS9.app
```

## Custom Features: Keyboard Shortcuts & None Edit Mode Pan

This custom fork of SAOImageDS9 includes custom features designed to streamline data analysis workflows.

### 1. Customizable Keyboard Shortcuts
You can map keyboard sequences to predefined actions. Shortcuts support multi-key sequences (e.g., press `C` then `9` to set 90% scale).

#### Default Bindings
- `L`: Toggle scale and limits lock across all frames.
- `I`: Toggle frame lock by **Image** (pixel coordinates).
- `W`: Toggle frame lock by **WCS** (World Coordinate System).
- `C9`: Set the scale limits mode to **90%**.
- `C1`: Set the manual user limits range from **-10 to 10**.
- `C5`: Set the manual user limits range from **-5 to 5**.
- `C2`: Set the manual user limits range from **-20 to 20**.
- `D`: Delete the current active frame.
- `B`: Switch display to **Blink** mode.
- `S`: Switch display to **Single** mode.
- `T`: Switch display to **Tile** mode.
- `P`: Switch interaction mode to **Pan**.
- `R`: Switch interaction mode to **Region** (Pointer).
- `N`: Switch interaction mode to **None**.

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
```

### 2. None Edit Mode Drag-to-Pan
When in `None` interaction mode (configured via the `Edit` menu or shortcut `N`), you can now click and drag with the left mouse button to pan the image directly without switching tools.
- To enable or disable this feature, open **Preferences** -> **Pan/Zoom** -> **None Edit Mode** and toggle **Drag to Pan**.
