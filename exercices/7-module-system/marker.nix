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

  userType = lib.types.submodule {
    options = {
      departure = lib.mkOption {
        type = markerType;
        default = { };
      };
    };
  };

in
{

  options = {
    users = lib.mkOption {
      type = lib.types.attrsOf userType;
    };
    map.markers = lib.mkOption {
      type = lib.types.listOf markerType;
    };
  };

  config = {

    map.markers = lib.filter
      (marker: marker.location != null)
      (lib.concatMap
        (user: [
          user.departure
        ])
        (lib.attrValues config.users));

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
