{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, utils, rust-overlay }:
    utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      {
        defaultApp = utils.lib.mkApp {
          drv = self.defaultPackage."${system}";
        };

        devShell = with pkgs; mkShell {
          buildInputs = [ rust-bin.stable.latest.default pre-commit rust-analyzer ];
          RUST_SRC_PATH = rustPlatform.rustLibSrc;

          shellHook = ''
            alias idot="dot -Gbgcolor=black -Gcolor=white -Ecolor=white -Efontcolor=white -Ncolor=white -Nfontcolor=white -Tpng | icat"
            alias odot="dot -Gbgcolor=black -Gcolor=white -Ecolor=white -Efontcolor=white -Ncolor=white -Nfontcolor=white -Tpng"
          '';               
        };
        
      });
}
