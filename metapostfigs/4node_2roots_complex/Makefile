# this title requires that each figure has its own folder, where the .mp file name is the same as its folder
title=ObsGraphs
all: build toPdf
build:
	mpost ${title}.mp

toPdfTitle=4node_2roots_complex 4node_2roots_r1_branchings_1 4node_2roots_r2_branchings_a 4node_2roots_r2_branchings_b 4node_2roots_r2_branchings_c 4node_2roots_branching_1b 4node_2roots_branching_1c

toPdf:
	for file in ${toPdfTitle} ; do \
		epstopdf fig_$$file.eps ; \
	done

.PHONY: clean

clean:
	rm *.pdf *.eps
