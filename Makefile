setup:
	pip install --user --upgrade mkdocs
	pip install --user --upgrade mkdocs-material
	pip install --user --upgrade pygments
	pip install --user --upgrade pymdown-extensions

serve:
	mkdocs serve
