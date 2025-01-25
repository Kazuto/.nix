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
    "desktop"
  ];

  output = {
    shiro = {
      apps = {
        bitwarden = enabled;
        firefox = enabled;
      };
    };
  };
}
