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
vardef gredge(expr A,B,s,multi,offset) =
	pair C, D, E;

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
	
	drawarrow (A + offset)..C..D;
	draw (A + offset)..C..(B + offset);
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
	gdNedge[gd] := gdNedge[gd]+1;
enddef;

def gdaddedgemulti(expr ei,ej,placement,offset)=
	gdedge[gd][ gdNedge[gd] ][0] := ei;
	gdedge[gd][ gdNedge[gd] ][1] := ej;
	gdedgeh[gd][ gdNedge[gd] ][0] := 0 ;
	gdedgeh[gd][ gdNedge[gd] ][1] := placement ;
	gdedgeoffset[gd][ gdNedge[gd] ] := offset ;
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
gdadd("4node_2roots_simple");
gdaddvert((0, 0), 0);
gdaddvert((0, 50), 1);
gdaddvert((50, 50), 0);
gdaddvert((50, 0), 1);
gdaddedgemulti(0, 1, 0.55, (0, 0));
gdaddedgemulti(1, 2, 0.55, (0, 0));
gdaddedgemulti(2, 0, 0.55, (0, 0));
gdaddedgemulti(3, 0, 0.55, (0, 0));
gdaddedgecurv(3, 2, 0);
gdaddvertexlabel((0, 0), "$s_1$", 0);
gdaddvertexlabel((0, 50), "$r_2$", 0);
gdaddvertexlabel((50, 0), "$r_1$", 2);
gdaddvertexlabel((50, 50), "$s_2$", 2);

% edge labels:
gdaddedgelabel((25, 50), "A", 1);
gdaddedgelabel((0, 25), "B", 0);
gdaddedgelabel((25, 25), "C", 5);
gdaddedgelabel((50, 25), "D", 2);
gdaddedgelabel((25, 0), "E", 3);

% four node 1 root example:
gdadd("4node_1root_simple");
gdaddvert((0, 0), 0);
gdaddvert((0, 50), 0);
gdaddvert((50, 50), 0);
gdaddvert((50, 0), 1);
gdaddedgemulti(0, 1, 0.55, (0, 0));
gdaddedgemulti(1, 2, 0.55, (0, 0));
gdaddedgemulti(2, 0, 0.55, (0, 0));
gdaddedgemulti(3, 0, 0.55, (0, 0));
gdaddedgecurv(3, 2, 0);
gdaddvertexlabel((0, 0), "$s_1$", 0);
gdaddvertexlabel((0, 50), "$s_3$", 0);
gdaddvertexlabel((50, 0), "$r_1$", 2);
gdaddvertexlabel((50, 50), "$s_2$", 2);

% edge labels:
gdaddedgelabel((25, 50), "A", 1);
gdaddedgelabel((0, 25), "B", 0);
gdaddedgelabel((25, 25), "C", 5);
gdaddedgelabel((50, 25), "D", 2);
gdaddedgelabel((25, 0), "E", 3);

% five node example:
gdadd("5node_2roots");
gdaddvert((0, 0), 1);
gdaddvert((-12.5, 50), 0);
gdaddvert((25, 75), 1);
gdaddvert((62.5, 50), 0);
gdaddvert((50, 0), 0);

% all of r1's edges
gdaddvertexlabel((0, 0), "$r_1$", 4);
gdaddedge(0, 1);
gdaddedgelabel((-12.5, 25), "A", 4);
gdaddedge(0, 2);
gdaddedgelabel((15, 50), "F", 0);
gdaddedgecurv(0, 3, 0.05);
gdaddedgelabel((10, 10), "H", 2);
gdaddedge(0, 4);
gdaddedgelabel((25, 0), "E", 3);

gdaddvertexlabel((-12.5, 50), "$s_1$", 5);

% all of r2's edges
gdaddvertexlabel((25, 75), "$r_2$", 1);
gdaddedge(2, 1);
gdaddedgelabel((5, 62.5), "B", 5);
gdaddedge(2, 3);
gdaddedgelabel((55, 62.5), "C", 5);

% all of s2's edges
gdaddvertexlabel((62.5, 50), "$s_2$", 2);
gdaddedge(3, 4);
gdaddedgelabel((62.5, 25), "D", 7);

% all of s3's edges
gdaddvertexlabel((50, 0), "$s_3$", 7);
gdaddedgecurv(4, 1, -0.05);
gdaddedgelabel((40, 10), "I", 0);
gdaddedge(4, 2);
gdaddedgelabel((35, 50), "G", 2);

% j1-j2 difference example
gdadd("5node_2roots_k3_minor");

gdaddvert((0, 0), 1);
gdaddvert((0, 50), 0);
gdaddvert((37.5, 100), 0);
gdaddvert((75, 50), 0);
gdaddvert((75, 0), 1);

% all of r1's edges
gdaddvertexlabel((0, 0), "$r_1$", 4);
gdaddedge(0, 1);
gdaddedgelabel((0, 25), "A", 0);

% all of s1's edges
gdaddvertexlabel((0, 50), "$s_1$", 0);
gdaddedgemulti(1, 2, 0.7, (-1, 1));
gdaddedgelabel((15.5, 75), "H", 5);
gdaddedgemulti(1, 3, 0.7, (0, 1.4));
gdaddedgelabel((37.5, 50), "D", 1);

% all of s3's edges
gdaddvertexlabel((37.5, 100), "$s_3$", 1);
gdaddedgemulti(2, 1, 0.7, (1, -1));
gdaddedgelabel((25, 60), "G", 1);
gdaddedgemulti(2, 3, 0.7, (1, 1));
gdaddedgelabel((59.5, 75), "F", 6);

% all of s2's edges
gdaddvertexlabel((75, 50), "$s_2$", 2);
gdaddedgemulti(3, 2, 0.7, (-1, -1));
gdaddedgelabel((50, 60), "E", 1);
gdaddedgemulti(3, 1, 0.7, (0, -1.4));
gdaddedgelabel((37.5, 47.5), "C", 3);

% all of r2's edges
gdaddvertexlabel((75, 0), "$r_2$", 7);
gdaddedge(4, 3);
gdaddedgelabel((75, 25), "B", 2);

gdadd("3node_1root");

for i = 0 upto 2:
	gdaddvert(ut*dir(-i*360/3+210),0);
	if i = 0:
		gdaddvertexlabel(ut*dir(-i*360/3+210), "$r$", 4);
	elseif i = 1:
		gdaddvertexlabel(ut*dir(-i*360/3+210), "$s_1$", 1);
	else:
		gdaddvertexlabel(ut*dir(-i*360/3+210), "$s_2$", 7);
	fi;
endfor;

% all of r's edges
gdaddedgemulti(0, 1, 0.55, (0, 0));
gdaddedgemulti(0, 2, 0.55, (0, 0));

% s1
gdaddedgemulti(1, 2, 0.55, (0, 0));

gdaddedgelabel(ut/2*dir(135), "A", 5);
gdaddedgelabel(ut/2*dir(45), "B", 6); 
gdaddedgelabel(ut/2*dir(-90), "C", 3);

gdadd("3node_2roots");
for i = 0 upto 2:
	gdaddvert(ut*dir(-i*360/3+210),0);
	if i = 0:
		gdaddvertexlabel(ut*dir(-i*360/3+210), "$r_1$", 4);
	elseif i = 1:
		gdaddvertexlabel(ut*dir(-i*360/3+210), "$t$", 1);
	else:
		gdaddvertexlabel(ut*dir(-i*360/3+210), "$r_2$", 7);
	fi;
endfor;

% all of r's edges
gdaddedgemulti(0, 1, 0.55, (0, 0));
gdaddedgemulti(0, 2, 0.55, (0, 0));

% s1
gdaddedgemulti(1, 2, 0.55, (0, 0));

gdaddedgelabel(ut/2*dir(135), "A", 5);
gdaddedgelabel(ut/2*dir(45), "B", 6); 
gdaddedgelabel(ut/2*dir(-90), "C", 3);

% ** drawing the figures and output ********************************************

gdN := gd;

for gd = 1 upto gdN:
gadget[gd]:= image(
	for ie = 0 upto gdNedge[gd]-1:
		gredge( gdvert[gd][gdedge[gd][ie][0]], gdvert[gd][gdedge[gd][ie][1]], gdedgeh[gd][ie][0], gdedgeh[gd][ie][1], gdedgeoffset[gd][ie]  );
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

