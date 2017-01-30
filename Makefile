all:
	@echo "Building OpenBSD iso"
	@echo "-------------------------"
	@./bin/prepare_iso.sh | tee build.log
	@./bin/download_pkgs.sh | tee -a build.log
	@./bin/build_site.sh | tee -a build.log
	@./bin/build_obsd_iso.sh | tee -a build.log
	@./bin/build_obsd_fs.sh | tee -a build.log
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
	@rm -rf CustomOBSD.*
	@rm -rf install*-*

