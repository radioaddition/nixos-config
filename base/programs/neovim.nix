{ pkgs, inputs, ... }: {
  imports = [ inputs.nvf.nixosModules.default ];
}
