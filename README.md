# Linux-i915-Backlight-Control

This scripts allow controlling the backlight of an integrated Intel i915 graphics card (and possibly others) without the kernel driver.

I created these scripts because the i915 driver corrupted my memory on hibernate/resume. This bug was neither fixed on trunk kernel nor in Intel's latest driver sources. After lots of experimenting I had to set nomodeset on my kernel’s command line. With X.org's driver everything went well beside the control of the backlight, which was nonfunctional. The reason for this is, that with some/most? current Intel based displays you don't have a backlight control anymore. It gets emulated by the driver by switching the display on and off. This happens very fast of course and is recognized as a change in luminance.

What these scripts do is:
install.sh - Copies all systemd and initramfs scripts to their places and updates the init ramdisk.
intelBrightnessInitRamFS - As /sys/class/backlight is not writable, this script overlays it with a ramdisk at boot time and creates the files emulating an Intel backlight. This has the advantage that every program can control the backlight but you loose other backlights in the folder as it is overwritten. If you need access to other backlights too, try an overlaying filesystem. For me this was not necessary as the laptop did not have any other backlights.
intelBrightness_HookSysFS - This scripts watches the files, the previous script created and calls intelBrightness on change.

intelBrightness - Reads and writes the values from and to the graphic card's memory. If you want an easy solution only use this script. Warning I hardcoded the max brightness value my card had into the script. You should get the value while the kernel's driver is still in place from /sys/class/backlight/intel_backlight/max_brightness and modify the script.

setBrightnessOnBoot.service - Systemd service which sets the brightness on boot to 50%.

backupBrightnessOnSuspend.service - Systemd service which backs up the set brightness value on suspend/hibernate/etc.

restoreBrightnessOnResume.service - Systemd service which restores the brightness value on resume.

Normally I had been done here if it were not for a particular problem with my KDE installation. The KDE brightness controls did work but could not read the current value. I tried to find out from where they get them (definitely not from the brightness file) but I hit a dead end. I tried then to emulate DBus events on brightness change but it did not work out. Finally I gave up, disabled the KDE brightness hotkeys and used my own scripts. If you want to do the same, enter KDE settings, change the keyboard shortcuts for the +/- keys to "/usr/local/bin/intelBrightness" with the parameters "plus" and "minus".
Sadly there is now no display of the current brightness level anymore. As it worked out with every previous problem: Hey a new script!
intelBrightness_KDEEventListener - This has to be launched on KDE login, it watches for brightness level changes and displays a notification. 


