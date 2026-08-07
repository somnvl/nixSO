{
  lib,
  pkgs,
  fetchFromGitHub,
  hyprland,
  hyprlandPlugins,
}:
hyprlandPlugins.mkHyprlandPlugin {
  inherit hyprland;
  pluginName = "scrolloverview";
  version = "unstable-2026-08-07";

  src = fetchFromGitHub {
    owner = "yayuuu";
    repo = "hyprland-scroll-overview";
    rev = "d1fc8d4ee35cdc597b6f3b4c8b93acebc5d5467f";
    hash = lib.fakeHash;
  };

  buildInputs = [ pkgs.lua5_4 ];

  enableParallelBuilding = true;
  dontUseCmakeConfigure = true;

  buildPhase = ''
    runHook preBuild
    make all
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/lib"
    mv scrolloverview.so "$out/lib/libscrolloverview.so"
    runHook postInstall
  '';

  meta = {
    description = "Scrollable workspace overview plugin for Hyprland, like niri's overview";
    homepage = "https://github.com/yayuuu/hyprland-scroll-overview";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}