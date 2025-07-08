{ inputs, ... }: {
  imports = [ inputs.core.nixosModules.open-webui ];

  services.open-webui.enable = true;

}
