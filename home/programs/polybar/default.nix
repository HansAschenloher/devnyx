with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "polybar-themes";

 src = fetchFromGitHub {
    owner = "adi1090x";
    repo = "polybar-themes";
    rev = "46154c5283861a6f0a440363d82c4febead3c818";
    sha256 = "0lp1sqxzbc0w9df5jm0h7bkcdf94ahf4929vmf14y7yhbfy2llf3";
  };

  installPhase = ''
    source $stdenv/setup
    echo "Test"
    ./setup.sh
  '';
}
