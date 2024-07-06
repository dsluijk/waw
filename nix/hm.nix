self: {
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (lib) types;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption mkEnableOption;

  cfg = config.programs.waw;
in {
  imports = [self.inputs.ags.homeManagerModules.default];

  options.programs.waw = {
    enable = mkEnableOption "waw";

    package = mkOption {
      description = "the package containing the configuration to use";
      type = types.package;
      default = self.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
  };

  config = mkIf cfg.enable {
    programs.ags.enable = true;

    systemd.user.services.waw = {
      Unit = {
        Description = "Wacky AGS Widgets";
        After = ["graphical-session.target"];
      };

      Service = {
        ExecStart = "${config.programs.ags.finalPackage}/bin/ags -c ${cfg.package}/index.js -b waw";
        Restart = "always";
        RestartSec = "100ms";
      };

      Install.WantedBy = ["default.target"];
    };
  };
}
