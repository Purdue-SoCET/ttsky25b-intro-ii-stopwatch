# Use Bash shell
SHELL:=/bin/bash

# Export some variables
export PROJ_ROOT?=$(shell pwd)
export PDK_ROOT?=$(HOME)/ttsetup/pdk
export PDK?=sky130A
export LIBRELANE_TAG?=2.4.2

# Check if tools directories exist
.PHONY: check_tools
check_tools:
	@if [ ! -d ~/ttsetup ] || [ ! -d tt ]; then \
		echo -e "Error: Hardening tools are not set up! Please run \"make setup\""; \
		exit 1; \
	fi

# Setup tools for project hardening
.PHONY: setup
setup: veryclean
	@git clone https://github.com/TinyTapeout/tt-support-tools tt &&\
	mkdir ~/ttsetup &&\
	python3 -m venv ~/ttsetup/venv &&\
	source ~/ttsetup/venv/bin/activate &&\
	pip install -r $(PROJ_ROOT)/tt/requirements.txt &&\
	pip install librelane==$(LIBRELANE_TAG) &&\
	deactivate &&\
	echo -e "\nSetup complete!!\n"

# Harden project
.PHONY: harden
harden: check_tools
	@source ~/ttsetup/venv/bin/activate &&\
	./tt/tt_tool.py --create-user-config &&\
	./tt/tt_tool.py --harden &&\
	./tt/tt_tool.py --print-warnings &&\
	deactivate

# Export hardened design to a PNG file
.PHONY: gds_image
gds_image: check_tools
	@source ~/ttsetup/venv/bin/activate &&\
	./tt/tt_tool.py --create-png &&\
	deactivate &&\
	mkdir -p gds_images &&\
	mv gds_render.png ./gds_images &&\
	rm -rf gds_render_preview*

# View design in OpenROAD GUI
.PHONY: gds_view_openroad
gds_view_openroad: check_tools
	@source ~/ttsetup/venv/bin/activate &&\
	./tt/tt_tool.py --open-in-openroad &&\
	deactivate

# View design in KLayout
.PHONY: gds_view_klayout
gds_view_klayout: check_tools
	@source ~/ttsetup/venv/bin/activate &&\
	./tt/tt_tool.py --open-in-klayout &&\
	deactivate

# Remove any temporary run files
.PHONY: clean
clean:
	@rm -rf src/config_merged.json src/user_config.json &&\
	rm -rf src/runs

# Delete runs AND tool directories
.PHONY: veryclean
veryclean: clean
	@rm -rf tt &&\
	rm -rf ~/ttsetup