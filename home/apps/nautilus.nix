# home/apps/nautilus.nix
#
# File manager. Nautilus doesn't ship with nautilus-python support wired
# up by default — loading Python extensions needs three things stitched
# together that upstream doesn't handle automatically: the extensions-4
# dir where libnautilus-python.so (the Python plugin host) lives, the
# share/ dir where .py extensions AND their GSettings schemas are
# discovered via XDG_DATA_DIRS, and any Python deps those extensions
# import at runtime. So instead of installing pkgs.nautilus directly, we
# wrap it with all of that baked in at build time — robust regardless of
# session/login mechanics (Hyprland, SDDM, systemd...).
{ pkgs, inputs, lib, ... }:
let
  # Every nautilus-python extension we want loaded. Each package's
  # share/nautilus-python/extensions/ (for the .py files) and
  # share/glib-2.0/schemas/ (for any GSettings schema — nautilus-my-computer
  # stores its settings under io.github.yannmasoch.nautilus-my-computer,
  # and silently fails to find them without this) get merged into
  # XDG_DATA_DIRS below.
  nautilusPythonExtensions = [
    inputs.nautilus-my-computer.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.nautilus-open-any-terminal
  ];

  # Python deps those extensions import at runtime (pycairo is needed by
  # nautilus-my-computer to draw the disk usage bars — without this on
  # PYTHONPATH, the extension loads but the bars silently fail to render).
  nautilusExtraPythonPackages = with pkgs.python3Packages; [
    pycairo
  ];

  nautilusWrapped = pkgs.symlinkJoin {
    name = "nautilus-wrapped";
    paths = [ pkgs.nautilus ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/nautilus \
        --set NAUTILUS_4_EXTENSION_DIR "${pkgs.nautilus-python}/lib/nautilus/extensions-4" \
        --suffix XDG_DATA_DIRS : "${lib.concatMapStringsSep ":" (p: "${p}/share") nautilusPythonExtensions}" \
        --suffix PYTHONPATH : "${lib.concatMapStringsSep ":" (p: "${p}/${pkgs.python3.sitePackages}") nautilusExtraPythonPackages}"
    '';
  };
in
{
  # Install the wrapped binary instead of pkgs.nautilus directly, so
  # anything that launches "nautilus" (xdg-open, the .desktop entry below)
  # transparently gets the version with working extensions.
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

    "org/gnome/nautilus/window-state" = {
      maximized = false;
    };
  };
}