{ 
  config, 
  lib, 
  pkgs, 
  namespace,
  ... 
}:
lib.${namespace}.mkModule {
  inherit config;

  path = [
    "tools"
    "git"
  ];

  extraOptions = with lib.types; {
    file = lib.${namespace}.mkOpt attrs { }
      "A set of files to be managed by home-manager's <option>home.file</option>.";
    configFile = lib.${namespace}.mkOpt attrs { }
      "A set of files to be managed by home-manager's <option>xdg.configFile</option>.";
    extraOptions = lib.${namespace}.mkOpt attrs { } "Options to pass directly to home-manager.";
  };

  output = with config.${namespace}.home {
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


