{
  description = "NixOS Desktop Config - TimP4w";

  inputs = {
    # Nixpkgs
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; 
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    musnix.url = "github:musnix/musnix";
    # Hyprland
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    # Anyrun
    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hardware.url = "github:nixos/nixos-hardware";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... } @ inputs:
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
        ${VARS.hostSettings.hostname} = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs pkgs-unstable VARS; };
          modules = [
            inputs.musnix.nixosModules.musnix
            ./hosts/${VARS.hostSettings.hostname}/configuration.nix
          ]
          ++ (builtins.attrValues outputs.nixosModules);
        };
      };
    };
}
