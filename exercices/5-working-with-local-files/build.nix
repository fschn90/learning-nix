{ stdenv, lib }:
let
  fs = lib.fileset;
  sourceFiles =
    fs.difference
      ./.
      (fs.unions [
        (fs.maybeMissing ./result)
        (fs.fileFilter (file: file.hasExt "nix") ./.)
        ./npins
      ]);
in

fs.trace sourceFiles

  stdenv.mkDerivation
{
  name = "fileset";
  src = fs.toSource {
    root = ./.;
    fileset = sourceFiles;
  };
  postInstall = ''
    mkdir $out
    cp -v {hello,world}.txt $out
  '';
}

