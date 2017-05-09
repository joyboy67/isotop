all:
	@echo "Building OpenBSD iso and img"
	@echo "-------------------------"
	@./bin/prepare_iso.sh | tee build.log
	@./bin/build_site.sh | tee -a build.log
	@./bin/build_obsd_iso.sh | tee -a build.log
	@./bin/build_obsd_fs.sh | tee -a build.log
	@chmod a+rw CustomOBSD.iso

iso:
	@echo "Building OpenBSD iso"
	@echo "-------------------------"
	@./bin/prepare_iso.sh | tee build.log
	@./bin/build_site.sh | tee -a build.log
	@./bin/build_obsd_iso.sh | tee -a build.log
	@chmod a+rw CustomOBSD.iso

fs:
	@echo "Building OpenBSD fs"
	@echo "-------------------------"
	@./bin/prepare_iso.sh | tee build.log
	@./bin/build_site.sh | tee -a build.log
	@./bin/build_obsd_fs.sh | tee -a build.log
	@chmod a+rw CustomOBSD.iso

help:
	@echo "Usage: as root"
	@echo "make             	: build OpenBSD custom iso "
	@echo "make clean			: clean up build directories"
	@echo "make cleanfull		: clean up build directories completely"
	@echo "make iso		        : build iso only"
	@echo "make fs		        : build fs only"
	@echo "make download	    : download all packages"
	@echo "make cleanfull		: clean up build directories completely"

download:
	# replace download_pkgs with get_all_pkgs if on openbsd
	@./bin/download_pkgs.sh | tee -a build.log
	#@./bin/get_all_pkgs.sh | tee -a build.log

prepare:
	@echo "Setting up build environment"
	@echo "-------------------------"
	@./bin/prepare_iso.sh $(ARCH)

clean:
	@echo "Cleaning build environment"
	@echo "-------------------------"
	@rm -rf CustomOBSD.*
	@rm -rf install*-*
	@rm  sio2.img

