{ lib, ... }:

{
  options = {
    scripts.output = lib.mkOption {
      type = lib.types.lines;
    };
  };

  config = {
    scripts.output = ''
      ./maps.sh size=640x640 scale=2 | feh -
    '';
  };

}  
