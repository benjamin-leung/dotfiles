# Nushell Configuration

This directory contains my Nushell configuration files.

## Setup

The Nushell configuration files are stored in `~/.config/nushell/` and symlinked from the default Nushell location:

```bash
~/Library/Application Support/nushell -> ~/.config/nushell
```

This setup allows the configuration to be:
- Managed alongside other dotfiles in `~/.config/`
- Version controlled as part of this dotfiles repository
- Compatible with Nushell's default configuration location on macOS

## Files

- `config.nu` - Main Nushell configuration
- `env.nu` - Environment variables and startup configuration
- `tmux-sessionizer.nu` - Custom tmux session management script
- `vendor/` - Third-party scripts and extensions

## Installation

1. Copy the files to `~/.config/nushell/`:
   ```bash
   cp -r nushell/* ~/.config/nushell/
   ```

2. Create the symlink (if not already present):
   ```bash
   sudo ln -s ~/.config/nushell ~/Library/Application\ Support/nushell
   ```