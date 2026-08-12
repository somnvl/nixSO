# home/apps/papers.nix
#
# Document viewer (GTK4 rewrite of Evince), set as the default app for
# PDFs and friends. Same GSK_RENDERER=gl treatment as
# home/apps/nautilus.nix — see that file for why: GTK4's default Vulkan
# renderer enumerates every physical device (NVIDIA dGPU + AMD iGPU +
# llvmpipe software fallback on this hybrid-GPU laptop) on every launch,
# which is dead time before a single window pixel is drawn. Forcing GL
# skips that enumeration.
{ pkgs, lib, ... }:
let
  papersWrapped = pkgs.symlinkJoin {
    name = "papers-wrapped";
    paths = [ pkgs.papers ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/papers \
        --set GSK_RENDERER gl
    '';
  };

  documentMimeTypes = [
    "application/pdf"
    "application/x-pdf"
    "application/x-bzpdf"
    "application/x-gzpdf"
    "application/x-xpdf"
    "application/postscript"
    "application/x-bzpostscript"
    "application/x-gzpostscript"
    "image/x-eps"
    "image/x-bzeps"
    "image/x-gzeps"
    "application/x-dvi"
    "application/x-bzdvi"
    "application/x-gzdvi"
    "image/vnd.djvu"
    "image/vnd.djvu+multipage"
    "application/oxps"
    "application/vnd.ms-xpsdocument"
    "application/x-cbr"
    "application/x-cbz"
    "application/x-cb7"
    "application/x-cbt"
  ];
in
{
  # Install the wrapped binary instead of pkgs.papers directly, so
  # anything that launches "papers" (xdg-open, the .desktop entry)
  # transparently gets the GL-forced version.
  home.packages = [ papersWrapped ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = lib.genAttrs documentMimeTypes (_: [ "org.gnome.Papers.desktop" ]);
  };
}
