# home/apps/celluloid.nix
#
# Video player (GTK4 frontend for mpv), set as the default app for
# videos. Same GSK_RENDERER=gl treatment as home/apps/nautilus.nix — see
# that file for why: GTK4's default Vulkan renderer enumerates every
# physical device (NVIDIA dGPU + AMD iGPU + llvmpipe software fallback on
# this hybrid-GPU laptop) on every launch, which is dead time before a
# single window pixel is drawn. Forcing GL skips that enumeration.
{ pkgs, lib, ... }:
let
  celluloidWrapped = pkgs.symlinkJoin {
    name = "celluloid-wrapped";
    paths = [ pkgs.celluloid ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/celluloid \
        --set GSK_RENDERER gl

      # Upstream's .desktop advertises DBusActivatable=true, but nixpkgs
      # doesn't ship the matching
      # share/dbus-1/services/io.github.celluloid_player.Celluloid.service
      # — so GNOME/GIO's "open" tries to activate the app by bus name and
      # fails with "The name is not activatable" instead of falling back
      # to Exec=. Flip the flag off so launchers (Nautilus, xdg-open, gio
      # open) just fork-exec the Exec= line like a normal app, which
      # works fine.
      rm -f "$out/share/applications/io.github.celluloid_player.Celluloid.desktop"
      sed 's/^DBusActivatable=true$/DBusActivatable=false/' \
        "${pkgs.celluloid}/share/applications/io.github.celluloid_player.Celluloid.desktop" \
        > "$out/share/applications/io.github.celluloid_player.Celluloid.desktop"
    '';
  };

  videoMimeTypes = [
    "video/mp4"
    "video/x-matroska"
    "video/webm"
    "video/quicktime"
    "video/x-msvideo"
    "video/mpeg"
    "video/ogg"
    "video/x-flv"
    "video/x-ms-wmv"
    "video/3gpp"
    "video/3gpp2"
    "application/ogg"
  ];
in
{
  # Install the wrapped binary instead of pkgs.celluloid directly, so
  # anything that launches "celluloid" (xdg-open, the .desktop entry)
  # transparently gets the GL-forced version.
  home.packages = [ celluloidWrapped ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = lib.genAttrs videoMimeTypes (_: [ "io.github.celluloid_player.Celluloid.desktop" ]);
  };
}
