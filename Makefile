all:
	@echo "Building OpenBSD iso"
	@echo "-------------------------"
	@./bin/prepare_iso.sh 
	@./bin/download_pkgs.sh 
	@./bin/build_site.sh 
	@./bin/build_obsd_iso.sh 
	@chmod a+rw CustomOBSD.iso

help:
	@echo "Usage: as root"
	@echo "make             	: build OpenBSD custom iso "
	@echo "make clean			: clean up build directories"
	@echo "make cleanfull		: clean up build directories completely"

prepare:
	@echo "Setting up build environment"
	@echo "-------------------------"
	@./bin/prepare_iso.sh $(ARCH)

clean:
	@echo "Cleaning build environment"
	@echo "-------------------------"
	@rm -rf CustomOBSD.iso
	@rm -rf install*-*

cleanfull:
	@echo "Cleaning entire build environment"
	@echo "-------------------------"
	@rm -rf CustomOBSD.iso
	@rm -rf install*

