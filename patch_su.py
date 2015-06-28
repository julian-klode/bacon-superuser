#!/usr/bin/python3
with open("zip-base/system/xbin/su", "rb") as infile:
    with open("zip-light-base/system/xbin/su", "wb") as outfile:
        outfile.write(infile.read().replace(b"ro.debuggable", b"ro.secure\0\0\0\0"))
