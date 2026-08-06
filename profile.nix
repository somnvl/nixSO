{
  system = {
    hostname = "nixSO";
    timeZone = "Europe/Paris";
    locale = "en_US.UTF-8";
    consoleKeyMap = "fr";
  };

  user = {
    username = "so";
    repoPath = "/home/so/nixSO";
  };

  git = {
    name = "somnvl";
    email = "186089420+somnvl@users.noreply.github.com";
  };

  cursor = {
    theme = "miku";
    size = 50;
  };

  features = {
    docker = true;

    gc = {
      automatic = true;
      dates = "weekly";
      retention = "30d";
      optimiseAutomatic = true;
    };

    devTools  = true;
    cDev      = true;
    pythonDev = true;
    goDev     = true;
    wailsDev  = true;
  };

  # Enable if you have the same hybrid AMD iGPU + Nvidia dGPU laptop setup
  # (PRIME sync/offload). Leave false otherwise — the bus IDs below are
  # specific to one exact machine, not safe to apply blindly elsewhere.
  # Find yours with `lspci | grep -E "VGA|3D"`.
  nvidiaPrime = {
    enable = true;
    amdgpuBusId = "PCI:100:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}