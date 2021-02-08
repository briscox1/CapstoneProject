
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