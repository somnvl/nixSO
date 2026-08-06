{ pkgs, lib, ... }:
let
  nautilusPythonExtensions = [
    pkgs.nautilus-open-any-terminal
  ];

  nautilusWrapped = pkgs.symlinkJoin {
    name = "nautilus-wrapped";
    paths = [ pkgs.nautilus ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/nautilus \
        --set NAUTILUS_4_EXTENSION_DIR "${pkgs.nautilus-python}/lib/nautilus/extensions-4" \
        --suffix XDG_DATA_DIRS : "${lib.concatMapStringsSep ":" (p: "${p}/share") nautilusPythonExtensions}"
    '';
  };
in
{
  home.packages = [ nautilusWrapped ];

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
      };
    };
  };

  dconf.settings = {
    "com/github/stunkymonkey/nautilus-open-any-terminal" = {
      terminal = "kitty";
    };
  };
}