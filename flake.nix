{
  description = "NixOS Desktop Config - TimP4w";

  inputs = {
    # Nixpkgs
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; 
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    musnix.url = "github:musnix/musnix";
    # Hyprland
    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };
    # Anyrun
    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    # hardware.url = "github:nixos/nixos-hardware";
    solaar = {
      url = "https://flakehub.com/f/Svenum/Solaar-Flake/*.tar.gz"; # For latest stable version
      #url = "https://flakehub.com/f/Svenum/Solaar-Flake/1.1.13.tar.gz" # uncomment line for version 1.1.13
      #url = "github:Svenum/Solaar-Flake/main"; # Uncomment line for latest unstable version
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-wsl, solaar, ... } @ inputs:
    let
      # Import variables
      VARS = import ./variables.nix;

      inherit (self) outputs;
      pkgs-unstable = import nixpkgs-unstable {
        system = VARS.hostSettings.system;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      nixosModules = import ./modules;

      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs pkgs-unstable VARS; };
          modules = [
            inputs.musnix.nixosModules.musnix
            solaar.nixosModules.default
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit inputs outputs pkgs-unstable VARS;
                  vars = {
                    hostName = "nixos";
                  };
                };
                users.${VARS.userSettings.username} = import ./home/users/${VARS.userSettings.username};
              };
            }
            ./hosts/nixos/configuration.nix

          ]
          ++ (builtins.attrValues outputs.nixosModules);
        };
        tpad-lu-77 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs pkgs-unstable VARS; };
          modules = [
            inputs.musnix.nixosModules.musnix
            solaar.nixosModules.default
            nixos-wsl.nixosModules.default
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit inputs outputs pkgs-unstable VARS;
                  vars = {
                    hostName = "tpad-lu-77";
                  };
                };
                users.${VARS.userSettings.username} = import ../../home/users/${VARS.userSettings.username};
              };
            }
            ./hosts/tpad-lu-77/configuration.nix
          ]
          ++ (builtins.attrValues outputs.nixosModules);
        };
      };
    };
}
