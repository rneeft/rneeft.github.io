---
# the default layout is 'page'
title: Machine setup
icon: fas fa-laptop
order: 4
---

# Safety first!

Lets make sure the ubuntu firewall ufw is enable and lets block everything

```bash
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

This script makes sure ufw is enabled and the default rules are applied, deny incoming, and allow outgoing.

# Tools

After installing Ubuntu the first time need to be done is opening a terminal and enter the update en upgrade command:

## Update & Upgrade

```bash
sudo apt update && sudo apt upgrade -y
```

## Flatpak

```bash
sudo apt install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

# Setting up git
Git is not comming from the general apt repository

```bash
sudo add-apt-repository ppa:git-core/ppa
sudo apt update
sudo apt install git

git config --global user.name "Rick Neeft"
git config --global user.email "rick.neeft@outlook.com"
```

# General Applications
```bash
sudo apt install gnome-shell-extension-manager gnome-tweaks nano dotnet-sdk-10.0
```

```bash
sudo snap install bruno cups discord kolourpaint pdfarranger spotify steam vivaldi
```

```bash
sudo snap install rider datagrip clion --classic
```

```bash
flatpak install flathub org.gnome.Boxes
```

[VSCode](https://code.visualstudio.com/Download#)

[Proton Authenticator](https://proton.me/authenticator)

[Docker engine](https://docs.docker.com/engine/install/ubuntu/)


## Installing Godot with icon + App Menu
Download Godot and place it in the correct folder. For me that is in my home folder/apps. 

- Download Godot from [GodotEngine.org](https://godotengine.org/download/linux/)
- Download the Godot logo from [here](/assets/img/godot.png)

Make the file executable.

```bash
chmod +x GODOT_APPLICATION_HERE
```

```bash
nano ~/.local/share/applications/godot.desktop
```

Add the following content

```ini
[Desktop Entry]
Version=1.0
Type=Application
Name=Godot Engine
Comment=Game Engine
Exec=/home/YOUR_USERNAME/apps/GODOT_APPLICATION_HERE
Icon=/home/YOUR_USERNAME/apps/godot.png
Terminal=false
Categories=Development;IDE;
StartupNotify=true
```

Make the file executable
```bash
sudo chmod +x ~/.local/share/applications/godot.desktop
```

You can now check whether Godot is available in the applications menu. If not you can check the following commands:

```bash
desktop-file-validate ~/.local/share/applications/godot.desktop
update-desktop-database ~/.local/share/applications
```

## Oh my posh

Follow the instructions on the [OhMyPos site](hhttps://ohmyposh.dev/docs/installation/linux)

```bash
sudo apt install curl unzip realpath dirname
```
```bash
curl -s https://ohmyposh.dev/install.sh | bash -s
```
```bash
oh-my-posh font install meslo
```

## Grub changes
```bash
sudo nano /etc/default/grub
```

Locate the `GRUB_CMDLINE_LINUX_DEFAULT` and change the line to `GRUB_CMDLINE_LINUX_DEFAULT=""` Save and then:

```bash
sudo update-grub
```