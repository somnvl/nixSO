{ pkgs, ... }:

{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "voidSDDM";

    extraPackages = with pkgs; [
      qt6Packages.qtmultimedia
      qt6Packages.qtimageformats
      qt6Packages.qtdeclarative
      kdePackages.qtmultimedia
      kdePackages.qtsvg
      kdePackages.qtvirtualkeyboard
    ];
  };
  environment.systemPackages = with pkgs; [
    kdePackages.sddm-kcm

    (pkgs.stdenv.mkDerivation {
      name = "voidSDDM";
      src = ../dotfiles;
      installPhase = ''
        mkdir -p $out/share/sddm/themes/voidSDDM
        cp -r ./theming/sddm/* $out/share/sddm/themes/voidSDDM/
      '';
    })
  ];
}