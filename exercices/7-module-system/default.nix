{ pkgs, lib, config, ... }: {

  options = {
    scripts.output = lib.mkOption {
      type = lib.types.package;
    };

    scripts.geocode = lib.mkOption {
      type = lib.types.package;
    };

    requestParams = lib.mkOption {
      type = lib.types.listOf lib.types.str;
    };

    map = {
      zoom = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = 10;

        center = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = "switzerland";
        };
      };
    };
  };



  config = {
    scripts.geocode = pkgs.writeShellApplication {
      name = "geocode";
      runtimeInputs = with pkgs; [ curl jq ];
      text = ''exec ${./geocode.sh} "$@"'';
    };

    scripts.output = pkgs.writeShellApplication {
      name = "map";
      runtimeInputs = with pkgs; [ curl feh ];
      text = ''
        ${./map.sh} ${lib.concatStringsSep " "
          config.requestParams} | feh -
      '';
    };

    requestParams = [
      "size=640x640"
      "scale=2"
      (lib.mkIf (config.map.zoom != null)
        "zoom=${toString config.map.zoom}")
      (lib.mkIf (config.map.center != null)
        "center=\"$(${config.scripts.geocode}/bin/geocode ${
          lib.escapeShellArg config.map.center
        })\"")
    ];
  };

}
