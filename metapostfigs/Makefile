# this title requires that each figure has its own folder, where the .mp file name is the same as its folder
title=ObsGraphs
all: build toPdf
build:
	mpost ${title}.mp

toPdfTitle=5node_2roots 5node_2roots_k3_minor 3node_1root 4node_1root_simple 3node_1root_trouble

toPdf:
	for file in ${toPdfTitle} ; do \
		epstopdf fig_$$file.eps ; \
	done

.PHONY: clean

clean:
	rm *.pdf *.eps
