SERIES := 12.1
VERSION := YOG4PAS1N0
HASH         := 7be76f9310
BOOTIMG_FILE := cm-$(SERIES)-$(VERSION)-bacon-boot-debuggable.img
BOOTIMG_URL  := http://builds.cyngn.com/cyanogen-os/bacon/$(SERIES)-$(VERSION)-bacon/$(HASH)/$(BOOTIMG_FILE)

UPDATE_ZIP   := out/cm-unofficial-$(SERIES)-$(VERSION)-bacon-superuser.zip
SIGNED_ZIP   := out/cm-unofficial-$(SERIES)-$(VERSION)-bacon-signed-superuser.zip

# Light builds
LIGHT_UPDATE_ZIP   := out/cm-unofficial-12.0-superuser-light.zip
LIGHT_SIGNED_ZIP   := out/cm-unofficial-12.0-signed-superuser-light.zip

all: full light

light: $(LIGHT_SIGNED_ZIP).asc $(LIGHT_UPDATE_ZIP).asc
	@$(MAKE) .uploaded

full: $(SIGNED_ZIP).asc $(UPDATE_ZIP).asc
	@$(MAKE) .uploaded

out/index.html: $(wildcard out/*.zip out/*.asc) index.html.in makeindex.py
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

zip-light-base/system/xbin/su: zip-base/system/xbin/su
	python3 patch_su.py

$(LIGHT_UPDATE_ZIP): zip-light-base/system/xbin/su $(shell find zip-light-base -type f)
	rm -f $@
	cd zip-light-base && 7z a ../$@ .

$(LIGHT_SIGNED_ZIP): $(LIGHT_UPDATE_ZIP)
	java -jar signapk/signapk.jar signapk/testkey.x509.pem signapk/testkey.pk8  $< $@

clean:
	rm -f zip-base/boot.img
	rm -f zip-light-base/system/xbin/su
	$(NDK_BUILD) -C Superuser/Superuser clean
