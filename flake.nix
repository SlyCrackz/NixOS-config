{
  description = "System and Home-Manager Flake";

  inputs = {
    # Stable Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    # Unstable Nixpkgs for cutting-edge packages
    unstablenixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, unstablenixpkgs, home-manager, ... }:
    let
      # Define both stable and unstable packages
      unstablepkgs = unstablenixpkgs.legacyPackages.x86_64-linux;
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      # NixOS system configuration
      nixosConfigurations.nixbox = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos/configuration.nix # Point to the NixOS system config file
        ];
      };

      # Home Manager configuration
      homeConfigurations.crackz = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home-manager/home.nix # Point to the Home Manager config file
        ];
        extraSpecialArgs = {
          unstablepkgs = unstablepkgs;
        };
      };
    };
}

