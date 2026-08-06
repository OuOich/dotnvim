final: prev: {
  unocss-language-server =
    let
      pname = "unocss-language-server";
      version = "0.1.9";

      src = prev.fetchFromGitHub {
        owner = "xna00";
        repo = pname;
        rev = "v${version}";
        hash = "sha256-t4Qa1atVXB1EZRdJ0eDzeoYsuIzNE5sLMbLZp45EKKE=";
      };
    in
    prev.stdenvNoCC.mkDerivation {
      inherit pname version src;

      nativeBuildInputs = [
        prev.nodejs
        prev.pnpm
        prev.pnpmConfigHook
        prev.makeWrapper
      ];

      prePnpmInstall = "";

      pnpmDeps = prev.fetchPnpmDeps {
        inherit pname version src;
        inherit (prev) pnpm;
        prePnpmInstall = "";
        fetcherVersion = 3;
        hash = "sha256-LPjvcOy8qLITdIz+6ZPPKQSlHbUjwCb8JTAM3MqRgUs=";
      };

      buildPhase = /* bash */ ''
        runHook preBuild
        pnpm run build
        runHook postBuild
      '';

      postBuild = /* bash */ ''
        pnpm prune --prod
      '';

      installPhase = /* bash */ ''
        runHook preInstall

        mkdir -p $out/bin
        mkdir -p $out/lib/${pname}

        cp -r out $out/lib/${pname}/
        cp -r node_modules $out/lib/${pname}/

        makeWrapper ${prev.nodejs}/bin/node \
          $out/bin/unocss-language-server \
          --set NODE_PATH $out/lib/${pname}/node_modules \
          --add-flags $out/lib/${pname}/out/server.js

        runHook postInstall
      '';

      meta = {
        description = "UnoCSS language server";
        homepage = "https://github.com/xna00/unocss-language-server";
        license = prev.lib.licenses.mit;
        mainProgram = pname;
      };
    };
}
