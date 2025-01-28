{ pkgs, inputs, nixnvim, ... }: {
  nixpkgs.overlays = [
    nixnvim.overlays.default
  ];
}
