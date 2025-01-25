{ 
  config, 
  lib, 
  pkgs, 
  namespace,
  user-defaults,
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
    initialPassword = lib.${namespace}.mkOpt' str "password";
  };

  output = {
    users ={ 
      users.${user-defaults.name} = {
        isNormalUser = true;

        inherit (user-defaults) name initialPassword;

        home = "/home/${user-defaults.name}";
        group = "users";

        shell = pkgs.zsh;

        uid = 1000;

        extraGroups = [ "wheel" ] ++ cfg.extraGroups;
      } // cfg.extraOptions;
    }
  };
}