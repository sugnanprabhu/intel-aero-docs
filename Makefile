DEST ?= /tmp/intel-aero-docs

build:
	mkdocs build

setup:
	pip install --user --upgrade mkdocs
	pip install --user --upgrade mkdocs-material
	pip install --user --upgrade pygments
	pip install --user --upgrade pymdown-extensions
	@echo -e "\n\n###########################################################"
	@echo Configuration done
	@echo
	@echo export DEST to the appropriate place before calling deploy
	@echo otherwise site will be installed at /tmp/intel-aero-docs

serve:
	mkdocs serve

publish deploy: build
	rsync -avz --delete site/ $(DEST)
