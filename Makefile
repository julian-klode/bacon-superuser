VERSION := YNG1TAS0YL
BOOTIMG_FILE := cm-12.0-$(VERSION)-bacon-boot-debuggable.img
BOOTIMG_URL  := http://builds.cyngn.com/cyanogen-os/bacon/12.0-YNG1TAS0YL-bacon/2263178b74/$(BOOTIMG_FILE)

UPDATE_ZIP   := out/cm-unofficial-12.0-$(VERSION)-bacon-superuser.zip
SIGNED_ZIP   := out/cm-unofficial-12.0-$(VERSION)-bacon-signed-superuser.zip

# Light builds
NDK_BUILD    := $(HOME)/Downloads/android-ndk-r10/ndk-build
LIGHT_UPDATE_ZIP   := out/cm-unofficial-12.0-superuser-light.zip
LIGHT_SIGNED_ZIP   := out/cm-unofficial-12.0-signed-superuser-light.zip
LOCAL_CFLAGS := -DSQLITE_OMIT_LOAD_EXTENSION -DREQUESTOR=\\\"com.android.settings\\\" \
				-DREQUESTOR_PREFIX=\\\"com.android.settings.cyanogenmod.superuser\\\"

all: full light

light: $(LIGHT_SIGNED_ZIP).asc $(LIGHT_UPDATE_ZIP).asc
	@$(MAKE) .uploaded

full: $(SIGNED_ZIP).asc $(UPDATE_ZIP).asc
	@$(MAKE) .uploaded

out/index.html: $(wildcard out/*.zip out/*.asc)
	python3 makeindex.py | tidy -i -xml -utf8 > out/index.html

.uploaded: out/index.html
	sitecopy -u cm
	touch $@

$(BOOTIMG_FILE):
	wget $(BOOTIMG_URL)

zip-base/boot.img: $(BOOTIMG_FILE)
	cp $(BOOTIMG_FILE) zip-base/boot.img

$(UPDATE_ZIP): zip-base/boot.img
	rm -f $@
	cd zip-base && 7z a ../$@ .

$(SIGNED_ZIP): $(UPDATE_ZIP)
	java -jar signapk/signapk.jar signapk/testkey.x509.pem signapk/testkey.pk8  $< $@

%.zip.asc: %.zip
	gpg2 -abs $<

zip-light-base/system/xbin/su: $(shell find Superuser -type f)
	$(NDK_BUILD) -C Superuser/Superuser libs/armeabi/su LOCAL_CFLAGS="$(LOCAL_CFLAGS)"
	install -D -m755 Superuser/Superuser/assets/armeabi/su $@

$(LIGHT_UPDATE_ZIP): zip-light-base/system/xbin/su $(shell find zip-light-base -type f)
	rm -f $@
	cd zip-light-base && 7z a ../$@ .

$(LIGHT_SIGNED_ZIP): $(LIGHT_UPDATE_ZIP)
	java -jar signapk/signapk.jar signapk/testkey.x509.pem signapk/testkey.pk8  $< $@

clean:
	rm -f zip-base/boot.img
	rm -f zip-light-base/system/xbin/su
	$(NDK_BUILD) -C Superuser/Superuser clean
