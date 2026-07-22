{ pkgs, ... }:
# Open WebUI runs as an on-demand Docker container (not managed by nix).
# Port 8080 conflicts with other apps, so it is NOT set to auto-start.
#
# First-time setup (creates the container once):
#  docker run -d \
#        --network=host \
#        -e OLLAMA_BASE_URL=http://127.0.0.1:11434 \
#        -v open-webui:/app/backend/data \
#        --name open-webui \
#        --restart no \
#        ghcr.io/open-webui/open-webui:main
#
# Daily usage:
#  docker start open-webui   # use it
#  docker stop open-webui    # done using it
{
  home.packages = with pkgs; [
    ollama
  ];
}

