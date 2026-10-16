{ pkgs, ... }:

let
  # nixpkgs wraps rustdesk with GST_PLUGIN_SYSTEM_PATH_1_0 pointing only at
  # gstreamer and gst-plugins-base, which *replaces* GStreamer's default search
  # path. Wayland screen capture needs `pipewiresrc`, and that element ships in
  # pipewire's own GStreamer plugin (libgstpipewire.so), not in those packages.
  # Without this, a remote session fails with "RustDesk could not load a
  # GStreamer component needed for screen capture (pipewire)".
  #
  # Re-wrap instead of rebuilding rustdesk: overrideAttrs would recompile the
  # whole Rust/Sciter application just to change wrapper arguments.
  rustdesk = pkgs.symlinkJoin {
    name = "rustdesk-${pkgs.rustdesk.version}-with-pipewire";
    paths = [ pkgs.rustdesk ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/rustdesk \
        --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : ${pkgs.pipewire}/lib/gstreamer-1.0
    '';
  };
in
{
  home.packages = [ rustdesk ];
}
