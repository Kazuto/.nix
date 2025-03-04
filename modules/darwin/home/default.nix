{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.home;
in
{
  options.shiro.home = with types; {
    file = mkOpt attrs { }
      "A set of files to be managed by home-manager's <option>home.file</option>.";
    configFile = mkOpt attrs { }
      "A set of files to be managed by home-manager's <option>xdg.configFile</option>.";
    extraOptions = mkOpt attrs { } "Options to pass directly to home-manager.";
  };

  config = {
    shiro.home.extraOptions = {
      home.stateVersion = config.system.stateVersion;
      home.file = mkAliasDefinitions options.shiro.home.file;
      xdg.enable = true;
      xdg.configFile = mkAliasDefinitions options.shiro.home.configFile;
    };

    snowfallorg.users.${config.shiro.user.name}.home.config = mkAliasDefinitions options.shiro.home.extraOptions;

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
    };
  };
}
