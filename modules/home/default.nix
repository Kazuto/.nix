{ lib, config, inputs, ... }:

let
  cfg = config.shiro.home;
in
{
  imports = with inputs; [
    home-manager.nixosModules.home-manager
  ];

  options.shiro.home = with types; {
    file = mkOpt attrs { }
      "A set of files to be managed by home-manager's <option>home.file</option>.";
    configFile = mkOpt attrs { }
      "A set of files to be managed by home-manager's <option>xdg.configFile</option>.";
    extraOptions = mkOpt attrs { } "Options to pass directly to home-manager.";
  };

  config = mkIf cfg.enable {
    shiro.home.extraOptions = {
      home.stateVersion = config.system.stateVersion;
      home.file = mkAliasDefinitions options.shiro.home.file;
      xdg.enable = true;
      xdg.configFile = mkAliasDefinitions options.shiro.home.configFile;
    };

    home-manager = {
      useUserPackages = true;

      users.${config.shiro.user.name} =
        mkAliasDefinitions options.shiro.home.extraOptions;
    };
  };
}


