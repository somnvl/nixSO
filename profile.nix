{
  system = {
    hostname = "nixSO";
    timeZone = "Europe/Paris";
    locale = "en_US.UTF-8";
    consoleKeyMap = "fr";

    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        retention = "30d";
        optimiseAutomatic = true;
      };

      bootGenerationsLimit = 3;
    };
  };

  user = {
    username = "so";
    repoPath = "/home/so/nixSO";

    git = {
      name = "somnvl";
      email = "186089420+somnvl@users.noreply.github.com";
    };
  };

  customization = {
    cursor = {
      theme = "miku";
      size = 50;
    };
  };

  displays = [
    {
      connector = "eDP-1";
      scale = 1.25;
    }
  ];

  dev = {
    devTools  = true;
    cDev      = true;
    pythonDev = true;
    goDev     = true;
    wailsDev  = true;

    docker = true;
  };


  hardware = {
    nvidiaPrime = {
      enable = true;
      amdgpuBusId = "PCI:100:0:0";
      nvidiaBusId = "PCI:1:0:0";
      renderDevice = "/dev/dri/renderD129";
    };
  };

  workarounds = {
    disablePsr = false;
    gtk4Renderer = false;
    niriScanoutWorkarounds = false;
  };
}