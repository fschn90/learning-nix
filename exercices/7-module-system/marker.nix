{ pkgs, lib, config, ... }:
let
  markerType = lib.types.submodule {
    options = {
      location = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
    };
  };
in
{

  options = {
    map.markers = lib.mkOption {
      type = lib.types.listOf markerType;
    };
  };

  config = {

    map.markers = [
      { location = "new york"; }
    ];

    map.center = lib.mkIf
      (lib.length config.map.markers >= 1)
      null;

    map.zoom = lib.mkIf
      (lib.length config.map.markers >= 2)
      null;

    requestParams =
      let
        paramForMarker =
          builtins.map
            (marker: "$(${config.scripts.geocode}/bin/geocode ${
          lib.escapeShellArg marker.location})")
            config.map.markers;
      in
      [ "markers=\"${lib.concatStringsSep "|" paramForMarker}\"" ];
  };
}
