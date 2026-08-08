{ pkgs, lib, profile, ... }:
{
  xdg.configFile."niri/cursor.kdl".text = ''
    cursor {
        xcursor-theme "${profile.cursor.theme}"
        xcursor-size ${toString profile.cursor.size}
        hide-after-inactive-ms 10000
    }
  '';

  xdg.configFile."niri/gpu.kdl".text = lib.optionalString profile.nvidiaPrime.enable ''
    debug {
        render-drm-device "${profile.nvidiaPrime.renderDevice}"
        wait-for-frame-completion-before-queueing
        disable-direct-scanout
        disable-cursor-plane
    }
  '';

  xdg.configFile."niri/outputs.kdl".text = lib.concatMapStringsSep "\n" (d: ''
    output "${d.connector}" {
        scale ${toString d.scale}
    }
  '') profile.displays;

  xdg.configFile."niri/config.kdl".source = ../../dotfiles/config/niri/config.kdl;
}