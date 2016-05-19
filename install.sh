#!/bin/bash

if [[ "$EUID" -ne 0 ]]; then
  sudo "$0" $@
  exit 0
fi

echo installing required programs
apt-get install intel-gpu-tools -y

echo updating initramfs
cp intelBrightnessInitRamFS /etc/initramfs-tools/scripts/init-top/
update-initramfs -u

echo copying scripts
cp intelBrightness /usr/local/bin/
chmod +x /usr/local/bin/intelBrightness

cp intelBrightness_HookSysFS /usr/local/bin/
chmod +x /usr/local/bin/intelBrightness_HookSysFS

cp intelBrightness_HookDisplayKDE /usr/local/bin/
chmod +x /usr/local/bin/intelBrightness_HookDisplayKDE

echo installing backup and restore brightness scripts
cp setBrightnessOnBoot.service /etc/systemd/system/
systemctl enable /etc/systemd/system/setBrightnessOnBoot.service

cp backupBrightnessOnSuspend.service /etc/systemd/system/
systemctl enable /etc/systemd/system/backupBrightnessOnSuspend.service

cp restoreBrightnessOnResume.service /etc/systemd/system/
systemctl enable /etc/systemd/system/restoreBrightnessOnResume.service

echo installing SysFSEventListener
cp installBrightness_SysFSEventListener.service /etc/systemd/system/
systemctl enable /etc/systemd/system/installBrightness_SysFSEventListener.service

#echo installing HookDisplayKDE
#cp installBrightness_HookDisplayKDE.service /etc/systemd/user
#systemctl --user enable /etc/systemd/user/installBrightness_HookDisplayKDE.service

if ! grep -q "ALL ALL=NOPASSWD: /usr/local/bin/intelBrightness" "/etc/sudoers"; then
 echo "ALL ALL=NOPASSWD: /usr/local/bin/intelBrightness" >> /etc/sudoers
fi
