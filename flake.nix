{
  description = "nixSO";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    assets = {
      url = "github:somnvl/nixSO.assets";
      flake = false;
    };

    spicetify.url = "github:Gerg-L/spicetify-nix";

    nautilus-my-computer = {
      url = "github:yannmasoch/nautilus-my-computer?dir=packaging/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, assets, spicetify, nautilus-my-computer, nix-vscode-extensions, ... }@inputs:
    let
      system = "x86_64-linux";

      profile =
        if builtins.pathExists ./profile.nix
        then import ./profile.nix
        else import ./profile.example.nix;
    in
    {
      nixosConfigurations.${profile.system.hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs profile assets; };
        modules = [
          ./hosts/configuration.nix
          { nixpkgs.overlays = [ nix-vscode-extensions.overlays.default ]; }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs profile assets; };
            home-manager.sharedModules = [
              spicetify.homeManagerModules.default
            ];
            home-manager.users.${profile.user.username} = import ./home;
          }
        ];
      };
    };
}