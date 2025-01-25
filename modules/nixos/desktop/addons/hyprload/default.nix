{ 
  config, 
  lib, 
  pkgs, 
  namespace, 
  ... 
}:
let
  hyprload = stdenv.mkDerivation {
    name = "hyprload";
    src = fetchFromGitHub {
        owner = "Duckonaut";
        repo = "hyprload";
        rev = "cdec6d114143d6ee95fd77683e494ab65fb74351";
        sha256 = "0rs9bxxrw4wscf4a8yl776a8g880m5gcm75q06yx2cn3lw2b7v22";
    };

    installPhase = ''
      ./install.sh
    '';
  };
in
lib.${namespace}.mkModule {
  inherit config;

  path = [
    "desktop"
    "addons"
    "hyperload"
  ];

  output = {
    environment.systemPackages = [ hyprload ];

    shiro.home.configFile."hypr/hyprload.toml".source = ./hyprload.toml;
  };
}



