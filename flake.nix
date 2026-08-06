{
  description = "nixSO";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      # Personal settings (hostname, username, git identity, locale...).
      # Falls back to the example file so the flake still evaluates for
      # anyone who hasn't created their own profile.nix yet.
      profile =
        if builtins.pathExists ./profile.nix
        then import ./profile.nix
        else import ./profile.example.nix;
    in
    {
      nixosConfigurations.${profile.system.hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs profile; };
        modules = [
          ./hosts/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs profile; };
            home-manager.users.${profile.user.username} = import ./home;
          }
        ];
      };
    };
}