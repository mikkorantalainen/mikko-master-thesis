# Filename of (La)TeX file without extension. E.g. "book" for book.tex.
SOURCEBASE = webui
SOURCES    = osat/*.tex
#-----------------------------------------------------------------------
ALL	= $(SOURCEBASE).ps $(SOURCEBASE).pdf
PREVIEW = $(SOURCEBASE).dvi
PREVIEW2= $(SOURCEBASE).ps
#-----------------------------------------------------------------------
DIR	:= $(shell pwd)
DIRBASE := $(shell basename $(DIR))
TGZ	:= $(DIRBASE).tar.gz
#-----------------------------------------------------------------------
NOHYPHEN	= "No hyphenation patterns were loaded for"
RERUNBIB	= "No file.*\.bbl|Citation.*undefined"
RERUN		= "(There were undefined references|Rerun to get (cross-references|the bars) right)"
# output only lines that match following 'egrep' regexp. LaTeX tools dump all debug data to stdout so some filtering is needed
ERR		= "warn|error|^\\!|^\\?|^l\.|^[*][*]"
LATEXARGS	= -interaction=nonstopmode

all:	$(ALL)

ps: $(SOURCEBASE).ps

pdf: $(SOURCEBASE).pdf

preview: $(PREVIEW)
	@echo "Displaying preview. Press Q to quit..."
	xdvi $<

preview2: $(PREVIEW2)
	@echo "Displaying preview. Press Q to quit..."
	gv $<

clean:
	rm -f *.aux *.log *.bbl *.blg *.brf *.cb *.ind *.idx *.ilg  \
		*.inx *.ps *.dvi *.pdf *.toc *.out latex.fmt pdflatex.fmt

%.dvi:	%.tex
	@echo Creating $@ ...
	latex $(LATEXARGS) $< | egrep -i $(ERR) ; true
	egrep -q $(NOHYPHEN) $*.log && initex latex.ltx | egrep -i $(ERR) && latex $(LATEXARGS) $< | egrep -i $(ERR) ; true
	egrep -q $(RERUNBIB) $*.log && ( bibtex $* | egrep -i $(ERR) ; latex $(LATEXARGS) $< | egrep -i $(ERR)) ; true
	egrep -q $(RERUN) $*.log && ( latex $(LATEXARGS) $< | egrep -i $(ERR) ) ; true
	egrep -q $(RERUN) $*.log && ( latex $(LATEXARGS) $< | egrep -i $(ERR) ) || true
	@echo Done $@...

%.ps:	%.dvi
	@echo Creating $@ ...
	dvips $< -o $@ 2>&1 | egrep -i $(ERR) || true
	cp -f $@ preview.ps
	@echo Done $@...

#%.pdf:	%.dvi
#	dvipdf $<
#%.pdf:	%.ps %.dvi
#	ps2pdf $<
%.pdf:	%.tex %.dvi
	@echo Creating $@ ...
	pdflatex $(LATEXARGS) $* | egrep -i $(ERR)
	egrep -q $(NOHYPHEN) $*.log && pdfinitex pdflatex.ini && pdflatex $(LATEXARGS) $< | egrep -i $(ERR); true
	@echo Done $@...
	

dist: clean
	@echo "Creating $(TGZ) ..."
	( cd .. ; tar cvf - $(DIRBASE) | gzip -9 > $(TGZ) )

$(SOURCEBASE).tex : $(SOURCES)
	touch $@

loop:
	while true; do make -s; sleep 1; done
