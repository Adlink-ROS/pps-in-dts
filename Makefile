DTS_FILE := adlink-pps-in
DEFAULT_LABEL := $(shell grep "^DEFAULT" /boot/extlinux/extlinux.conf | awk '{print $$2}')
$(warning DEFAULT_LABEL=$(DEFAULT_LABEL))

FDT_PATH := $(shell grep "^LABEL $(DEFAULT_LABEL)" -A5 /boot/extlinux/extlinux.conf | grep FDT | awk '{print $$2}')
$(warning FDT_PATH=$(FDT_PATH))

BACKUP_DTB := origin-backup.dtb

.PHONY: all
all: dtbo

dtbo:
	# compile dts to dtbo
	dtc -O dtb -o $(DTS_FILE).dtbo -@ $(DTS_FILE).dts

	# backup origin dtb
	sudo cp $(FDT_PATH) $(BACKUP_DTB)

	# merge origin dtb with new overlay, and generate a new dtb
	sudo fdtoverlay -i $(BACKUP_DTB) -o $(FDT_PATH) $(DTS_FILE).dtbo

restore:
	sudo cp -av $(BACKUP_DTB) $(FDT_PATH)

clean:
	rm -rf *.dtbo
