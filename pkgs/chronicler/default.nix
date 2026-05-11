{
  appimageTools,
  fetchurl,
  writeShellScriptBin,
  wayland,

  fixWebkit ? false,
  fixWayland ? false,
}:
let
  chronicler-unwrapped = appimageTools.wrapType2 {
    pname = "chronicler";
    version = "0.51.4-alpha";
    src = fetchurl {
      url = "https://github.com/mak-kirkland/chronicler/releases/download/v0.51.4-alpha/Chronicler_0.51.4_amd64.AppImage";
      sha256 = "sha256-/hPVY954StH95cUyGj3su/VaXYLpsjjCpB8uu5ssh8g=";
    };
  };
in
writeShellScriptBin "chronicler" ''
  export WEBKIT_DISABLE_DMABUF_RENDERER=${if fixWebkit then "1" else ""}
  export LD_PRELOAD=${if fixWayland then wayland + "/lib/libwayland-client.so" else ""}
  exec ${chronicler-unwrapped}/bin/chronicler
''
