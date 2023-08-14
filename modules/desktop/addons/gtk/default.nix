{ lib, config, ... }:

let
  cfg = config.shiro.desktop.addons.gtk;
in
{
  options.shiro.desktop.addons.gtk = with types; {
    enable = mkBoolOpt false "Whether to customize GTK and apply themes.";
    theme = {
      name = mkOpt str "Juno"
        "The name of the GTK theme to apply.";
      pkg = mkOpt package pkgs.juno-theme "The package to use for the theme.";
    };
    cursor = {
      name = mkOpt str "Bibata-Modern-Amber"
        "The name of the cursor theme to apply.";
      pkg = mkOpt package pkgs.bibata-cursors "The package to use for the cursor theme.";
    };
    icon = {
      name = mkOpt str "Papirus"
        "The name of the icon theme to apply.";
      pkg = mkOpt package pkgs.papirus-icon-theme "The package to use for the icon theme.";
    };
  };

  config = mkIf cfg.enable {
    gtk = {
      enable = true;

      theme = {
        name = cfg.theme.name;
        package = cfg.theme.pkg;
      };

      cursorTheme = {
        name = cfg.cursor.name;
        package = cfg.cursor.pkg;
      };

      iconTheme = {
        name = cfg.icon.name;
        package = cfg.icon.pkg;
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };

      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
}



