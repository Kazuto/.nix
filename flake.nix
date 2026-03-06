{
  description = "My nix configuration";

  inputs = {
    # NixPkgs Unstable
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";

    # NixPkgs Unstable (nixos-unstable)
    unstable.url = "nixpkgs/nixos-unstable";

    # Home Manager (master, follows nixpkgs-unstable)
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # In order to configure macOS systems.
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Unified configuration for systems, packages, modules, shells, templates, and more with Nix Flakes
    snowfall-lib = {
      url = "github:snowfallorg/lib/dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nixvim - Neovim configuration in Nix
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Simplified Nix Flakes on the command line
    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    split-monitor-workspaces = {
      url = "github:zjeffer/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    };
  };

  outputs = inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;

	    snowfall = {
          meta = {
            name = "shiro";
            title = "Shiro";
          };

          namespace = "shiro";
        };
      };

    in
    lib.mkFlake {
      channels-config = {
	      allowUnfree = true;
	      permittedInsecurePackages = [];
      };

      overlays = with inputs; [
	      snowfall-flake.overlays.default
      ];

      systems.modules.nixos = with inputs; [
        home-manager.nixosModules.home-manager
        nixvim.nixosModules.nixvim
      ];

      systems.modules.darwin = with inputs; [
        home-manager.darwinModules.home-manager
        nixvim.nixDarwinModules.nixvim
      ];

      homes.modules = with inputs; [
        nixvim.homeManagerModules.nixvim
      ];
    };
}
