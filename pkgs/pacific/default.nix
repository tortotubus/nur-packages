{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gnumake,
  gcc,
  openmpi,
  hdf5-mpi,
  zlib,
  xercesc,
  makeWrapper
}:

stdenv.mkDerivation {
  pname = "pacific";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "tortotubus";
    repo = "PacIFiC";
    rev = "2f26363b1f18bb4ca6bca9964b6d679b6fb0a777";
    hash = "sha256-aRdoKZGOr+nhRwuUHFytxhNSJo6QTKObnVwUqReCBYo=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    gcc
    cmake
    gnumake
    pkg-config
    makeWrapper
    (hdf5-mpi.override { mpi = openmpi; })
  ];

  buildInputs = [
    xercesc
    zlib
  ];

  propagatedBuildInputs = [
    xercesc
    zlib
    (hdf5-mpi.override { mpi = openmpi; })
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DUSE_SUBMODULES=ON"
    "-DOCTREE_BASILISK_PROVIDER=VENDORED"
  ];

  postFixup = ''
    for p in $out/bin/*; do
      [ -x "$p" ] || continue
      wrapProgram "$p" --prefix PATH : ${lib.makeBinPath [ openmpi ]}
    done
  '';

  meta = with lib; {
    description = "PacIFiC multiphysics toolkit";
    homepage = "https://github.com/tortotubus/PacIFiC";
    platforms = platforms.linux;
    license = licenses.mit; # set appropriately
    # mainProgram = "pacific"; # if there is a primary executable
  };
}
