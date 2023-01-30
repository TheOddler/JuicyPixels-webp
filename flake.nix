{
  description = "JuixyPixels WebP Dev Shell";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
    feedback.url = "github:NorfairKing/feedback";
  };

  outputs = { self, nixpkgs, flake-utils, feedback }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        hPkgs = pkgs.haskellPackages;
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            hPkgs.ghc
            hPkgs.haskell-language-server
            hPkgs.cabal-install
            pkgs.libwebp
            feedback.packages.${system}.default
          ];
          nativeBuildInputs = [
            pkgs.pkg-config
          ];
        };
      });
}
