{
  description = "spaghetti";

  inputs = {
    # Base inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-26.05";
    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.lix.follows = "lix";
    };
    flake-compat = {
      url = "git+https://git.lix.systems/lix-project/flake-compat";
      # Optional, this repo's flake.nix just imports their default.nix, so this skips a step
      flake = false;
    };

    # Extra inputs
    deploy-rs.url = "github:serokell/deploy-rs";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    menu = {
      url = "github:/llakala/menu";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jovian = {
      url = "github:jovian-experiments/jovian-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.nixpkgs.follows = "jovian-ref";
    };
    # In case normal unstable breaks
    # jovian-ref.url = "github:nixos/nixpkgs/8f3e1f807051e32d8c95cd12b9b421623850a34d";
    treefmt.url = "github:numtide/treefmt-nix";
    neovim.url = "https://codeberg.org/radioaddition/neovim/archive/main.tar.gz";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    programsdb = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      deploy-rs,
      disko,
      lix,
      lix-module,
      nixos-hardware,
      nixpkgs,
      self,
      sops-nix,
      systems,
      treefmt,
      ...
    }@inputs:
    let
      pkgs = import nixpkgs { inherit system; };
      system = "x86_64-linux";
      eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system});
      treefmtEval = eachSystem (pkgs: treefmt.lib.evalModule pkgs ./treefmt.nix);
      deployPkgs = import nixpkgs {
      inherit system;
      overlays = [
        deploy-rs.overlays.default
        (self: super: { deploy-rs = { inherit (pkgs) deploy-rs; lib = super.deploy-rs.lib; }; })
      ];
    };

    in
    {
      # Formatting
      formatter = eachSystem (pkgs: treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.wrapper);
      # checks = eachSystem (pkgs: {
      #   formatting = treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.check self;
      # });

      devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShellNoCC {
        name = "radioaddition";
        meta.description = "devshell for managing this repo";

        NIX_CONFIG = ''
          extra-experimental-features = nix-command flakes
          deprecated-features = broken-string-indentation or-as-identifier
        '';

        packages = with nixpkgs.legacyPackages.x86_64-linux; [
          age
          atuin
          deadnix
          eza
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
          starship
          yazi
          zoxide
        ];
      };

      deploy.nodes = {
        galith = {
          hostname = "galith.dory-gondola.ts.net";
          profiles.system = {
            user = "root";
            sshUser = "radioaddition";
            path = deployPkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations.galith;
          };
        };
      };
      deploy.sudo = "run0 -i";
      checks = builtins.mapAttrs (_system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

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
            ./base/DEs/gnome.nix
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
            disko.nixosModules.disko
            lix-module.nixosModules.default
            nixos-hardware.nixosModules.framework-13-7040-amd
            sops-nix.nixosModules.sops
          ];
        };

        installer = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
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
            ./base/DEs/gnome.nix
            ./base/gaming.nix
            ./base/networking.nix
            ./base/packages/flatpak.nix
            ./base/packages/nix.nix
            ./base/security.nix
            ./base/shells/fish.nix
            ./base/system.nix
            ./base/users.nix
            ./init/disko.nix
            ./init/filesystem.nix
            disko.nixosModules.disko
            lix-module.nixosModules.default
            nixos-hardware.nixosModules.framework-13-7040-amd
            sops-nix.nixosModules.sops
          ];
        };
      };
    };
}
