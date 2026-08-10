{ lib, pkgs, profile, ... }:
{
  home.packages =
    lib.optionals profile.dev.devTools (with pkgs; [
      gnumake
      ripgrep
      fd
    ])
    ++ lib.optionals profile.dev.pythonDev (with pkgs; [
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
    ++ lib.optionals profile.dev.goDev (with pkgs; [
      go
      gopls
      gotools
    ])
    ++ lib.optionals profile.dev.wailsDev (with pkgs; [
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
    ++ lib.optionals profile.dev.cDev (with pkgs; [
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
    (lib.optionalAttrs profile.dev.wailsDev (let
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