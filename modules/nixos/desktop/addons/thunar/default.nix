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
    "desktop"
    "addons"
    "thunar"
  ];

  output = {
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
       thunar-archive-plugin
       thunar-volman
       thunar-media-tags-plugin
      ];
    };

    services.gvfs.enable = true; # Mount, trash, and other functionalities
    services.tumbler.enable = true; # Thumbnail support for images
  };
}
