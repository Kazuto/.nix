{ 
  config, 
  lib, 
  pkgs, 
  namespace, 
  ... 
}:
let
  inherit (lib.${namespace}) enabled;
in
lib.${namespace}.mkModule {
  inherit config;

  path = [
    "suites"
    "gaming"
  ];

  output = {
    shiro = {
      apps = {
        discord = enabled;
        lutris = enabled;
        prismlauncher = enabled;
        steam = enabled;
      };
    };
  };
}
