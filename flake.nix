{
  description = "My nix configuration";

  inputs = {
    # NixPkgs (nixos-23.05)
    nixpkgs.url = "nixpkgs/nixos-24.11";

    # NixPkgs Unstable (nixos-unstable)
    unstable.url = "nixpkgs/nixos-unstable";

    # Home Manager (release-23.05)
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # In order to configure macOS systems.
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Unified configuration for systems, packages, modules, shells, templates, and more with Nix Flakes
    snowfall-lib = {
      url = "github:snowfallorg/lib";
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

      systems.modules = with inputs; [
        home-manager.nixosModules.home-manager
      ];
    };
}
