#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Starting Rick machine bootstrap..."

#############################################
# SYSTEM UPDATE
#############################################

sudo apt update && sudo apt upgrade -y

#############################################
# CORE TOOLS
#############################################

sudo apt install -y \
  curl \
  ufw \
  unzip \
  build-essential \
  software-properties-common \
  gnome-tweaks \
  gnome-shell-extension-manager \
  nano \
  jq

#############################################
# GIT CONFIG
#############################################
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt update
sudo apt install -y git

git config --global user.name "Rick Neeft"
git config --global user.email "rickneeft@outlook.com"

#############################################
# FLATPAK (ONLY GNOME BOXES)
#############################################

sudo apt install -y flatpak

flatpak remote-add --if-not-exists flathub \
  https://flathub.org/repo/flathub.flatpakrepo

flatpak install -y flathub org.gnome.Boxes || true

#############################################
# SNAP APPS
#############################################

sudo snap install bruno
sudo snap install cups
sudo snap install discord
sudo snap install kolourpaint
sudo snap install pdfarranger
sudo snap install spotify
sudo snap install steam
sudo snap install vivaldi

sudo snap install rider --classic
sudo snap install datagrip --classic
sudo snap install clion --classic

#############################################
# DOTNET
#############################################

sudo apt install -y dotnet-sdk-10.0 || true

#############################################
# OH MY POSH (USER LOCAL)
#############################################

if ! command -v oh-my-posh >/dev/null 2>&1; then
  curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin
fi

#############################################
# DOCKER INSTALL (OFFICIAL REPO)
#############################################

if ! command -v docker >/dev/null 2>&1; then
  echo "🐳 Installing Docker..."

  sudo install -m 0755 -d /etc/apt/keyrings

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo tee /etc/apt/keyrings/docker.asc > /dev/null

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
    https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt update

  sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

  sudo usermod -aG docker "$USER"
fi

#############################################
# GODOT (DYNAMIC LATEST MONO LINUX BUILD)
#############################################

GODOT_DIR="$HOME/apps/godot"
mkdir -p "$GODOT_DIR"

echo "⬇️ Fetching latest Godot Mono release..."

API_URL="https://api.github.com/repos/godotengine/godot/releases/latest"

DOWNLOAD_URL=$(curl -s "$API_URL" | jq -r \
  '.assets[] | select(.name | test("mono.*linux.*x86_64.*zip")) | .browser_download_url' | head -n 1)

if [ -z "$DOWNLOAD_URL" ] || [ "$DOWNLOAD_URL" = "null" ]; then
  echo "❌ Could not find Godot Mono Linux release"
  exit 1
fi

curl -L "$DOWNLOAD_URL" -o /tmp/godot.zip
unzip -o /tmp/godot.zip -d "$GODOT_DIR"

GODOT_BIN=$(find "$GODOT_DIR" -type f -name "Godot_v*_mono*" | head -n 1)

chmod +x "$GODOT_BIN"
ln -sf "$GODOT_BIN" "$GODOT_DIR/godot"

#############################################
# GODOT DESKTOP ENTRY
#############################################

mkdir -p ~/.local/share/applications

cat > ~/.local/share/applications/godot.desktop <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Godot Engine
Comment=Game Engine
Exec=$HOME/apps/godot/godot
Icon=$HOME/apps/godot/godot.png
Terminal=false
Categories=Development;IDE;
StartupNotify=true
EOF

chmod +x ~/.local/share/applications/godot.desktop

#############################################
# GODOT ICON DOWNLOAD
#############################################

curl -L https://www.rickneeft.dev/assets/img/godot.png \
  -o "$GODOT_DIR/godot.png"

#############################################
# DONE
#############################################

echo "✅ Bootstrap completed successfully"