%include '/folders/myfolders/sasuser.v94/CapstoneProject/load-data.sas';

*logistic begins here;
options fmtsearch=(mysaslib);
proc logistic data=unique_merged2;
	class key;
	model hit(event="1")=&dwVarNames / 
	expb
	lackfit
	risklimits
	ctable
	outroc=roc1;
	format key keyFmt.;
	title 'logistic regression on popularity on original dataset';
run; quit;

data sub;
	set unique_merged2;
	if hit=1 or (hit=0 and ranuni(75302)<972/23574) then output;
run;

proc freq data=unique_merged2;
	table hit / out=fullpct(where=(hit=1) rename=(percent=fullpct));
	title "response counts in full dataset";
run; quit;

proc freq data=sub;
	table hit / out=subpct(where=(hit=1) rename=(percent=subpct));
	title "response counts in oversampled, subset data set";
run; quit;

data sub;
	set sub;
	if _n_=1 then set fullpct(keep=fullpct);
    if _n_=1 then set subpct(keep=subpct);
    p1=fullpct/100; r1=subpct/100;
    w=p1/r1; if y=0 then w=(1-p1)/(1-r1);
    off=log( (r1*(1-p1)) / ((1-r1)*p1) );
    run;
    
proc freq data=sub;
	table hit;
run; quit;
	
proc sql noprint;
	select name into :dwVarNames separated by ' ' 
	from _contents_
	where name ^= ('hit')
	and type ^= 2;

options fmtsearch=(mysaslib);
proc logistic data=sub;
	class key;
	model hit(event="1")=&dwVarNames
	/ expb
	  lackfit
	  risklimits
	  ctable
	  outroc=roc1;
	output out=out p=pnowt;
	format key keyFmt.;
	title 'logistic regression on popularity on subsample';
run; quit;

/*proc logistic data=out;
	class key;
	model hit(event="1")=&dwVarNames
	/ expb
	  lackfit
	  risklimits
	  ctable
	  outroc=roc1; 
	  weight w;
    output out=out p=pwt;
    title2 "Weight-adjusted Model";
run; quit;

options fmtsearch=(mysaslib);
proc logistic data=out;
   class key;
   model hit(event="1")=&dwVarNames / 
   offset=off
   expb
   lackfit
   risklimits
   ctable
   outroc=roc1;
   output out=out xbeta=xboff;
   title2 "Offset-adjusted Model";
   format key keyFmt.;
   run;
data out;
   set out;
   poff=logistic(xboff-off);
   run;
   
proc freq data=unique_merged2 noprint;
	table hit / out=priors(drop=percent rename=(count=_prior_));
run;
proc logistic data=out;
	class key;
    model hit(event="1")=&dwVarNames /
    expb
	lackfit
	risklimits
	ctable
	outroc=roc1;
	score data=sub prior=priors out=out2;
	title2 "Unadjusted Model; Prior-adjusted probabilities";
    run;
data out;
   merge out out2;
   drop _lev:;
run;

ods trace off; */
