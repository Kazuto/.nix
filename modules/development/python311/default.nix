{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.shiro.development.python311;
in
{
  options.shiro.development.python311 = with types; {
    enable = mkBoolOpt false "Whether or not to use Python 3.11.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;  [
      (python311Full.withPackages(p: with p; [
        pygobject3 gst-python
      ]))

      python311Packages.pip
      gst_all_1.gstreamer
    ];
  };
}
