# this title requires that each figure has its own folder, where the .mp file name is the same as its folder
title=ObsGraphs
all: build toPdf
build:
		mpost ${title}.mp

toPdfTitle=fig_Gadget4node_2roots_simple fig_Gadget5node_2roots

toPdf:
	for file in ${toPdfTitle} ; do \
		epstopdf $$file.eps ; \
	done

.PHONY: clean

clean:
	rm $$file/*.pdf
