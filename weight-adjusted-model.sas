%include '/folders/myfolders/sasuser.v94/CapstoneProject/load-data.sas';

/* logistic regression on unduplicated dataset */
proc contents data=unique_merged2 order=varnum out=_contents_ noprint;
run; quit;

proc sql noprint;
	select name into :dwVarNames separated by ' ' 
	from _contents_
	where name ^= ('hit')
	and type ^= 2;

options fmtsearch=(mysaslib);
proc logistic data=out;
	class key;
	model hit(event="1")=&dwVarNames
	/ expb
	  lackfit
	  risklimits
	  ctable
	  outroc=roc1; 
	  weight w;
    output out=out p=pwt;
    format key keyFmt.;
    title "Weight-adjusted Model";
run; quit;
