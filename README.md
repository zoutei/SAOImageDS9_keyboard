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

## Command Line Usage (macOS Aqua)

Although the macOS Aqua port is a native GUI application, this custom version supports direct command-line execution (including via symbolic links in your `$PATH`):

1. **Create a Symbolic Link**:
   Create a symlink to easily call the Aqua version of DS9 from any terminal session:
   ```bash
   ln -s /Applications/SAOImageDS9.app/Contents/MacOS/ds9 /usr/local/bin/ds9
   ```

2. **Control Range, Scale, and Regions**:
   You can open images, adjust the scale range, and load region files directly from the command line:
   ```bash
   # Open a FITS file, set scale limits from 80 to 300, and load a region file
   ds9 /path/to/image.fits -scalelimits 80 300 -regions /path/to/targets.reg
   ```

### Launching DS9 via macOS `open`

You can launch the first instance of the application using the native macOS `open` command (which launches the bundle as a standard GUI application):
```bash
open -a SAOImageDS9
```
Or to start the program and immediately open a FITS file:
```bash
open -a SAOImageDS9 /path/to/image.fits
```

### Controlling an Already Running Instance (XPA)

To load files into an **already running** instance of DS9 (without launching a new process), use the XPA (X Public Access) utilities (`xpaset` and `xpaget`) compiled in the source directory:

1. **Create Symbolic Links**:
   ```bash
   ln -s /Users/kshukawa/Documents/SAOImageDS9/bin/xpaset /usr/local/bin/xpaset
   ln -s /Users/kshukawa/Documents/SAOImageDS9/bin/xpaget /usr/local/bin/xpaget
   ```

2. **Send Commands using Unix Domain Sockets (`local` method)**:
   To bypass potential macOS hostname lookup and firewall port blockages, prefix the commands with `XPA_METHOD=local`:
   ```bash
   # 1. Create a new frame in the active DS9 instance
   XPA_METHOD=local xpaset -p ds9 frame new

   # 2. Load a FITS file
   XPA_METHOD=local xpaset -p ds9 file /path/to/image.fits

   # 3. Adjust scale range limits
   XPA_METHOD=local xpaset -p ds9 scale limits 80 300

   # 4. Load the region file
   XPA_METHOD=local xpaset -p ds9 regions file /path/to/targets.reg
   ```

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
