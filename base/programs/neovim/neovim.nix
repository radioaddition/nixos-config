{ pkgs, inputs, ... }: {
  nixpkgs.overlays = [
    nixnvim.overlays.default
  ];
}
