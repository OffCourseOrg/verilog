SUBDIRS:= $(wildcard questions/*/.)
VERILOG_SOURCES=$(wildcard *.v)
GITHUB_CSS=../github_markdown.css

all: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

.PHONY: all $(SUBDIRS)