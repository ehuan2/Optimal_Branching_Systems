% GadgetGraphs.mp -- drawing the graphs of gadgets.
%
% compiling:
% simple compiling: 
%     mpost GadgetGraphs.mp
% if there are LaTeX labels:
%     TEX=pdflatex mpost GadgetGraphs.mp
% The script a2ping is for converting .eps figures to .pdf figures,
% while not screwing up the bounding box.
% It gives an error message, but it works fine...
% One can use the bash script for multiple conversions:
%     for f in fig_Gadget*.eps; do ./a2ping.pl $f; done
%     << or >>
%     for f in fig_Gadget*.eps; do epspdf $f; done

% ** declarations for metaposting **********************************************
input mparrows;
setarrows(barbedsharp);
prologues := 3;	% needed if there are LaTeX labels and also for converting to pdf

% for writing out the indices:
numeric showindices;
showindices := 0;       % hide the indices
%showindices := 1;      % show the indices

if showindices=1:
        input TEX;
        TEXPRE("%&latex" & char(10) & "\documentclass{article}\begin{document}");
        TEXPOST("\end{document}");
fi;


% ** units *********************************************************************

%numeric ut; ut := 24bp; 
numeric ut; ut := 30bp; 

%numeric dt; dt := .2ut;			% size of a vertex
numeric dt; dt := .10ut;		% size of a vertex
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
		label.lft(labelName, A);
	elseif pos = 1:
		label.top(labelName, A);
	elseif pos = 2:
		label.rt(labelName, A);
	elseif pos = 3:
		label.bot(labelName, A);
	elseif pos = 4:
		label.llft(labelName, A);
	elseif pos = 5:
		label.ulft(labelName, A);
	elseif pos = 6:
		label.urt(labelName, A);
	elseif pos = 7:
		label.lrt(labelName, A);
	fi;
enddef;

% default edge for the graph
vardef gredge(expr A,B,s) =
pair C, D, E;
	C := 0.3[A,B]+s*((B-A) rotated 90);
	D := 0.5[A,B]+1.13s*((B - A) rotated 90);
        drawarrow A..C..D;
				draw A..C..B;
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
numeric gdedgeh[][];		% 0: straight, >0: curvature ("height")
 
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
	gdedgeh[gd][ gdNedge[gd] ] := 0 ;
	gdNedge[gd] := gdNedge[gd]+1;
enddef;

def gdaddlabel(expr A, labelName, pos)=
	gdlabelpos[gd][gdNlabel[gd]] := A;
	gdlabelName[gd][gdNlabel[gd]] := labelName;
	gdlabel[gd][gdNlabel[gd]] := pos;
	gdNlabel[gd] := gdNlabel[gd] + 1;
enddef;

def gdaddedgecurv(expr ei,ej,s)=
	gdedge[gd][ gdNedge[gd] ][0] := ei;
	gdedge[gd][ gdNedge[gd] ][1] := ej;
	gdedgeh[gd][ gdNedge[gd] ] := s ;
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
gdaddedge(0, 1);
gdaddedge(1, 2);
gdaddedge(2, 0);
gdaddedge(3, 0);
gdaddedgecurv(3, 2, 0);
gdaddlabel((0, 0), "s1", 0);
gdaddlabel((0, 50), "r2", 0);
gdaddlabel((50, 0), "r1", 2);
gdaddlabel((50, 50), "s2", 2);

% edge labels:
gdaddlabel((25, 50), "A", 1);
gdaddlabel((0, 25), "B", 0);
gdaddlabel((25, 25), "C", 5);
gdaddlabel((50, 25), "D", 2);
gdaddlabel((25, 0), "E", 4);

% five node example:
gdadd("5node_2roots");
gdaddvert((0, 0), 1);
gdaddvert((0, 50), 0);
gdaddvert((25, 75), 1);
gdaddvert((50, 50), 0);
gdaddvert((50, 0), 0);

% all of r1's edges
gdaddlabel((0, 0), "r1", 4);
gdaddedge(0, 1);
gdaddedge(0, 2);
gdaddedgecurv(0, 3, 0.05);
gdaddedge(0, 4);

gdaddlabel((0, 50), "s1", 5);

% all of r2's edges
gdaddlabel((25, 75), "r2", 1);
gdaddedge(2, 1);
gdaddedge(2, 3);

% all of s2's edges
gdaddlabel((50, 50), "s2", 2);
gdaddedge(3, 4);

% all of s3's edges
gdaddlabel((50, 0), "s3", 7);
gdaddedgecurv(4, 1, -0.05);
gdaddedge(4, 2);

% ** drawing the figures and output ********************************************

gdN := gd;

for gd = 1 upto gdN:
gadget[gd]:= image(
	for ie = 0 upto gdNedge[gd]-1:
		gredge( gdvert[gd][gdedge[gd][ie][0]], gdvert[gd][gdedge[gd][ie][1]], gdedgeh[gd][ie]  );
	endfor;
	for iv = 0 upto gdNvert[gd]-1:
		if gdverttype[gd][iv] = 0:
			grvertexdata(gdvert[gd][iv]);
		elseif gdverttype[gd][iv] = 1:
			grvertexaux(gdvert[gd][iv]);
		fi;
		if showindices=1: label.urt(TEX("\tiny $"&decimal(iv)&"$"), gdvert[gd][iv] ); fi;
	endfor;
	for il = 0 upto gdNlabel[gd]-1:
		grlabel(gdlabelpos[gd][il], gdlabelName[gd][il], gdlabel[gd][il]);
	endfor;
);
endfor;


for gd = 1 upto gdN:
	show gdlabel[gd];
	outputtemplate := "fig_Gadget"&gdlabel[gd]&".eps";
	beginfig(0) draw gadget[gd]; endfig;
endfor;

end;

