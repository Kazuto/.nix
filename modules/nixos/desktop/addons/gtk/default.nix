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

    programs.dconf.enable = true;

    environment.systemPackages = with pkgs; [
      gtk_engines
      gtk-engine-murrine
      glib
      gsettings-desktop-schemas
      gnome-themes-extra
      sassc
      themechanger
      catppuccin-gtk
      catppuccin-cursors.mochaDark
      adwaita-icon-theme  # Fallback cursors
      dconf-editor
    ];

    environment.sessionVariables = {
      GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
      GTK_USE_PORTAL = "1";
      XCURSOR_THEME = cfg.cursor.name;
      XCURSOR_SIZE = "24";
      # Add fallback cursor path - override default with mkForce
      XCURSOR_PATH = lib.mkForce "${pkgs.catppuccin-cursors.mochaDark}/share/icons:${pkgs.gnome-themes-extra}/share/icons:$HOME/.icons:$HOME/.local/share/icons";
    };

    # Set default cursor theme system-wide
    environment.variables = {
      XCURSOR_THEME = cfg.cursor.name;
      XCURSOR_SIZE = "24";
    };
  };
}



