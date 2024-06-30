self: {
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkMerge types;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption mkEnableOption literalExpression;

  cfg = config.programs.waw;
in {
  imports = [inputs.ags.homeManagerModules.default];

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
    # services.gvfs.enable = true;

    systemd.user.services.waw = {
      Unit = {
        Description = "Wacky Ags Widgets";
        After = ["graphical-session.target"];
      };

      Service = {
        ExecStart = "${config.programs.ags.finalPackage}/bin/ags -c ${cfg.package}/index.js";
        Restart = "always";
        RestartSec = "10";
      };

      Install.WantedBy = ["default.target"];
    };
  };
  # (mkMerge [
  #   (mkIf (cfg.configDir != null) {
  #     xdg.configFile."ags".source = cfg.configDir;
  #   })
  #   (mkIf (cfg.package != null) (
  #     let
  #       path = "/share/com.github.Aylur.ags/types";
  #       pkg = cfg.package.override {
  #         extraPackages = cfg.extraPackages;
  #         buildTypes = true;
  #       };
  #     in
  #     {
  #       programs.ags.enable = true;
  #       home.packages = [ pkg ];
  #       home.file.".local/${path}".source = "${pkg}/${path}";
  #     }
  #   ))
  # ]);
}
