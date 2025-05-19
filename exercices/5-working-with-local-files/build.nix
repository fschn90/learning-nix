{ stdenv, lib }:
let
  fs = lib.fileset;
  sourceFiles = fs.gitTracked ./.;
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
    cp -vr . $out
  '';
}
