{ pkgs, inputs, ... }:
let
  spicePkgs = inputs.spicetify.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  programs.spicetify = {
    enable = true;

    theme = spicePkgs.themes.text;
    colorScheme = "tokyoNight";

    enabledExtensions = with spicePkgs.extensions; [
      adblock
      hidePodcasts
    ];
  };
}