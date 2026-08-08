{ pkgs, profile, ... }:
{
  xdg.configFile."niri/cursor.kdl".text = ''
    cursor {
        xcursor-theme "${profile.cursor.theme}"
        xcursor-size ${toString profile.cursor.size}
        hide-after-inactive-ms 15000
    }
  '';

  xdg.configFile."niri/config.kdl".source = ../../dotfiles/config/niri/config.kdl;
}