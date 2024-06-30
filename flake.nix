{
  description = "Wacky AGS Widgets";

  inputs = {
    ags.url = "github:Aylur/ags";
    nixpkgs.follows = "ags/nixpkgs";
  };

  outputs = inputs @ {
    nixpkgs,
    self,
    ...
  }: let
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
