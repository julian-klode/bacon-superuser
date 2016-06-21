Integrated Superuser for the OnePlus One
========================================
This generates

1. an update zip that flashes a debuggable boot image and a su
   binary to a OnePlus One. (full)
2. an update zip that flashes a su binary integrating with the Superuser in
   CM settings that ignores the ro.debuggable settings. (light)

Comparison

| Item                   | Full | Light |
| ---------------------- | ---- | ----- |
| Integrated in settings | Yes  | Yes   |
| Has boot.img           | Yes  | No    |
| adb root               | Yes  | No    |

Building
--------
Make sure to initialize and update the submodules first. Then run

    make full     to build the update zip with a boot.img
    make light    to build the update zip without a boot.img

This will also try to upload the resulting binaries to my page which will fail.

Disclaimer
----------
This project is in no way affiliated or endorsed by Cyanogen, Inc. or
OnePlus.

License & Origin information
----------------------------
The files in signapk/ are part of the Android Open Source Project.

    Files: zip-base/META-INF/com/google/android/update-binary
    Origin: CM11S, AOSP
     The file is probably part of AOSP as well. It was taken from the CM 11S
     update zip.

    Files: zip-base/META-INF/com/google/android/updater-script
           zip-base/file_contexts
           zip-light-base/META-INF/com/google/android/updater-script
           zip-light-base/file_contexts
    Origin: CM11, CM11S
     These files are derived from the official 11S firmware update zip and the CM11
     M8 update zip. The derived parts consist only of a few lines and are most
     likely not protected by copyright.

    Files: zip-base/system/xbin/su
    Source: https://github.com/koush/Superuser
    Origin: CM11 M8
     Extracted from CyanogenMod 11 M8

The boot image shipped in the full zip file is the debuggable boot image
shipped by CyanogenMod. You can find the source for the kernel contained in it:

http://github.com/CyanogenMod/android_device_oneplus_bacon

All other files are Copyright (C) 2014, 2015 Julian Andres Klode <jak@jak-linux.org>
and licensed under the terms of the Apache license, version 2.0.

