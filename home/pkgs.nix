# home/apps/pkgs.nix
#
# home.packages, grouped by purpose. Everything beyond basic desktop apps
# is gated behind profile flags (see profile.example.nix) — off by
# default, so forking this repo doesn't pull in dev toolchains you don't
# need. Turn on only what you actually use.
{ lib, pkgs, profile, ... }:
{
  home.packages = with pkgs; [
    # --- Daily desktop use (always installed) ---
    google-chrome

    hyprshutdown
    hyprshot
      grim
      slurp
  ]
  # Generic dev CLI tools (useful for any language/project).
  ++ lib.optionals profile.features.devTools (with pkgs; [
    gnumake
    ripgrep
    fd
  ])
  # Python toolchain.
  ++ lib.optionals profile.features.pythonDev (with pkgs; [
    uv
    (python314.withPackages (ps: with ps; [
      pip
      virtualenv
      pytest
      ipython
      debugpy
      pydantic
      pygame
      mypy
      flake8
    ]))
    ruff
    pyright
    black
  ])
  # Go toolchain.
  ++ lib.optionals profile.features.goDev (with pkgs; [
    go
    gopls
    gotools
  ])
  # Wails (Go + WebView GUI framework) — needs Go, Node for the frontend
  # build, and native GTK/webkit dev headers to compile against.
  ++ lib.optionals profile.features.wailsDev (with pkgs; [
    nodejs_22
    gtk3.dev
    webkitgtk_4_1.dev
    pango.dev
    cairo.dev
    gdk-pixbuf.dev
    atk.dev
    harfbuzz.dev
    fribidi.dev
    fontconfig.dev
    freetype.dev
    glib.dev
    at-spi2-core.dev
    libepoxy.dev
    zlib.dev
    libsoup_3.dev
    libayatana-appindicator
  ])
  # C toolchain.
  ++ lib.optionals profile.features.cDev (with pkgs; [
    gcc
    glib
    glibc.dev
    stdenv.cc.cc.lib
    gdb
    valgrind
    norminette
    lldb
    bear
    man-pages
    man-pages-posix
    SDL2
    SDL2_mixer
    SDL2_image
    SDL2_ttf
    pkg-config
  ]);

  home.sessionVariables =
    # Needed to compile against the Wails dev packages above.
    (lib.optionalAttrs profile.features.wailsDev (let
      guiDevPkgs = with pkgs; [
        gtk3.dev webkitgtk_4_1.dev pango.dev cairo.dev gdk-pixbuf.dev
        atk.dev harfbuzz.dev fribidi.dev fontconfig.dev freetype.dev
        glib.dev at-spi2-core.dev libepoxy.dev zlib.dev libsoup_3.dev
      ];
    in {
      PKG_CONFIG_PATH = lib.concatMapStringsSep ":"
        (p: "${p}/lib/pkgconfig:${p}/share/pkgconfig") guiDevPkgs
        + ":$PKG_CONFIG_PATH";
    }));
}