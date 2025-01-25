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
    "social"
  ];

  output = {
    shiro = {
      apps = {
        discord = enabled;
        teams = enabled;
        telegram = enabled;
      };
    };
  };
}
