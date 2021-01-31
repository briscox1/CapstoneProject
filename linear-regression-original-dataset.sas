ods trace on;

proc contents data=capstone2 order=varnum out=_contents_ noprint;
run; quit;

* remove char. variables including artist, id, name, and real_date;
* remove popularity (target variables);
proc sql noprint;
 	select name into :kagVarNames separated by ' ' 
    	from  _contents_ 
    	where name ^= ('spotify_track_popularity')
    	and   type ^= 2;
quit;

*inital model using all variables;
proc reg data=capstone2;
	model spotify_track_popularity = &kagVarNames;
	title 'Initial Regression on Popularity Using All Variables (kaggle.com ds)';
run; quit;

*simple linear regression using only the year;
proc reg data=capstone2;
	model spotify_track_popularity = year;
	title 'Regression on Popularity Using Just The Year Variable (kaggle.com ds)';
run; quit;

* let's remove year from the model;
proc sql noprint;
 	select name into :kagVarNames separated by ' ' 
    	from  _contents_ 
    	where name ^= ('spotify_track_popularity')
    	and name ^= ('year')
    	and   type ^= 2;
quit;

proc reg data=capstone2; 
	model spotify_track_popularity = &kagVarNames / 
	selection = stepwise
	slentry=.05
	slstay=.05
	vif;
	title 'stepwise regression on popularity with year removed (kaggle.com ds)';
run; quit;

/* Analysis of 2nd dataset */
proc contents data=unique_merged2 order=varnum out=_contents_ noprint;
run; quit;

proc sql noprint;
	select name into :dwVarNames separated by ' '
	from _contents_
	where name ^= ('spotify_track_popularity')
	and type ^= 2;
quit;

proc reg data=unique_merged2;
	model spotify_track_popularity = &dwVarNames /
	selection = stepwise
	slentry=.05
	slstay=.05
	vif;
	title 'stepwise regression on popularity (data.world.com ds)';
run; quit;

*logistic begins here;
proc logistic data=unique_merged;
	class key;
	model hit(event="1")=&dwVarNames / 
	/ expb
	  lackfit
	  risklimits
	  ctable
	  outroc=roc1;
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
	
proc sql noprint;
	select name into :dwVarNames separated by ' ' 
	from _contents_
	where name ^= ('hit')
	and type ^= 2;
	
proc logistic data=sub;
	class key;
	model hit(event="1")=&dwVarNames
	/ expb
	  lackfit
	  risklimits
	  ctable
	  outroc=roc1;
	output out=out p=pnowt;
	title "True Parameters";
	title2 "Unadjusted Model";
run; quit;

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

	


  
ods trace off;