# Kanata

This directory contains the kanata configuration for macOS, as well as a
launchctl configuration to enable this to run as a LaunchAgent or LaunchDaemon.

## Credits

The setup instructions below are based on:
- [Home Row Mods video by Dreams of Code](https://www.youtube.com/watch?v=sLWQ4Gx88h4)
- [Dreams of Code's home-row-mods repository](https://github.com/dreamsofcode-io/home-row-mods/blob/main/kanata/macos/README.md)

## Configuration

The `kanata.kbd` file contains the keyboard configuration with:
- Home row mods (s=cmd, d=alt, f=ctrl on left; j=ctrl, k=alt, l=cmd on right)
- Caps lock mapped to escape (tap) or hyper key (hold)
- Function layer accessible via fn key

## Setup Instructions

To set up kanata to run automatically on macOS:

### 1. Install Kanata

First, ensure kanata is installed. You can install it via cargo:

```bash
cargo install kanata
```

### 2. Configure Launch Service

The `com.example.kanata.plist` file is provided as a template. You'll need to modify it to match your system configuration.

Update the paths in the plist file:
- Path to kanata executable (default: `/Users/benjaminleung/.cargo/bin/kanata`)
- Path to config file (default: `/Users/benjaminleung/.config/kanata/kanata.kbd`)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.example.kanata</string>

    <key>ProgramArguments</key>
    <array>
        <string>{{ path to kanata }}</string>
        <string>-c</string>
        <string>{{ path to config }}</string>
    </array>

    <key>RunAtLoad</key>
    <true/>

    <key>KeepAlive</key>
    <true/>

    <key>StandardOutPath</key>
    <string>/Library/Logs/Kanata/kanata.out.log</string>

    <key>StandardErrorPath</key>
    <string>/Library/Logs/Kanata/kanata.err.log</string>
</dict>
</plist>
```

### 3. Install as LaunchDaemon

Copy the plist file to your LaunchDaemon folder:

```bash
sudo cp ./com.example.kanata.plist /Library/LaunchDaemons/
```

### 4. Load and Start the Service

Once copied over, load it using sudo:

```bash
sudo launchctl load /Library/LaunchDaemons/com.example.kanata.plist
sudo launchctl start com.example.kanata
```

### 5. Grant Input Monitoring Permission

You might have to specifically allow the executable `kanata` the permission for `input monitoring` (if you didn't get this GUI popup guiding you to do so already).

To do this:
1. Go to Settings > Privacy & Security > Input Monitoring
2. Click the `+` icon
3. Navigate to your kanata executable location (e.g., `~/.cargo/bin/kanata`)
4. Add it to the allowed list

Now, kanata should be running whenever your macOS starts up!

### Debugging

To help with debugging any potential issues, you can look in the error log:

```bash
sudo tail -f /Library/Logs/Kanata/kanata.err.log
```

### Multiple Keyboards

If you use multiple keyboards, you may want to limit this to only specific keyboards. You can use kanata's device filtering options in the configuration file to achieve this.

## Important: macOS Sequoia Setup Issues

If you're having trouble getting kanata to work on macOS Sequoia, the following solution from [this GitHub issue comment](https://github.com/jtroo/kanata/issues/1264#issuecomment-2763085239) may help:

### Solution for macOS Sequoia 15.3.2+

**DO NOT** install just the Karabiner VirtualHIDDevice Driver suggested by the kanata README. If you did, uninstall it:

```bash
sudo /Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager deactivate
```

Then reboot to be safe.

#### Required Steps:

1. **Install the full Karabiner Elements** (e.g., Karabiner-Elements-15.3.0.dmg)

2. **Carefully follow all prompts** within Karabiner to make changes in macOS System Settings:
   - Login Items & Extensions > Karabiner-Elements Non-Privileged Agents (enable)
   - Login Items & Extensions > Karabiner-Elements Privileged Daemons (enable)
   - Login Items & Extensions > Driver Extensions > .Karabiner-VirtualHIDDevice-Manager (enable)

3. **Grant Input Monitoring permissions** in Privacy & Security > Input Monitoring for:
   - iTerm
   - karabiner_grabber
   - Karabiner-Elements
   - Karabiner-EventViewer
   - Terminal
   - Your kanata executable

4. **IMPORTANT: Quit Karabiner completely**:
   - Quit the Karabiner-Elements app
   - Find and quit Karabiner running in the macOS menu bar (at the top of the screen)
   - If you don't do this, kanata will complain that something else is using the keyboard

5. **Reboot again**

6. **Now try running kanata**:
   ```bash
   sudo kanata --cfg your-config.kbd
   ```

Note: This solution has been confirmed to work with executables from `cargo install kanata` as well as the ones hosted on the kanata releases page.