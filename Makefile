VERSION := XNPH30O
BOOTIMG_FILE := cm-11.0-$(VERSION)-bacon-boot-debuggable.img
BOOTIMG_URL  := http://dist01.slc.cyngn.com/factory/bacon/$(BOOTIMG_FILE)

UPDATE_ZIP   := out/cm-unofficial-11.0-$(VERSION)-bacon-superuser.zip
SIGNED_ZIP   := out/cm-unofficial-11.0-$(VERSION)-bacon-signed-superuser.zip

.uploaded: $(SIGNED_ZIP).asc $(UPDATE_ZIP).asc
	sitecopy -u cm
	touch $@

all: $(SIGNED_ZIP).asc $(UPDATE_ZIP).asc .uploaded

$(BOOTIMG_FILE):
	wget $(BOOTIMG_URL)

zip-base/boot.img: $(BOOTIMG_FILE)
	cp $(BOOTIMG_FILE) zip-base/boot.img

$(UPDATE_ZIP): zip-base/boot.img
	rm -f $(UPDATE_ZIP)
	cd zip-base && 7z a ../$(UPDATE_ZIP) .

$(SIGNED_ZIP): $(UPDATE_ZIP)
	java -jar signapk/signapk.jar signapk/testkey.x509.pem signapk/testkey.pk8  $(UPDATE_ZIP) $(SIGNED_ZIP)

%.zip.asc: %.zip
	gpg -abs $<
