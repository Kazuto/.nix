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
    "media"
  ];

  output = {
    shiro = {
      apps = {
        spotify = enabled;
        vlc = enabled;
      };
    };
  };
}
