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
    "development"
    "languages"
    "python311"
  ];

  output = {
    environment.systemPackages = with pkgs;  [
      (python311Full.withPackages(p: with p; [
        pygobject3 gst-python
      ]))

      python311Packages.pip
      gst_all_1.gstreamer
    ];
  };
}
