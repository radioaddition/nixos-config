{
  description = "spaghetti";

  inputs = {
    # Base inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-25.05";
    oldstable.url = "github:nixos/nixpkgs/nixos-24.11"; # Needed for nix-on-droid
    lix = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat = {
      url = "git+https://git.lix.systems/lix-project/flake-compat";
      # Optional, this repo's flake.nix just imports their default.nix, so this skips a step
      flake = false;
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
    jovian = {
      url = "github:jovian-experiments/jovian-nixos";
      # inputs.nixpkgs.follows = "jovian-ref";
    };
    # In case normal unstable breaks
    jovian-ref.url = "github:nixos/nixpkgs/8f3e1f807051e32d8c95cd12b9b421623850a34d";
    treefmt.url = "github:numtide/treefmt-nix";
    neovim.url = "https://codeberg.org/radioaddition/neovim/archive/main.tar.gz";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
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
          inputs.disko.packages.x86_64-linux.default
          inputs.neovim.packages.x86_64-linux.default
          just
          nh
          sbctl
        ];
      };

      nixosConfigurations = {
        framework = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            stable = import inputs.stable {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
            gaming = import inputs.jovian-ref {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          };
          modules = [
            ./base/DEs/cosmic.nix
            ./base/gaming.nix
            ./base/networking.nix
            ./base/packages/flatpak.nix
            ./base/packages/nix.nix
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
            # lix.nixosModules.default
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
            home-manager.nixosModules.home-manager
            hjem.nixosModules.hjem
            ./base/users.nix
            ./base/aliases.nix
            ./hosts/installer/configuration.nix
            ./hosts/installer/hardware-configuration.nix
            ./init/disko.nix
            ./init/filesystem.nix
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "bak";
              hm.imports = [ ./base/home.nix ];
            }
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
