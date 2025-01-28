{
  description = "spaghetti";

  inputs = {
    # Base inputs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    oldstable.url = "github:NixOS/nixpkgs/nixos-24.05"; # Needed for nix-on-droid
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Extra inputs
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    llakaLib = {
      url = "github:/llakala/llakaLib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    menu = {
      url = "github:/llakala/menu";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.llakaLib.follows = "llakaLib";
    };
    nixnvim = {
      url = "github:nixneovim/nixneovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jovian-nixos = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "unstable";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "oldstable";
    };
    programsdb = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    nix-flatpak,
    home-manager,
    disko,
    lanzaboote,
    hjem,
    ...
  } @ inputs:
  let
    inherit (nixpkgs.lib) nixosSystem;
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShellNoCC {
      name = "radioaddition";
      meta.description = "devshell for managing this repo";

      NIX_CONFIG = "extra-experimental-features = nix-command flakes";

      packages = with nixpkgs.legacyPackages.x86_64-linux; [
	age
        alejandra
        deadnix
	fastfetch
        fish
	fzf
        git
	glow
	gum
	hyfetch
        just
        neovim
        nh
	sbctl
        statix
	inputs.disko.packages.x86_64-linux.default
      ];
    };

    nixosConfigurations = {
      framework = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./base/programs/flatpak.nix
          #./base/gaming.nix # Disable unless I'm using it (currently broken)
          ./base/DEs/gnome.nix
          ./base/networking.nix
          ./base/programs/packages.nix
          ./base/security.nix
          ./base/shells/fish.nix
          ./base/system.nix
          ./base/users.nix
          ./hosts/framework/configuration.nix
          ./hosts/framework/hardware-configuration.nix
          ./init/disko.nix
          ./init/filesystem.nix
          nixos-hardware.nixosModules.framework-13-7040-amd
          inputs.disko.nixosModules.disko
          inputs.hjem.nixosModules.hjem
          inputs.home-manager.nixosModules.home-manager
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.nix-flatpak.nixosModules.nix-flatpak

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bak";
            hm.imports = [
              ./base/home.nix
              ./hosts/framework/home.nix
            ];
          }
        ];
      };

      installer = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          inputs.disko.nixosModules.disko
          ./base/users.nix
          ./hosts/installer/configuration.nix
          ./hosts/installer/hardware-configuration.nix
          ./init/disko.nix
          ./init/filesystem.nix
        ];
      };

      galith = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/galith/configuration.nix
          ./hosts/galith/hardware-configuration.nix
          #	  home-manager.nixosModules.home-manager {
          #	    home-manager.useGlobalPkgs = true;
          #	    home-manager.useUserPackages = true;
          #	    home-manager.users.radioaddition = [ import ./hosts/galith/home.nix ];
          #	  }
        ];
      };
    };

    homeConfigurations = {
      "aspirem" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {inherit inputs;};
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [
          ./hosts/aspirem/home.nix
        ];
      };

      "framework" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {inherit inputs;};
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [
          inputs.nix-flatpak.homeManagerModules.nix-flatpak
          ./hosts/framework/home.nix
          ./base/home.nix
        ];
      };
      "oriole" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {inherit inputs;};
        pkgs = nixpkgs.legacyPackages."aarch64-linux";
        modules = [
          ./base/home.nix
          {
            home = {
              stateVersion = "24.05";
              username = "nix-on-droid";
              homeDirectory = "/data/data/com.termux.nix/files/home/";
            };
          }
        ];
      };

      "galith" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {inherit inputs;};
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [
          ./hosts/galith/home.nix
        ];
      };

      "deck" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {inherit inputs;};
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [
          ./hosts/deck/home.nix
        ];
      };
    };
  };
}
