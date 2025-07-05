{
  description = "NixOS Desktop Config - TimP4w";

  inputs = {
    # Nixpkgs
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Musnix
    musnix.url = "github:musnix/musnix";

    # Hyprland
    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };
    #

    # Anyrun
    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # WSL
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    # Hardware optimizations
    # hardware.url = "github:nixos/nixos-hardware";

    # Solaar
    solaar = {
      url = "https://flakehub.com/f/Svenum/Solaar-Flake/*.tar.gz"; # For latest stable version
      #url = "github:Svenum/Solaar-Flake/main"; # Uncomment line for latest unstable version
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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
      };
    };
}
