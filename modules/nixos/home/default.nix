{ options, config, lib, pkgs, inputs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.home;
in
{
  imports = with inputs; [
    home-manager.nixosModules.home-manager
  ];

  options.${namespace}.home = with types; {
    file = mkOpt attrs { }
      "A set of files to be managed by home-manager's <option>home.file</option>.";
    configFile = mkOpt attrs { }
      "A set of files to be managed by home-manager's <option>xdg.configFile</option>.";
    extraOptions = mkOpt attrs { } "Options to pass directly to home-manager.";
  };

  config = {
    shiro.home.extraOptions = {
      home.stateVersion = config.system.stateVersion;
      home.file = mkAliasDefinitions options.${namespace}.home.file;
      xdg.enable = true;
      xdg.configFile = mkAliasDefinitions options.${namespace}.home.configFile;
    };

    snowfallorg.users.${config.${namespace}.user.name}.home.config = config.${namespace}.home.extraOptions;

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
    };
  };
}


