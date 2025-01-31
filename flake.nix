{
  description = "spaghetti";

  inputs = {
    # Base inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    oldstable.url = "github:nixos/nixpkgs/nixos-24.05"; # Needed for nix-on-droid
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    lix = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Extra inputs
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };
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
    treefmt.url = "github:numtide/treefmt-nix";
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

  outputs =
    {
      hjem,
      home-manager,
      lix,
      nixos-hardware,
      nixpkgs,
      self,
      systems,
      treefmt,
      ...
    }@inputs:
    let
      eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});
      treefmtEval = eachSystem (pkgs: treefmt.lib.evalModule pkgs ./treefmt.nix);
    in
    {
      # Formatting
      formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);
      checks = eachSystem (pkgs: {
        formatting = treefmtEval.${pkgs.system}.config.build.check self;
      });

      devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShellNoCC {
        name = "radioaddition";
        meta.description = "devshell for managing this repo";

        NIX_CONFIG = "extra-experimental-features = nix-command flakes";

        packages = with nixpkgs.legacyPackages.x86_64-linux; [
          age
          deadnix
          fastfetch
          fish
          fzf
          git
          glow
          gum
          just
          neovim
          nh
          sbctl
          inputs.disko.packages.x86_64-linux.default
        ];
      };

      nixosConfigurations = {
        framework = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            unstable = import inputs.unstable {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
            gaming = import inputs.jovian-unstable {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          };
          modules = [
            ./base/DEs/gnome.nix
            #./base/gaming.nix # Disable unless I'm using it
            ./base/networking.nix
            ./base/programs/flatpak.nix
            ./base/programs/packages.nix
            ./base/security.nix
            ./base/shells/fish.nix
            ./base/system.nix
            ./base/users.nix
            ./hosts/framework/configuration.nix
            ./hosts/framework/hardware-configuration.nix
            ./init/disko.nix
            ./init/filesystem.nix
            hjem.nixosModules.hjem
            home-manager.nixosModules.home-manager
            lix.nixosModules.default
            nixos-hardware.nixosModules.framework-13-7040-amd

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
          specialArgs = { inherit inputs; };
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
          specialArgs = { inherit inputs; };
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
          extraSpecialArgs = { inherit inputs; };
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          modules = [ ./hosts/aspirem/home.nix ];
        };

        "framework" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit inputs; };
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          modules = [
            inputs.nix-flatpak.homeManagerModules.nix-flatpak
            ./hosts/framework/home.nix
            ./base/home.nix
          ];
        };
        "oriole" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit inputs; };
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
          extraSpecialArgs = { inherit inputs; };
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          modules = [ ./hosts/galith/home.nix ];
        };

        "deck" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit inputs; };
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          modules = [ ./hosts/deck/home.nix ];
        };
      };
    };
}
