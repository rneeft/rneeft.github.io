---
# the default layout is 'page'
title: Machine setup
icon: fas fa-laptop
order: 4
---

# Ubuntu

My operating system is [Ubuntu](https://www.ubuntu.org). Some people hate it, some love it. For me it just gets the work done and my [Framework 13](https://frame.work/nl/en/laptop13) supports its beautifully.

## Autoinstall

The people at Canonical are making installing my setup really easy by automating the installation of Ubuntu; [autoinstall](https://canonical-subiquity.readthedocs-hosted.com/en/latest/intro-to-autoinstall.html). My autoinstall handles the default with some preinstalled packages, snap application and my user. It also setup my firewall from the start. The autoinstall I am using can be found in my scripts repository at https://scripts.rickneeft.dev/ubuntu/autoinstall.yaml. 


## Post setup
After the initial installation is completed. I run the following command to install additional applications and configuration:

```bash
git config --global user.name "Rick Neeft"
git config --global user.email "rickneeft@outlook.com"

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.gnome.Boxes

curl -sSL https://scripts.rickneeft.dev/ubuntu/ohmyposh.sh | bash

curl -sSL https://scripts.rickneeft.dev/ubuntu/install-godot.sh | bash

curl -sSL https://scripts.rickneeft.dev/ubuntu/docker.sh | sudo bash

curl -sSL https://aspire.dev/install.sh | bash
```

Then install the [Proton Authenticator App](https://proton.me/authenticator).

## GNOME extensions

- Blur my Shell
- Clipboard Indicator
- Color Picker
- Wiggle
- Logo Menu
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