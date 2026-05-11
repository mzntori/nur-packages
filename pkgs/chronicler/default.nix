{
  appimageTools,
  fetchurl,
  writeShellScriptBin,
  wayland,

  fixWebkit ? false,
  fixWayland ? false,
}:

let
  version = "0.51.4";

  chronicler-unwrapped = appimageTools.wrapType2 {
    pname = "chronicler";
    version = "${version}-alpha";
    src = fetchurl {
      url = "https://github.com/mak-kirkland/chronicler/releases/download/v${version}-alpha/Chronicler_${version}_amd64.AppImage";
      sha256 = "sha256-/hPVY954StH95cUyGj3su/VaXYLpsjjCpB8uu5ssh8g=";
    };
  };

  wrapper-script = ''
    export WEBKIT_DISABLE_DMABUF_RENDERER=${if fixWebkit then "1" else ""}
    export LD_PRELOAD=${if fixWayland then wayland + "/lib/libwayland-client.so" else ""}
    exec ${chronicler-unwrapped}/bin/chronicler
  '';
in

writeShellScriptBin "chronicler" wrapper-script
// {
  meta = {
    description = "a free, offline worldbuilding tool built for writers, novelists, and tabletop RPG game masters";
    homepage = "https://chronicler.pro/";
    license = {
      fullName = "PolyForm Shield License 1.0.0";
      url = "https://polyformproject.org";
    };
  };
}
