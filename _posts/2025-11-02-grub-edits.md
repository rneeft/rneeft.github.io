---
title: How to Show the GRUB Menu and Boot Information on Startup in Ubuntu
date: 2025-02-11 16:11:00 +0100
categories: [Grub, Ubuntu, Linux]
tags: [grub, ubuntu, linux, boot]     # TAG names should always be lowercase
---

When I boot up my computer, I like to see what’s actually happening. So instead of the splash screen I like to see the boot information. I also prefer to have the GRUB menu appear briefly, in case I need to make quick adjustments such as entering the UEFI menu or booting from an external device.

Start by opening a terminal and edit the GRUB configuration file with root privileges:

```bash
sudo nano /etc/default/grub
```

Find and update the following lines (or add them if they’re missing):

```ini
GRUB_TIMEOUT_STYLE=menu
GRUB_TIMEOUT=2
GRUB_CMDLINE_LINUX_DEFAULT=""
```
Let’s break down what each of these does:

- `GRUB_TIMEOUT_STYLE=menu`
  This ensures that the GRUB menu is displayed when your system boots.

- `GRUB_TIMEOUT=2`
  This sets a 2-second delay before automatically booting into Ubuntu. You’ll have just enough time to select another option if you need to.

- `GRUB_CMDLINE_LINUX_DEFAULT=""`
  By removing the default splash setting, this lets you see the detailed boot messages instead of the graphical splash screen.

The final step is it save and update grub. Save the file in nano with `CTRL + O`, `ENTER` and `CTRL + X` following by:

```bash
sudo update-grub
sudo reboot
``` 
