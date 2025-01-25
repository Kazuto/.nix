{ 
  config, 
  lib, 
  namespace, 
  options,
  ... 
}:
lib.${namespace}.mkModule {
  inherit config;

  path = [
    "home"
  ];

  extraOptions = with lib.types; {
    file = lib.${namespace}.mkOpt attrs { }
      "A set of files to be managed by home-manager's <option>home.file</option>.";
    configFile = lib.${namespace}.mkOpt attrs { }
      "A set of files to be managed by home-manager's <option>xdg.configFile</option>.";
    extraOptions = lib.${namespace}.mkOpt attrs { } "Options to pass directly to home-manager.";
  };

  output = with config.${namespace}.home; {
    ${namespace}.home.extraOptions = {
      home.stateVersion = config.system.stateVersion;
      home.file = lib.mkAliasDefinitions options.${namespace}.home.file;

      xdg.enable = true;
      xdg.configFile = lib.mkAliasDefinitions options.${namespace}.home.configFile;
    };

    # snowfallorg.users.${config.shiro.user.name}.home.config = lib.mkAliasDefinitions options.shiro.home.extraOptions;

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;

      users.${config.${namespace}.user.name} = 
        lib.mkAliasDefinitions options.${namespace}.home.extraOptions;
    };
  };
}


