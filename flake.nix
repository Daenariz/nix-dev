{
  # The unstable branch of the NixOS/nixpkgs repository on GitHub.
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    core.url = "github:sid115/nix-core/develop";
    core.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }@inputs: {

    # Default overlay, for use in dependent flakes
    overlay = final: prev: { };

    # # Same idea as overlay but a list or attrset of them.
    overlays = { exampleOverlay = self.overlay; };

    # Default module, for use in dependent flakes. Deprecated, use nixosModules.default instead.
    #    nixosModule = { config, ... }: { options = {}; config = {}; };

    # Same idea as nixosModule but a list or attrset of them.
    #   nixosModules = { exampleModule = self.nixosModule; };

    # Used with `nixos-rebuild --flake .#<hostname>`
    # nixosConfigurations."<hostname>".config.system.build.toplevel must be a derivation
    nixosConfigurations.futro = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ ./configuration.nix ];
    };
  };
}
