{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    overte-src = {
        url = "github:lubosz/overte";
        flake = false;
        };
    nvtt-src = {
        url = "github:castano/nvidia-texture-tools";
        flake = false;
        };
    polyvox-src = {
        url = "git+https://bitbucket.org/volumesoffun/polyvox";
        flake = false;
        };

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, overte-src, flake-utils, nvtt-src, polyvox-src}: 
  flake-utils.lib.eachDefaultSystem (system:
  let pkgs = import nixpkgs { system= system; };
  in
  {
    packages = {
      overte = pkgs.stdenv.mkDerivation {
        name = "overte";
        nativeBuildInputs = with pkgs; [
          pkg-config
          cmake
          (python3.withPackages (pypy: with pypy;[
          distro
          ]))
          ninja
          zip
          git
        ];
        buildInputs = with pkgs; [
        glm
        nodejs
        qt5.full
        python3
imath
nlohmann_json
openexr
openvr
libopus
#polyvox
#quazip
SDL2
tbb
#vhacd
#polyvox
#webrtc
zlib
        ]++[
        self.packages.${system}.nvtt
        ];
        src = overte-src;
        cmakeFlags = [
        "-DOVERTE_SKIP_PREBUILD=1"
        ];
        OVERTE_USE_SYSTEM_QT="1";
      };
      nvtt = pkgs.stdenv.mkDerivation {
       name = "nvtt";
       src = nvtt-src; 
       nativeBuildInputs = with pkgs; [
         cmake
         ];
       buildInputs = with pkgs; [
         libpng
         libjpeg
         libtiff
         openxr-loader
         ];
      };
      polyvox = pkgs.stdenv.mkDerivation {
       name = "polyvox";
       src = polyvox-src;
       nativeBuildInputs = with pkgs; [
         ninja
         bash
         cmake
         git
       ];
       cmakeFlags = ["-GNinja"];
       buildInputs = with pkgs; [
         qt5.full
       ];
       };
    };
  });
}
