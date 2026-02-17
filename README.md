# My nix configuration

# Instructions

## 1. Clone repo

```bash
git clone https://github.com/Kazuto/NixOS.git ~/.dotfiles
```

## 2. Install nix (skip if NixOS)

**Linux**

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

**macOS**

```bash
sh <(curl -L https://nixos.org/nix/install)
```

## 3. Build your desired configuration

### Amaterasu (Development on Linux)

```bash
sudo nixos-rebuild switch --flake ./#amaterasu
```

### Tsukuyomi (Development on macOS)

```bash
# First build
nix run nix-darwin \
    --extra-experimental-features nix-command \
    --extra-experimental-features flakes \
    -- switch --flake ./#tsukuyomi

# Consecutive builds
darwin-rebuild switch --flake ./#tsukuyomi
```

## 4. Stow your dotfiles

```bash
stow --adopt -t ~ .dotfiles
```

## 5. Sketchybar (macOS only)

The status bar uses [SketchyBar](https://github.com/FelixKratz/SketchyBar) with a Lua config via [SbarLua](https://github.com/FelixKratz/SbarLua).

### Install SketchyBar

```bash
brew install FelixKratz/formulae/sketchybar
```

### Install SbarLua

```bash
git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua \
  && cd /tmp/SbarLua/ \
  && make install \
  && rm -rf /tmp/SbarLua/
```

This places `sketchybar.so` in `~/.local/share/sketchybar_lua/`.

### Install dependencies

```bash
# App font for workspace window icons
brew tap kvndrsslr/homebrew-formulae
brew install sketchybar-app-font

# Audio device switching (used by the audio item)
brew install switchaudio-osx

# JSON processing
brew install jq
```

### Install fonts

The config uses **JetBrainsMono Nerd Font** (icons) and **SF Pro** (labels). JetBrainsMono Nerd Font is installed via the Nix config. SF Pro can be downloaded from [developer.apple.com/fonts](https://developer.apple.com/fonts/).

### Start SketchyBar

```bash
brew services start sketchybar
```

### Verify

```bash
sketchybar --reload
```

All items should render on the bar. Hover over CPU, memory, network, audio, github, or spotify for popup details.
