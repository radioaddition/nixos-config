{
  pkgs,
  inputs,
  unstable,
  ...
}:
{
  disabledModules = [
    "services/misc/ollama.nix"
    "services/web-apps/nextjs-ollama-llm-ui.nix"
  ];
  imports = [
    "${inputs.unstable}/nixos/modules/services/misc/ollama.nix"
    "${inputs.unstable}/nixos/modules/services/web-apps/nextjs-ollama-llm-ui.nix"
  ];
  services.ollama = {
    enable = true;
    package = unstable.ollama;
    acceleration = "rocm";
    #rocmOverrideGfx = "11.0.2";
    #rocmOverrideGfx = "11.0.1";
    #rocmOverrideGfx = "11.0.0";
    #rocmOverrideGfx = "10.3.0";
    #rocmOverrideGfx = "9.4.2";
    #rocmOverrideGfx = "9.4.1";
    #rocmOverrideGfx = "9.4.0";
    #rocmOverrideGfx = "9.0.a";
    #rocmOverrideGfx = "9.0.8";
    #rocmOverrideGfx = "9.0.6";
    #rocmOverrideGfx = "9.0.0";
  };
}
