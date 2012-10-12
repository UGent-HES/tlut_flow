	
NAME = user_guide

.PHONY: all clean publish

all:
	latexmk --pdf $(NAME)

clean:
	rm -f *.log *.aux *.synctex.gz *.bbl $(NAME).pdf *.blg *.toc *.out *.fls *.fdb_latexmk

publish: all
	cp $(NAME).pdf ../
