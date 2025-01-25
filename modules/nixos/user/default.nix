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
    "user"
  ];

  extraOptions = with lib.types; {
    name = lib.${namespace}.mkOpt' str "kazuto";
    fullName = lib.${namespace}.mkOpt' str "Kai Mayer";
    email = lib.${namespace}.mkOpt' str "mail@kazuto.de";
  };

  output = with config.${namespace}.user; {
    users = { 
      users.${name} = {
        isNormalUser = true;

        name = name;

        home = "/home/${name}";
        group = "users";

        shell = pkgs.zsh;

        uid = 1000;

        extraGroups = [ "wheel" ];
      };
    };
  };
}