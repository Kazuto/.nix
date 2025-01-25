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
    "layouts"
    "workstation"
  ];

  output = {
    shiro = {
      suites = {
        common = enabled;
        desktop = enabled;
        development = enabled;
        media = enabled;
        social = enabled;
      };
    };
  };
}
