% Edit: July 2022, Eric Huang
% Excerpt taken from GadgetGraphs.mp
% GadgetGraphs.mp -- drawing the graphs of gadgets.
% Szilárd Szalay, Wigner Research Centre for Physics, Budapest.
%
% compiling:
% use the make file (execute make)

input mparrows;
setarrows(barbedsharp);
prologues := 3;	% needed if there are LaTeX labels and also for converting to pdf

% for writing out the indices:
numeric showindices;
%showindices := 0;       % hide the indices
showindices := 1;      % show the indices

if showindices=1:
        input TEX;
        TEXPRE("%&latex" & char(10) & "\documentclass{article}\usepackage{xcolor}\begin{document}");
        TEXPOST("\end{document}");
fi;


% ** units *********************************************************************

%numeric ut; ut := 24bp; 
numeric ut; ut := 30bp; 

%numeric dt; dt := .2ut;			% size of a vertex
numeric dt; dt := .20ut;		% size of a vertex
numeric it; it := 1.5bp; % 0.7bp	% width of an edge

% ** drawing routines **********************************************************

% default vertex for data qubit
vardef grvertexdata(expr A) =
	draw A withpen pencircle scaled dt withcolor black;
enddef;

% default vertex for aux qubit
vardef grvertexaux(expr A) =
	draw A withpen pencircle scaled dt withcolor red;
%	draw A withpen pencircle scaled dt withcolor black;
%	draw A withpen pencircle scaled (dt-2it) withcolor red;
%	draw A withpen pencircle scaled (dt-1.2it) withcolor red;
enddef;

% default label for the graph
vardef grlabel(expr A, labelName, pos)=
	% 0 for left, 1 for top, 2 for right, 3 for bottom
	% 4 for left bottom, 5 for left top, 6 for right top, 7 for left bottom
	if pos = 0:
		label.lft(TEX(labelName), A);
	elseif pos = 1:
		label.top(TEX(labelName), A);
	elseif pos = 2:
		label.rt(TEX(labelName), A);
	elseif pos = 3:
		label.bot(TEX(labelName), A);
	elseif pos = 4:
		label.llft(TEX(labelName), A);
	elseif pos = 5:
		label.ulft(TEX(labelName), A);
	elseif pos = 6:
		label.urt(TEX(labelName), A);
	elseif pos = 7:
		label.lrt(TEX(labelName), A);
	fi;
enddef;

% default edge for the graph
vardef gredge(expr A,B,s,multi,offset,colorSelect) =
	pair C, D, E;

	color purple; purple := (1.35, .14, 2.4);
	color orange; orange := (1.45, 0.64, 0.05);

	if multi = 0:
		if s = 0:
			C := 0.3[A,B]+s*((B-A) rotated 90);
			D := 0.5[A,B]+1.13s*((B - A) rotated 90);
		else:
			C := 0.3[A,B]+s*((B-A) rotated 90);
			D := 0.33[A,B]+1.05s*((B - A) rotated 90);
		fi;
	else:
		C := 0.3[A,B] + offset;
		D := multi[A,B] + offset;
	fi;
	
	if colorSelect = 0:
		drawarrow (A + offset)..C..D;
		draw (A + offset)..C..(B + offset);
	elseif colorSelect = 1:
		drawarrow (A + offset)..C..D withcolor blue;
		draw (A + offset)..C..(B + offset) withcolor blue;
	elseif colorSelect = 2:
		drawarrow (A + offset)..C..D withcolor purple;
		draw (A + offset)..C..(B + offset) withcolor purple;
	elseif colorSelect = 3:
		drawarrow (A + offset)..C..D withcolor orange;
		draw (A + offset)..C..(B + offset) withcolor orange;
	fi;
	%draw A..C..B withpen pencircle scaled it withcolor black;
%	draw A--B withpen pencircle scaled it withcolor black;
enddef;

% ** gadget definitions ********************************************************

picture gadget[];


% internal database, don't touch direclty, only through "gdadd..." routines.
string gdlabel[];
numeric gdNvert[];
numeric gdNedge[];
numeric gdNlabel[];

pair gdvert[][];
numeric gdverttype[][];		% 0: data, 1: aux

numeric gdedge[][][];
numeric gdedgeh[][][];		% 0: curvature level (0: straight, >0: curvature ("height"))
													% 1: where to place arrowhead
pair gdedgeoffset[][];
numeric gdedgecolor[][];
 
% first is for image, second is for label number, third is to separate
pair gdlabelpos[][];
string gdlabelName[][];
numeric gdlabel[][]; % provides the orientation

numeric gd,gdN;
gd := 0;

def gdadd(expr gdl)=
	gd := gd+1;
	gdlabel[gd] := gdl;
	gdNedge[gd] := 0;
	gdNvert[gd] := 0;
	gdNlabel[gd] := 0;
enddef;

def gdaddvert(expr A,t)=
	gdvert[gd][ gdNvert[gd] ] := A;
	gdverttype[gd][ gdNvert[gd] ] := t;
	gdNvert[gd] := gdNvert[gd]+1;
	
enddef;

def gdaddedge(expr ei,ej)=
	gdedge[gd][ gdNedge[gd] ][0] := ei;
	gdedge[gd][ gdNedge[gd] ][1] := ej;
	gdedgeh[gd][ gdNedge[gd] ][0] := 0 ;
	gdedgeh[gd][ gdNedge[gd] ][1] := 0 ;
	gdedgeoffset[gd][ gdNedge[gd] ] := (0, 0) ;
	gdedgecolor[gd][ gdNedge[gd] ] := 0;
	gdNedge[gd] := gdNedge[gd]+1;
enddef;

def gdaddlabel(expr A, labelName, pos)=
	gdlabelpos[gd][gdNlabel[gd]] := A;
	gdlabelName[gd][gdNlabel[gd]] := labelName;
	gdlabel[gd][gdNlabel[gd]] := pos;
	gdNlabel[gd] := gdNlabel[gd] + 1;
enddef;

def gdaddedgelabel(expr A, labelName, pos)=
	gdlabelpos[gd][gdNlabel[gd]] := A;
	gdlabelName[gd][gdNlabel[gd]] := "\color{blue}" & labelName;
	gdlabel[gd][gdNlabel[gd]] := pos;
	gdNlabel[gd] := gdNlabel[gd] + 1;
enddef;

def gdaddvertexlabel(expr A, labelName, pos)=
	gdlabelpos[gd][gdNlabel[gd]] := A;
	gdlabelName[gd][gdNlabel[gd]] := "\color{green}" & labelName;
	gdlabel[gd][gdNlabel[gd]] := pos;
	gdNlabel[gd] := gdNlabel[gd] + 1;
enddef;

def gdaddedgecurv(expr ei,ej,s)=
	gdedge[gd][ gdNedge[gd] ][0] := ei;
	gdedge[gd][ gdNedge[gd] ][1] := ej;
	gdedgeh[gd][ gdNedge[gd] ][0] := s ;
	gdedgeh[gd][ gdNedge[gd] ][1] := 0 ;
	gdedgeoffset[gd][ gdNedge[gd] ] := (0, 0) ;
	gdedgecolor[gd][ gdNedge[gd] ] := 0;
	gdNedge[gd] := gdNedge[gd]+1;
enddef;

def gdaddedgecurvcolor(expr ei, ej, s, color)=
	gdedge[gd][ gdNedge[gd] ][0] := ei;
	gdedge[gd][ gdNedge[gd] ][1] := ej;
	gdedgeh[gd][ gdNedge[gd] ][0] := s ;
	gdedgeh[gd][ gdNedge[gd] ][1] := 0 ;
	gdedgeoffset[gd][ gdNedge[gd] ] := (0, 0);
	gdedgecolor[gd][ gdNedge[gd] ] := color;
	gdNedge[gd] := gdNedge[gd]+1;
enddef;	

% color: black = 0, blue = 1, red = 2
def gdaddedgemulti(expr ei,ej,placement,offset,color)=
	gdedge[gd][ gdNedge[gd] ][0] := ei;
	gdedge[gd][ gdNedge[gd] ][1] := ej;
	gdedgeh[gd][ gdNedge[gd] ][0] := 0 ;
	gdedgeh[gd][ gdNedge[gd] ][1] := placement ;
	gdedgeoffset[gd][ gdNedge[gd] ] := offset ;
	gdedgecolor[gd][ gdNedge[gd] ] := color;
	gdNedge[gd] := gdNedge[gd]+1;
enddef;

pair post[];
post[0] := ut*dir(90)/sqrt(2);
post[1] := ut*dir(270-45);
post[2] := ut*dir(270+45);

pair centralt; centralt:=(post[0]+post[1]+post[2])/3;
%centralt:=(0,-ut*2/sqrt(2)/6);
%centralt:=(0,0);

% four node example:
gdadd("4node_2roots_complex");
gdaddvert((0, 0), 0);
gdaddvert((0, 50), 1);
gdaddvert((50, 50), 1);
gdaddvert((50, 0), 0);
gdaddedgemulti(1, 0, 0.55, (0, 0), 0);
gdaddedgemulti(2, 0, 0.55, (0, 0), 0);
gdaddedgemulti(0, 3, 0.55, (0, 0), 0);
gdaddedgecurv(3, 2, 0);

gdaddedgecurv(3, 0, 0.15);
gdaddedgecurv(2, 3, 0.15);

gdaddvertexlabel((0, 0), "$s_1$", 0);
gdaddvertexlabel((0, 50), "$r_1$", 0);
gdaddvertexlabel((50, 0), "$s_2$", 2);
gdaddvertexlabel((50, 50), "$r_2$", 2);

% edge labels:
gdaddedgelabel((0, 25), "A", 0);
gdaddedgelabel((25, 25), "C", 5);
gdaddedgelabel((50, 25), "B", 0);
gdaddedgelabel((25, 0), "D", 1);
gdaddedgelabel((25, -7.5), "E", 3);
gdaddedgelabel((57.5, 25), "F", 2);

gdadd("4node_2roots_complex_j2_one");
gdaddvert((0, 0), 0);
gdaddvert((0, 50), 1);
gdaddvert((50, 50), 1);
gdaddvert((50, 0), 0);
gdaddedgemulti(1, 0, 0.55, (0, 0), 2);
gdaddedgemulti(0, 3, 0.55, (0, 0), 2);
gdaddedgecurvcolor(3, 2, 0, 3);

gdaddedgecurvcolor(3, 0, 0.15, 3);
gdaddedgecurvcolor(2, 3, 0.15, 2);

gdaddvertexlabel((0, 0), "$s_1$", 0);
gdaddvertexlabel((0, 50), "$r_1$", 0);
gdaddvertexlabel((50, 0), "$s_2$", 2);
gdaddvertexlabel((50, 50), "$r_2$", 2);

% edge labels:
gdaddedgelabel((0, 25), "A", 0);
gdaddedgelabel((50, 25), "B", 0);
gdaddedgelabel((25, 0), "D", 1);
gdaddedgelabel((25, -7.5), "E", 3);
gdaddedgelabel((57.5, 25), "F", 2);

gdadd("4node_2roots_complex_j2_two");
gdaddvert((0, 0), 0);
gdaddvert((0, 50), 1);
gdaddvert((50, 50), 1);
gdaddvert((50, 0), 0);
gdaddedgemulti(1, 0, 0.55, (0, 0), 2);
gdaddedgemulti(2, 0, 0.55, (0, 0), 2);
gdaddedgecurvcolor(3, 2, 0, 3);

gdaddedgecurvcolor(3, 0, 0.15, 3);
gdaddedgecurvcolor(2, 3, 0.15, 2);

gdaddvertexlabel((0, 0), "$s_1$", 0);
gdaddvertexlabel((0, 50), "$r_1$", 0);
gdaddvertexlabel((50, 0), "$s_2$", 2);
gdaddvertexlabel((50, 50), "$r_2$", 2);

% edge labels:
gdaddedgelabel((0, 25), "A", 0);
gdaddedgelabel((25, 25), "C", 5);
gdaddedgelabel((50, 25), "B", 0);
gdaddedgelabel((25, -7.5), "E", 3);
gdaddedgelabel((57.5, 25), "F", 2);

gdadd("4node_2roots_complex_j2_three");
gdaddvert((0, 0), 0);
gdaddvert((0, 50), 1);
gdaddvert((50, 50), 1);
gdaddvert((50, 0), 0);
gdaddedgemulti(1, 0, 0.55, (0, 0), 3);
gdaddedgemulti(2, 0, 0.55, (0, 0), 2);
gdaddedgemulti(0, 3, 0.55, (0, 0), 3);
gdaddedgecurvcolor(3, 2, 0, 3);

gdaddedgecurvcolor(2, 3, 0.15, 2);

gdaddvertexlabel((0, 0), "$s_1$", 0);
gdaddvertexlabel((0, 50), "$r_1$", 0);
gdaddvertexlabel((50, 0), "$s_2$", 2);
gdaddvertexlabel((50, 50), "$r_2$", 2);

% edge labels:
gdaddedgelabel((0, 25), "A", 0);
gdaddedgelabel((25, 25), "C", 5);
gdaddedgelabel((50, 25), "B", 0);
gdaddedgelabel((25, 0), "D", 1);
gdaddedgelabel((57.5, 25), "F", 2);

gdadd("4node_2roots_complex_j2_four");
gdaddvert((0, 0), 0);
gdaddvert((0, 50), 1);
gdaddvert((50, 50), 1);
gdaddvert((50, 0), 0);
gdaddedgemulti(1, 0, 0.55, (0, 0), 2);
gdaddedgemulti(2, 0, 0.55, (0, 0), 2);
gdaddedgemulti(0, 3, 0.55, (0, 0), 2);

gdaddedgecurvcolor(3, 0, 0.15, 3);
gdaddedgecurvcolor(2, 3, 0.15, 3);

gdaddvertexlabel((0, 0), "$s_1$", 0);
gdaddvertexlabel((0, 50), "$r_1$", 0);
gdaddvertexlabel((50, 0), "$s_2$", 2);
gdaddvertexlabel((50, 50), "$r_2$", 2);

% edge labels:
gdaddedgelabel((0, 25), "A", 0);
gdaddedgelabel((25, 25), "C", 5);
gdaddedgelabel((25, 0), "D", 1);
gdaddedgelabel((25, -7.5), "E", 3);
gdaddedgelabel((57.5, 25), "F", 2);

gdadd("4node_2roots_complex_j2_five");
gdaddvert((0, 0), 0);
gdaddvert((0, 50), 1);
gdaddvert((50, 50), 1);
gdaddvert((50, 0), 0);
gdaddedgemulti(1, 0, 0.55, (0, 0), 3);
gdaddedgemulti(2, 0, 0.55, (0, 0), 3);
gdaddedgemulti(0, 3, 0.55, (0, 0), 3);
gdaddedgecurvcolor(3, 2, 0, 2);

gdaddedgecurvcolor(3, 0, 0.15, 2);

gdaddvertexlabel((0, 0), "$s_1$", 0);
gdaddvertexlabel((0, 50), "$r_1$", 0);
gdaddvertexlabel((50, 0), "$s_2$", 2);
gdaddvertexlabel((50, 50), "$r_2$", 2);

% edge labels:
gdaddedgelabel((0, 25), "A", 0);
gdaddedgelabel((25, 25), "C", 5);
gdaddedgelabel((50, 25), "B", 0);
gdaddedgelabel((25, 0), "D", 1);
gdaddedgelabel((25, -7.5), "E", 3);

% four node example:
gdadd("4node_2roots_r1_branchings_1");
gdaddvert((0, 0), 0);
gdaddvert((0, 50), 1);
gdaddvert((50, 50), 1);
gdaddvert((50, 0), 0);
gdaddedgemulti(1, 0, 0.55, (0, 0), 2);
gdaddedgemulti(0, 3, 0.55, (0, 0), 2);

gdaddvertexlabel((0, 0), "$s_1$", 0);
gdaddvertexlabel((0, 50), "$r_1$", 0);
gdaddvertexlabel((50, 0), "$s_2$", 2);
gdaddvertexlabel((50, 50), "$r_2$", 2);

% edge labels:
gdaddedgelabel((0, 25), "A", 0);
gdaddedgelabel((25, 0), "D", 1);

% four node example:
gdadd("4node_2roots_r2_branchings_a");
gdaddvert((0, 0), 0);
gdaddvert((0, 50), 1);
gdaddvert((50, 50), 1);
gdaddvert((50, 0), 0);
gdaddedgemulti(2, 0, 0.55, (0, 0), 0);
gdaddedgemulti(0, 3, 0.55, (0, 0), 0);

gdaddvertexlabel((0, 0), "$s_1$", 0);
gdaddvertexlabel((0, 50), "$r_1$", 0);
gdaddvertexlabel((50, 0), "$s_2$", 2);
gdaddvertexlabel((50, 50), "$r_2$", 2);

% edge labels:
gdaddedgelabel((25, 25), "C", 5);
gdaddedgelabel((25, 0), "D", 1);

% four node example:
gdadd("4node_2roots_r2_branchings_b");
gdaddvert((0, 0), 0);
gdaddvert((0, 50), 1);
gdaddvert((50, 50), 1);
gdaddvert((50, 0), 0);
gdaddedgemulti(2, 0, 0.55, (0, 0), 0);

gdaddedgecurv(2, 3, 0.15);

gdaddvertexlabel((0, 0), "$s_1$", 0);
gdaddvertexlabel((0, 50), "$r_1$", 0);
gdaddvertexlabel((50, 0), "$s_2$", 2);
gdaddvertexlabel((50, 50), "$r_2$", 2);

% edge labels:
gdaddedgelabel((25, 25), "C", 5);
gdaddedgelabel((57.5, 25), "F", 2);

% four node example:
gdadd("4node_2roots_r2_branchings_c");
gdaddvert((0, 0), 0);
gdaddvert((0, 50), 1);
gdaddvert((50, 50), 1);
gdaddvert((50, 0), 0);

gdaddedgecurv(3, 0, 0.15);
gdaddedgecurv(2, 3, 0.15);

gdaddvertexlabel((0, 0), "$s_1$", 0);
gdaddvertexlabel((0, 50), "$r_1$", 0);
gdaddvertexlabel((50, 0), "$s_2$", 2);
gdaddvertexlabel((50, 50), "$r_2$", 2);

% edge labels:
gdaddedgelabel((25, -7.5), "E", 3);
gdaddedgelabel((57.5, 25), "F", 2);

% four node example:
gdadd("4node_2roots_branching_1b");
gdaddvert((0, 0), 0);
gdaddvert((0, 50), 1);
gdaddvert((50, 50), 1);
gdaddvert((50, 0), 0);
gdaddedgemulti(1, 0, 0.55, (0, 0), 2);
gdaddedgemulti(2, 0, 0.55, (0, 0), 0);
gdaddedgemulti(0, 3, 0.55, (0, 0), 2);

gdaddedgecurv(2, 3, 0.15);

gdaddvertexlabel((0, 0), "$s_1$", 0);
gdaddvertexlabel((0, 50), "$r_1$", 0);
gdaddvertexlabel((50, 0), "$s_2$", 2);
gdaddvertexlabel((50, 50), "$r_2$", 2);

% edge labels:
gdaddedgelabel((0, 25), "A", 0);
gdaddedgelabel((25, 25), "C", 5);
gdaddedgelabel((25, 0), "D", 1);
gdaddedgelabel((57.5, 25), "F", 2);

% four node example:
gdadd("4node_2roots_branching_1c");
gdaddvert((0, 0), 0);
gdaddvert((0, 50), 1);
gdaddvert((50, 50), 1);
gdaddvert((50, 0), 0);
gdaddedgemulti(1, 0, 0.55, (0, 0), 2);
gdaddedgemulti(0, 3, 0.55, (0, 0), 2);

gdaddedgecurv(3, 0, 0.15);
gdaddedgecurv(2, 3, 0.15);

gdaddvertexlabel((0, 0), "$s_1$", 0);
gdaddvertexlabel((0, 50), "$r_1$", 0);
gdaddvertexlabel((50, 0), "$s_2$", 2);
gdaddvertexlabel((50, 50), "$r_2$", 2);

% edge labels:
gdaddedgelabel((0, 25), "A", 0);
gdaddedgelabel((25, 0), "D", 1);
gdaddedgelabel((25, -7.5), "E", 3);
gdaddedgelabel((57.5, 25), "F", 2);

% four node example:
gdadd("4node_2roots_j1_one");
gdaddvert((0, 0), 0);
gdaddvert((0, 50), 1);
gdaddvert((50, 50), 1);
gdaddvert((50, 0), 0);
gdaddedgemulti(2, 0, 0.55, (0, 0), 0);
gdaddedgemulti(0, 3, 0.55, (0, 0), 0);

gdaddedgecurv(3, 0, 0.15);
gdaddedgecurv(2, 3, 0.15);

gdaddvertexlabel((0, 0), "$s_1$", 0);
gdaddvertexlabel((0, 50), "$r_1$", 0);
gdaddvertexlabel((50, 0), "$s_2$", 2);
gdaddvertexlabel((50, 50), "$r_2$", 2);

% edge labels:
gdaddedgelabel((25, 25), "C", 5);
gdaddedgelabel((25, 0), "D", 1);
gdaddedgelabel((25, -7.5), "E", 3);
gdaddedgelabel((57.5, 25), "F", 2);

% four node example:
gdadd("4node_2roots_j1_two");
gdaddvert((0, 0), 0);
gdaddvert((0, 50), 1);
gdaddvert((50, 50), 1);
gdaddvert((50, 0), 0);
gdaddedgemulti(1, 0, 0.55, (0, 0), 0);
gdaddedgemulti(0, 3, 0.55, (0, 0), 0);

gdaddedgecurv(3, 0, 0.15);
gdaddedgecurv(2, 3, 0.15);

gdaddvertexlabel((0, 0), "$s_1$", 0);
gdaddvertexlabel((0, 50), "$r_1$", 0);
gdaddvertexlabel((50, 0), "$s_2$", 2);
gdaddvertexlabel((50, 50), "$r_2$", 2);

% edge labels:
gdaddedgelabel((0, 25), "A", 0);
gdaddedgelabel((25, 0), "D", 1);
gdaddedgelabel((25, -7.5), "E", 3);
gdaddedgelabel((57.5, 25), "F", 2);

% four node example:
gdadd("4node_2roots_j1_three");
gdaddvert((0, 0), 0);
gdaddvert((0, 50), 1);
gdaddvert((50, 50), 1);
gdaddvert((50, 0), 0);
gdaddedgemulti(1, 0, 0.55, (0, 0), 0);
gdaddedgemulti(2, 0, 0.55, (0, 0), 0);
gdaddedgemulti(0, 3, 0.55, (0, 0), 0);

gdaddedgecurv(2, 3, 0.15);

gdaddvertexlabel((0, 0), "$s_1$", 0);
gdaddvertexlabel((0, 50), "$r_1$", 0);
gdaddvertexlabel((50, 0), "$s_2$", 2);
gdaddvertexlabel((50, 50), "$r_2$", 2);

% edge labels:
gdaddedgelabel((0, 25), "A", 0);
gdaddedgelabel((25, 25), "C", 5);
gdaddedgelabel((25, 0), "D", 1);
gdaddedgelabel((57.5, 25), "F", 2);



% ** drawing the figures and output ********************************************

gdN := gd;

for gd = 1 upto gdN:
gadget[gd]:= image(
	for ie = 0 upto gdNedge[gd]-1:
		gredge( gdvert[gd][gdedge[gd][ie][0]], gdvert[gd][gdedge[gd][ie][1]], gdedgeh[gd][ie][0], gdedgeh[gd][ie][1], gdedgeoffset[gd][ie],  gdedgecolor[gd][ie]);
	endfor;
	for iv = 0 upto gdNvert[gd]-1:
		if gdverttype[gd][iv] = 0:
			grvertexdata(gdvert[gd][iv]);
		elseif gdverttype[gd][iv] = 1:
			grvertexaux(gdvert[gd][iv]);
		fi;
		% uncomment to programmatically add in vertex numbers
		% if showindices=1: label.urt(TEX("\tiny $"&decimal(iv)&"$"), gdvert[gd][iv] ); fi;
	endfor;
	for il = 0 upto gdNlabel[gd]-1:
		grlabel(gdlabelpos[gd][il], gdlabelName[gd][il], gdlabel[gd][il]);
	endfor;
);
endfor;


for gd = 1 upto gdN:
	show gdlabel[gd];
	outputtemplate := "fig_"&gdlabel[gd]&".eps";
	beginfig(0) draw gadget[gd]; endfig;
endfor;

end;

