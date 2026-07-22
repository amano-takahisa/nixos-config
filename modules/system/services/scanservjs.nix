{ pkgs, ... }:

{
  services.scanservjs.enable = true;

  # ScanSnap iX2400 (usb 0x05ca 0x03e3) isn't in upstream sane-backends yet
  # (https://gitlab.com/sane-project/backends/-/issues/838). Register it as a
  # fujitsu-backend device; untested whether the protocol actually matches.
  hardware.sane.backends-package = pkgs.sane-backends.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      echo "usb 0x05ca 0x03e3" >> $out/etc/sane.d/fujitsu.conf
    '';
  });

  # The udev rules shipped with sane-backends only grant the `scanner` group
  # access to known VID:PIDs, so this unrecognized device needs its own rule.
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="05ca", ATTR{idProduct}=="03e3", GROUP="scanner", MODE="0660"
  '';

  # NOTE: The backend reports a Letter-sized (215.8x279.364mm) max scan area
  # for this device, so scanservjs correctly hides A4 (210x297mm) from the
  # paper size picker. Confirmed by testing: forcing a larger scan area
  # still truncates the physical scan at ~279mm, so this is a real limit of
  # registering this unsupported device under the fujitsu backend, not a UI
  # bug. Do not override -y/--page-height limits here again.
}
