# Browser checks on this NixOS host

This host intentionally has no system `google-chrome` or `chromium`. The
Chromium bundled with oh-my-pi's browser prelude cannot resolve its shared
libraries on NixOS, so start Nixpkgs Chrome and connect over CDP instead.

Start it as a managed service on port 9222:

```bash
env NIXPKGS_ALLOW_UNFREE=1 nix-shell -p google-chrome --run \
  'google-chrome --headless=new --remote-debugging-port=9222 --user-data-dir="$HOME/.cache/omp-chrome"'
```

Use `--ozone-platform=wayland` instead of `--headless=new` to display a GUI
window. When needed, set `WAYLAND_DISPLAY=wayland-0` and
`XDG_RUNTIME_DIR=/run/user/1000` before the command.

oh-my-pi is configured with `browser.cdpUrl = http://127.0.0.1:9222` and saves
screenshots under `~/Pictures/omp-shots`:

```js
const tab = await browser.open({ name: "main", url: "http://localhost:3000" });
await tab.screenshot();
await browser.close({ all: true });
```

Start Chrome before calling `browser.open()`. `browser.close()` closes the
oh-my-pi connection, not the Chrome service; stop the service when finished.
For static page inspection, use the read tool without starting a browser.
