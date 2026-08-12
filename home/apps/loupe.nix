# home/apps/loupe.nix
#
# Image viewer, set as the default app for images. Same GSK_RENDERER=gl
# treatment as home/apps/nautilus.nix — see that file for why: GTK4's
# default Vulkan renderer enumerates every physical device (NVIDIA dGPU +
# AMD iGPU + llvmpipe software fallback on this hybrid-GPU laptop) on
# every launch, which is dead time before a single window pixel is
# drawn. Forcing GL skips that enumeration.
{ pkgs, lib, ... }:
let
  loupeWrapped = pkgs.symlinkJoin {
    name = "loupe-wrapped";
    paths = [ pkgs.loupe ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/loupe \
        --set GSK_RENDERER gl

      # Upstream's .desktop advertises DBusActivatable=true, but nixpkgs
      # doesn't ship the share/dbus-1/services/org.gnome.Loupe.service
      # that's supposed to back it — so GNOME/GIO's "open" tries to
      # activate the app by bus name and fails with "The name is not
      # activatable" instead of falling back to Exec=. Flip the flag off
      # so launchers (Nautilus, xdg-open, gio open) just fork-exec the
      # Exec= line like a normal app, which works fine.
      rm -f "$out/share/applications/org.gnome.Loupe.desktop"
      sed 's/^DBusActivatable=true$/DBusActivatable=false/' \
        "${pkgs.loupe}/share/applications/org.gnome.Loupe.desktop" \
        > "$out/share/applications/org.gnome.Loupe.desktop"
    '';
  };

  imageMimeTypes = [
    "image/bmp"
    "image/gif"
    "image/jpeg"
    "image/jpg"
    "image/png"
    "image/tiff"
    "image/webp"
    "image/svg+xml"
    "image/avif"
    "image/heif"
    "image/heic"
    "image/x-icon"
    "image/vnd.microsoft.icon"
    "image/x-portable-anymap"
    "image/x-tga"
  ];
in
{
  # Install the wrapped binary instead of pkgs.loupe directly, so anything
  # that launches "loupe" (xdg-open, the .desktop entry) transparently
  # gets the GL-forced version.
  home.packages = [ loupeWrapped ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = lib.genAttrs imageMimeTypes (_: [ "org.gnome.Loupe.desktop" ]);
  };
}
