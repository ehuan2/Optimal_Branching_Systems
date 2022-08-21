# this title requires that each figure has its own folder, where the .mp file name is the same as its folder
title=ObsGraphs
all: build toPdf
build:
	mpost ${title}.mp

toPdfTitleOne=4node_2roots_complex 4node_2roots_r1_branchings_1 4node_2roots_r2_branchings_a 4node_2roots_r2_branchings_b 4node_2roots_r2_branchings_c 4node_2roots_branching_1b 4node_2roots_branching_1c 
toPdfTitleTwo=4node_2roots_complex_j2_one 4node_2roots_complex_j2_two 4node_2roots_complex_j2_three 4node_2roots_complex_j2_four 4node_2roots_complex_j2_five 4node_2roots_j1_one 4node_2roots_j1_two 4node_2roots_j1_three 4node_2roots_complex_v2

toPdf:
	for file in ${toPdfTitleOne} ; do \
		epstopdf fig_$$file.eps ; \
	done
	for file in ${toPdfTitleTwo} ; do \
		epstopdf fig_$$file.eps ; \
	done

.PHONY: clean

clean:
	rm *.pdf *.eps
