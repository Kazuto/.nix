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
    "core"
  ];

  output = {
    shiro = {
      nix = enabled;

      cli = {
        flake = enabled;
      };

      hardware = {
        audio = enabled;
        network = enabled;
      };

      services = {
        openssh = enabled;
        printing = enabled;
        dbus = enabled;
      };

      system = {
        boot = enabled;
        env = enabled;
        fonts = enabled;
        locale = enabled;
        time = enabled;
        xkb = enabled;
      };

      tools = {
        git = enabled;
      };
    };

    environment.systemPackages = with pkgs; [
      killall
      gcc
      gnumake
      pkg-config
      xorg.xhost
    ];
  };
}
