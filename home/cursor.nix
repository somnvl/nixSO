{ pkgs, assets, profile, ... }:
{
  home.pointerCursor = {
    enable = true;
    name = profile.cursor.theme;
    package = pkgs.stdenv.mkDerivation {
      pname = profile.cursor.theme;
      version = "unstable";
      src = "${assets}/cursors/${profile.cursor.theme}";
      installPhase = ''
        mkdir -p $out/share/icons
        cp -r . $out/share/icons/${profile.cursor.theme}
      '';
    };
    size = profile.cursor.size;
    gtk.enable = true;
  };

  home.sessionVariables = {
    XCURSOR_THEME = profile.cursor.theme;
    XCURSOR_SIZE = toString profile.cursor.size;
  };
}