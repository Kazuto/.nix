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
