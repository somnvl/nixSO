{ ... }:
{
  boot.kernelParams = [
    "quiet"
    "splash"
    # Disables AMD Panel Self Refresh (PSR) — known to cause invisible
    # (not captured by screen recording) flicker/corruption on some AMD
    # laptop panels
    "amdgpu.dcdebugmask=0x10"
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