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

    # Simplified Nix Flakes on the command line
    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
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
      ];

      systems.modules.darwin = with inputs; [
        home-manager.darwinModules.home-manager
      ];
    };
}
