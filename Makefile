# Filename of (La)TeX file without extension. E.g. "book" for book.tex.
SOURCEBASE = webui
SOURCES    = osat/[a-z]*.tex bibliography.bib gradu2.cls Makefile
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
FLAGS		= "-A1"
#FLAGS		=
ERR		= "warn|error|^\\!|^\\?|^l\.|^[*][*]"
LATEXARGS	= -interaction=nonstopmode

all:	$(ALL)

extra: $(ALL) $(SOURCEBASE)-alt.pdf

remake:
	make -s almost-clean all

almost-clean:
	rm -f *.dvi *.ps *.pdf

ps: $(SOURCEBASE).ps

pdf: $(SOURCEBASE).pdf

preview: $(PREVIEW)
	@echo "Displaying preview. Press Q to quit..."
	xdvi -bg white $<

preview2: $(PREVIEW2)
	@echo "Displaying preview. Press Q to quit..."
	gv $<

clean:
	rm -f $(SOURCEBASE).aux $(SOURCEBASE).lof $(SOURCEBASE).lot $(SOURCEBASE).log \
		$(SOURCEBASE).bbl $(SOURCEBASE).blg $(SOURCEBASE).brf $(SOURCEBASE).cb \
		$(SOURCEBASE).ind $(SOURCEBASE).idx $(SOURCEBASE).ilg $(SOURCEBASE).inx \
		$(SOURCEBASE).ps $(SOURCEBASE).dvi $(SOURCEBASE).pdf $(SOURCEBASE).toc \
		$(SOURCEBASE).out latex.fmt pdflatex.fmt

%.dvi:	%.tex
	@echo === Creating: $@
	latex $(LATEXARGS) $< > /dev/null ; true
	egrep -q $(NOHYPHEN) $*.log && initex latex.ltx | egrep -i $(FLAGS) $(ERR) && latex $(LATEXARGS) $< | egrep -i $(FLAGS) $(ERR) ; true
	egrep -q $(RERUNBIB) $*.log && ( bibtex $* | egrep -i $(FLAGS) $(ERR) ; latex $(LATEXARGS) $< | egrep -i $(FLAGS) $(ERR)) ; true
	egrep -q $(RERUN) $*.log && ( latex $(LATEXARGS) $< | egrep -i $(FLAGS) $(ERR) ) ; true
	egrep -q $(RERUN) $*.log && ( latex $(LATEXARGS) $< | egrep -i $(FLAGS) $(ERR) ) || true
	@echo ======= Done: $@

%.ps:	%.dvi
	@echo === Creating: $@
	dvips $< -o $@ 2>&1 | egrep -i $(FLAGS) $(ERR) || true
	@echo ======= Done: $@

%-alt.pdf: %.dvi
	@echo === Creating: $@
	dvipdf -sPAPERSIZE=a4 $< $@
	@echo ======= Done: $@

%.pdf:	%.tex %.dvi
	@echo === Creating: $@
	pdflatex $(LATEXARGS) $* | egrep -i $(FLAGS) $(ERR)
	egrep -q $(NOHYPHEN) $*.log && pdfinitex pdflatex.ini && pdflatex $(LATEXARGS) $< | egrep -i $(FLAGS) $(ERR); true
	egrep -q $(RERUN) $*.log && ( pdflatex $(LATEXARGS) $< | egrep -i $(FLAGS) $(ERR) ) || true
	@echo ======= Done: $@
	

dist: clean
	@echo "Creating $(TGZ) ..."
	-svnversion . > VERSION
	( cd .. ; tar cvf - $(DIRBASE) | gzip -9 > $(TGZ) )
	-rm -f VERSION

$(SOURCEBASE).tex : $(SOURCES)
	touch $@

loop:
	while true; do make -s; sleep 1; done

fast-loop:
	while true; do make -s $(SOURCEBASE).dvi; sleep 1; done
