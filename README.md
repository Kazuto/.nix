# Hyprland on NixOS configuration

# Instructions
1. Clone repo into new hidden directory.
```bash
git clone https://github.com/Kazuto/NixOS.git ~/.dotfiles
```

2. Symlink (or copy) NixOS configuration file
```bash
sudo ln -s $HOME/.dotfiles/nixos/configuration.nix /etc/nixos/configuration.nix
```
or

```bash
sudo cp $HOME/.dotfiles/nixos/configuration.nix /etc/nixos/configuration.nix
```

3. Run installation script for other configuration symlinks
```bash
./install.sh
```

4. Rebuild NixOS
```bash
sudo nixos-rebuild switch
```
