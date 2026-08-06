{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    inter
    source-serif
    roboto-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  fonts.fontconfig.defaultFonts = {
    sansSerif = [ "Inter" ];
    serif = [ "Source Serif 4" ];
    monospace = [ "Roboto Mono" ];
    emoji = [ "Noto Color Emoji" ];
  };
}