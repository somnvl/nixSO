{ ... }:
{
  boot.kernelParams = [
    "quiet"
    "splash"
  ];

  boot = {
    consoleLogLevel = 0;

    initrd = {
      verbose = false;
      systemd.enable = true;
    };

    loader = {
      timeout = 0;

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };

      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 3;
      };

      grub.enable = false;
    };
  };
}