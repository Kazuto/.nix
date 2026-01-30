# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

**Shiro** is a modular Nix-based configuration management system for macOS and Linux using the Snowfall Lib architecture. It manages system configurations declaratively through Nix Flakes while keeping tool-specific dotfiles separate (symlinked via GNU Stow).

## Build Commands

### macOS (Tsukuyomi)
```bash
# Rebuild system configuration
darwin-rebuild switch --flake ./#tsukuyomi

# First-time setup only
nix run nix-darwin --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake ./#tsukuyomi
```

### Linux (Amaterasu)
```bash
sudo nixos-rebuild switch --flake ./#amaterasu
```

### Dotfiles
```bash
# Symlink dotfiles to home directory
stow --adopt -t ~ .dotfiles
```

## Architecture

### Directory Structure
- `flake.nix` - Main entry point; defines inputs (nixpkgs, home-manager, darwin, snowfall-lib)
- `modules/` - Nix modules organized by platform (`darwin/`, `linux/`) and category
- `systems/` - System-specific configurations (`aarch64-darwin/tsukuyomi`, `x86_64-linux/amaterasu`)
- `lib/` - Custom Nix utilities (`mkOpt`, `mkBoolOpt`, `enabled`, `disabled`)
- `.dotfiles/` - User configuration files symlinked to `~` via Stow

### Module Organization
Modules follow a hierarchical pattern under `modules/{darwin,linux}/`:
- `apps/` - GUI applications (firefox, obsidian, spotify, etc.)
- `cli/` - Command-line tools (neovim, tmux, zsh, etc.)
- `development/` - Languages and dev tools (go, nodejs20, php81, git, etc.)
- `services/` - System services (nix-daemon)
- `system/` - System settings (fonts, interface)
- `suites/` - Meta-modules that bundle related functionality (common, development, tiling)
- `layouts/` - Higher-level configurations (workstation)
- `tools/` - Platform-specific tools (aerospace, sketchybar on macOS; hyprland on Linux)

### Module Pattern
All modules follow this structure:
```nix
{ options, config, lib, pkgs, ... }:
with lib;
with lib.shiro;
let cfg = config.shiro.category.name;
in {
  options.shiro.category.name = with types; {
    enable = mkBoolOpt false "Description";
  };
  config = mkIf cfg.enable {
    # Configuration when enabled
  };
}
```

Use `enabled` and `disabled` helpers from `lib.shiro` to toggle modules:
```nix
shiro.cli.neovim = enabled;
shiro.apps.discord = disabled;
```

### Namespace
All options use the `shiro` namespace (e.g., `shiro.cli.neovim.enable`, `shiro.suites.common.enable`).

### Key Configurations in .dotfiles
- `nvim/` - Neovim setup with Lazy plugin manager, LSP configs, and Treesitter
- `sketchybar/` - macOS status bar (plugins, items, environment scripts)
- `aerospace.toml` - macOS tiling window manager
- `tmux/tmux.conf` - Terminal multiplexer (prefix: Ctrl+Space)
- `zsh/` - Shell config with oh-my-zsh and Powerlevel10k
