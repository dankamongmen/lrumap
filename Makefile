.DELETE_ON_ERROR:
.PHONY: all preview test clean
# FIXME switch to test once we have binaries
.DEFAULT_GOAL:=preview

VPDF:=evince
VSVG:=rsvg-view

OUT:=out
DOCOUT:=out/doc
FIGOUT:=out/figures
PRO:=cs7260final
TEX:=doc/papers/$(PRO).tex
PDF:=$(DOCOUT)/$(PRO).pdf
PLOT:=$(notdir $(basename $(wildcard doc/figures/*.pl)))
IMG:=$(addsuffix .pdf,$(addprefix $(FIGOUT)/,$(PLOT)))

CFLAGS:=-O2 -W -Wall -Werror -Wextra -march=native -mtune=native

all: $(IMG) $(PDF) $(BIN)

$(DOCOUT)/%.pdf: $(TEX) doc/papers/%.bib $(IMG) $(MAKEFILES)
	@[ -d $(@D) ] || mkdir -p $(@D)
	pdflatex --output-directory $(@D) $<
	bibtex $(basename $@)
	pdflatex --output-directory $(@D) $<
	pdflatex --output-directory $(@D) $<

$(FIGOUT)/%.pdf: doc/figures/%.pl $(MAKEFILES)
	@[ -d $(@D) ] || mkdir -p $(@D)
	gnuplot $<

preview: test
	$(VPDF) $(PDF)

test: all
	# FIXME no binaries yet

clean:
	rm -rf $(OUT)
