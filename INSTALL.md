# Compiling and Installing SAOImageDS9 on macOS

This guide explains how to compile the custom build of SAOImageDS9, install it into the `/Applications` folder, and configure the necessary library search paths (`rpath`) so it runs standalone.

## Prerequisites
- **Xcode Command Line Tools**
- **Miniforge/Conda Environment** (specifically for dependency libraries like `libxml2`)

---

## Step 1: Compile the Application
Ensure the workspace is clean and run the build command:

```bash
# Clean previous builds (optional)
make clean

# Compile and package the application
make
```
This compiles the executable and packages the Tcl/Tk scripts and frameworks into a local bundle at `bin/SAOImageDS9.app`.

---

## Step 2: Install to the Applications Folder
Copy the local application bundle to your system's global `/Applications` folder:

```bash
# Remove any older version first
rm -rf /Applications/SAOImageDS9.app

# Copy the new bundle
cp -R bin/SAOImageDS9.app /Applications/
```

---

## Step 3: Link Miniforge Library Path
The compilation links against dependencies like `libxml2.2.dylib` via `@rpath`. If launched outside the terminal, macOS won't find this library unless you explicitly add the search path to the binary's internal configuration:

```bash
# Add the miniforge library search path to the binary's rpaths
install_name_tool -add_rpath /Users/kshukawa/miniforge3/lib /Applications/SAOImageDS9.app/Contents/MacOS/ds9
```

---

## Step 4: Verify the Installation
Verify that the installed application runs successfully without requiring environment variables:

```bash
/Applications/SAOImageDS9.app/Contents/MacOS/ds9 -version
```
It should successfully print the version details (e.g., `ds9 8.7 Koji`).
