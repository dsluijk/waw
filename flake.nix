{
  description = "Wacky AGS Widgets";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    self,
    ...
  } @ inputs: let
    genSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "x86_64-linux"
    ];

    pkgs = genSystems (system: import nixpkgs {inherit system;});
  in {
    formatter = genSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    packages = genSystems (
      system: rec {
        default = pkgs.${system}.callPackage ./nix {
          inherit system inputs;
          version = "0.0.1";
        };

        waw = default;
      }
    );

    homeManagerModules.default = import ./nix/hm.nix self;

    apps = genSystems (system: {
      waw = {
        type = "app";
        program = self.packages.${system}.default;
      };
    });
  };
}
