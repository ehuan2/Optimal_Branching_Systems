# this title requires that each figure has its own folder, where the .mp file name is the same as its folder
title=ObsGraphs
all: build toPdf
build:
		mpost ${title}.mp

toPdfTitle=4node_2roots_simple 5node_2roots 5node_2roots_j1_j2_diff

toPdf:
	for file in ${toPdfTitle} ; do \
		epstopdf fig_Gadget$$file.eps ; \
	done

.PHONY: clean

clean:
	rm $$file/*.pdf
