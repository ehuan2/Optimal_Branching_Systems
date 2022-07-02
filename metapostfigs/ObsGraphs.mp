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
numeric dt; dt := .15ut;		% size of a vertex
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

% default edge for the graph
vardef gredge(expr A,B,s) =
pair C;
	C := 0.3[A,B]+s*((B-A) rotated 90);
        drawarrow A..C..B;
        %draw A..C..B withpen pencircle scaled it withcolor black;
%	draw A--B withpen pencircle scaled it withcolor black;
enddef;

% ** gadget definitions ********************************************************

picture gadget[];


% internal database, don't touch direclty, only through "gdadd..." routines.
string gdlabel[];
numeric gdNvert[];
numeric gdNedge[];

pair gdvert[][];
numeric gdverttype[][];		% 0: data, 1: aux

numeric gdedge[][][];
numeric gdedgeh[][];		% 0: straight, >0: curvature ("height")

numeric gd,gdN;
gd := 0;

def gdadd(expr gdl)=
	gd := gd+1;
	gdlabel[gd] := gdl;
	gdNedge[gd] := 0;
	gdNvert[gd] := 0;
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
gdadd("four_node");
gdaddvert((0,+ut*0.3),1);
for i = 0 upto 3:
	gdaddvert(ut*dir(i*360/4+45),0);
	gdaddedge(0,i+1);
	gdaddedge(i+1,(i+1) mod 4 +1);
endfor;
gdaddedge(1,3);
gdaddedge(2,4);

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
);
endfor;


for gd = 1 upto gdN:
	show gdlabel[gd];
	outputtemplate := "fig_Gadget"&gdlabel[gd]&".eps";
	beginfig(0) draw gadget[gd]; endfig;
endfor;

end;

