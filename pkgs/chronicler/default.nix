{
  appimageTools,
  fetchurl,
  makeDesktopItem,
  stdenv,
  writeShellApplication,
  wayland,

  # this is just a hack so this can be used easily before being merged into nur
  allowUnfreeLicense ? false,
  fixWebkit ? false,
  fixWayland ? false,
}:

let
  name = "chronicler";
  version = "0.51.6";

  chronicler-unwrapped = appimageTools.wrapType2 {
    pname = name;
    version = "${version}-alpha";
    src = fetchurl {
      url = "https://github.com/mak-kirkland/chronicler/releases/download/v${version}-alpha/Chronicler_${version}_amd64.AppImage";
      sha256 = "sha256-fcz3iG0aauvcJAgR8rcw1BTZmchB/t9/M+aCPoNu9+8=";
    };
  };

  wrapper-script = writeShellApplication {
    name = name;
    text = ''
      export WEBKIT_DISABLE_DMABUF_RENDERER=${if fixWebkit then "1" else ""}
      export LD_PRELOAD=${if fixWayland then wayland + "/lib/libwayland-client.so" else ""}
      exec ${chronicler-unwrapped}/bin/chronicler
    '';
  };
in
stdenv.mkDerivation {
  name = name;
  buildCommand =
    let
      desktop-entry = makeDesktopItem {
        name = name;
        desktopName = name;
        exec = "${wrapper-script}/bin/${name} %f";
        terminal = false;
      };
    in
    ''
        mkdir -p $out/bin
        cp ${wrapper-script}/bin/${name} $out/bin
      	mkdir -p $out/share/applications
      	cp ${desktop-entry}/share/applications/${name}.desktop $out/share/applications
    '';

  meta = {
    description = "a free, offline worldbuilding tool built for writers, novelists, and tabletop RPG game masters";
    homepage = "https://chronicler.pro/";
    license = {
      fullName = "PolyForm Shield License 1.0.0";
      url = "https://polyformproject.org";
      free = allowUnfreeLicense;
      redistributable = true;
    };
    mainProgram = "chronicler";
    platforms = [ "x86_64-linux" ];
  };

  dontBuild = true;
}
