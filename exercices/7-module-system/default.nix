{ pkgs, lib, config, ... }: {

  options = {
    scripts.output = lib.mkOption {
      type = lib.types.package;
    };

    requestParams = lib.mkOption {
      type = lib.types.listOf lib.types.str;
    };
  };



  config = {
    scripts.output = pkgs.writeShellApplication {
      name = "map";
      runtimeInputs = with pkgs; [ curl feh ];
      text = ''
        ${./map} ${lib.concatStringsSep " "
          config.requestParams} | feh -
      '';
    };

    requestParams = [
      "size=640x640"
      "scale=2"
    ];
  };

}
