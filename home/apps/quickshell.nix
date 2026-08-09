{ pkgs, profile, ... }:
{
  home.packages = [ pkgs.quickshell ];

  xdg.configFile."quickshell" = {
    source = ../../dotfiles/config/quickshell;
    recursive = true;
  };

  xdg.configFile."quickshell/config-defaults/wallpaper.json".text = builtins.toJSON {
    fitMode = profile.customization.wallpaper.fitMode;
    transitionDuration = profile.customization.wallpaper.transitionDuration;
    autorotateEnable = profile.customization.wallpaper.autorotate.enable;
    autorotateFolder = profile.customization.wallpaper.autorotate.folder;
    autorotateFrequencyMinutes = profile.customization.wallpaper.autorotate.frequencyMinutes;
  };
}