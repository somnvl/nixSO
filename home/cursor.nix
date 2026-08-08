{ pkgs, assets, profile, ... }:
{
  home.pointerCursor = {
    enable = true;
    name = profile.customization.cursor.theme;
    package = pkgs.stdenv.mkDerivation {
      pname = profile.customization.cursor.theme;
      version = "unstable";
      src = "${assets}/cursors/${profile.customization.cursor.theme}";
      installPhase = ''
        mkdir -p $out/share/icons
        cp -r . $out/share/icons/${profile.customization.cursor.theme}
      '';
    };
    size = profile.customization.cursor.size;
    gtk.enable = true;
  };

  home.sessionVariables = {
    XCURSOR_THEME = profile.customization.cursor.theme;
    XCURSOR_SIZE = toString profile.customization.cursor.size;
  };
}