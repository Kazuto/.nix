{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.desktop.addons.gtk;
in
{
  options.shiro.desktop.addons.gtk = with types; {
    enable = mkBoolOpt false "Whether to customize GTK and apply themes.";
    theme = {
      name = mkOpt str "Catppuccin-Mocha-Standard-Blue-Dark" "The name of the GTK theme to apply.";
      pkg = mkOpt package pkgs.catppuccin-gtk "The package to use for the theme.";
    };
    cursor = {
      name = mkOpt str "Catppuccin-Mocha-Dark-Cursors" "The name of the cursor theme to apply.";
      pkg = mkOpt package pkgs.catppuccin-cursors.mochaDark "The package to use for the cursor theme.";
    };
    icon = {
      name = mkOpt str "Papirus-Dark" "The name of the icon theme to apply.";
      pkg = mkOpt package pkgs.papirus-icon-theme "The package to use for the icon theme.";
    };
  };

  config = mkIf cfg.enable {
    shiro.home.extraOptions = {
      gtk = {
        enable = true;

        theme = {
          name = cfg.theme.name;
          package = cfg.theme.pkg.override {
            variant = "mocha";
          };
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
    };

    programs.dconf = enabled;

    environment.systemPackages = with pkgs; [
      gtk_engines
      gtk-engine-murrine
      glib
      gsettings-desktop-schemas
      gnome.gnome-themes-extra
      sassc
      themechanger
      catppuccin-gtk
      gnome.dconf-editor
    ];

    environment.sessionVariables = {
      GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
      GTK_USE_PORTAL = "1";
    };
  };
}



