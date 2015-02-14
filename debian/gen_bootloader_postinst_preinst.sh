#!/bin/sh

if ! [ -d ../boot ]; then
  printf "Can't find boot dir. Run from debian subdir\n"
  exit 1
fi

printf "#!/bin/sh\n" > raspberrypi-bootloader-nokernel.postinst
for FN in ../boot/* ../boot/*/*; do
  if ! [ -d "$FN" ]; then
    FN=${FN#../boot/}
    printf "rm -f /boot/$FN\n" >> raspberrypi-bootloader-nokernel.postinst
    printf "dpkg-divert --package rpikernelhack --remove --rename /boot/$FN\n" >> raspberrypi-bootloader-nokernel.postinst
    printf "sync\n" >> raspberrypi-bootloader-nokernel.postinst
  fi
done
printf "#DEBHELPER#\n" >> raspberrypi-bootloader-nokernel.postinst

printf "#!/bin/sh\n" > raspberrypi-bootloader-nokernel.preinst
printf "mkdir -p /usr/share/rpikernelhack/overlays\n" >> raspberrypi-bootloader-nokernel.preinst
printf "mkdir -p /boot/overlays\n" >> raspberrypi-bootloader-nokernel.preinst
for FN in ../boot/* ../boot/*/*; do
  if ! [ -d "$FN" ]; then
    FN=${FN#../boot/}
    printf "dpkg-divert --package rpikernelhack --divert /usr/share/rpikernelhack/$FN /boot/$FN\n" >> raspberrypi-bootloader-nokernel.preinst
  fi
done
printf "#DEBHELPER#\n" >> raspberrypi-bootloader-nokernel.preinst
