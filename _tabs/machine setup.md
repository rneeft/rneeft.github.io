---
# the default layout is 'page'
title: Machine setup
icon: fas fa-laptop
order: 4
---

# Ubuntu

My operating system is [Ubuntu](https://www.ubuntu.org). Some people hate it, some love it. For me it just gets the work done and my [Framework 13](https://frame.work/nl/en/laptop13) supports its beautifully.

## Post setup
After the initial installation is completed. I run the following command to install additional applications and configuration:

```bash
sudo apt update && sudo apt upgrade -y
```

```bash 
sudo apt install git curl ufw unzip build-essential software-properties-common gnome-tweaks gnome-shell-extension-manager nano dotnet-sdk-10.0 flatpak dosbox -y
```

```bash
git config --global user.name "Rick Neeft"
git config --global user.email "rickneeft@outlook.com"
```

```bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.gnome.Boxes
```

```bash
curl -sSL https://scripts.rickneeft.dev/ubuntu/ohmyposh.sh | bash
```

```bash
curl -sSL https://scripts.rickneeft.dev/ubuntu/install-godot.sh | bash
```

```bash
curl -sSL https://scripts.rickneeft.dev/ubuntu/docker.sh | sudo bash
```

```bash
curl -sSL https://aspire.dev/install.sh | bash
```


Then install the following application

- [Proton Authenticator App](https://proton.me/authenticator).
- [Steam](https://store.steampowered.com/about/)
- [Jetbrains Toolbox-App](https://www.jetbrains.com/toolbox-app/)
- [Spotify](https://open.spotify.com/download)

## GNOME extensions

- Blur my Shell
- Clipboard Indicator
- Color Picker
- Display Configuration Switcher

## Grub changes
I like to see the startup information in case my computer does not boot and my keyboard is unable. And to be honest, it looks cool!

```bash
sudo nano /etc/default/grub
```

Locate the `GRUB_CMDLINE_LINUX_DEFAULT` and change the line to `GRUB_CMDLINE_LINUX_DEFAULT=""` Save and then:

```bash
sudo update-grub
```

## Start point functionality
In the Windows Terminal you can type `start .` to open the explorer in the current folder. In Ubuntu you need to type `xdg-open .`. However you can add a function as shell alias to `~/.bashrc`.

```bash
start() {
    xdg-open "$@"
}
```

Optionally reload the bash file:

```bash
source ~/.bashrc
```

And now also in the Ubuntu shell you can type `start .` to open the explorer.

## Update firmware

```bash
fwupdmgr refresh --force
```

```bash
fwupdmgr get-updates
```

```bash
fwupdmgr update
```
