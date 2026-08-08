{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    brightnessctl
    bluetui
    acpi
    alsa-utils
    mesa-demos
    libinput
  ];

  hardware.bluetooth.enable = true;
  security.rtkit.enable = true;

  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = false;
  };

  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
}