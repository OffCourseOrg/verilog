SHELL:=/bin/bash

install:
	yarn add https://github.com/OffCourseOrg/netlistsvg-offcourse.git

uninstall:
	yarn remove netlistsvg-offcourse

reinstall: uninstall install

PHONY: install