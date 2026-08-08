{ pkgs, lib, profile, ... }:
{
  xdg.configFile."niri/cursor.kdl".text = ''
    cursor {
        xcursor-theme "${profile.customization.cursor.theme}"
        xcursor-size ${toString profile.customization.cursor.size}
        hide-after-inactive-ms 10000
    }
  '';

  xdg.configFile."niri/gpu.kdl".text = lib.optionalString profile.hardware.nvidiaPrime.enable ''
    debug {
        render-drm-device "${profile.hardware.nvidiaPrime.renderDevice}"
        wait-for-frame-completion-before-queueing
  '' + lib.optionalString (profile.hardware.nvidiaPrime.enable && profile.workarounds.niriScanoutWorkarounds) ''
        disable-direct-scanout
        disable-cursor-plane
  '' + lib.optionalString profile.hardware.nvidiaPrime.enable ''
    }
  '';

  xdg.configFile."niri/outputs.kdl".text = lib.concatMapStringsSep "\n" (d: ''
    output "${d.connector}" {
        scale ${toString d.scale}
    }
  '') profile.displays;

  xdg.configFile."niri/config.kdl".source = ../../dotfiles/config/niri/config.kdl;
}