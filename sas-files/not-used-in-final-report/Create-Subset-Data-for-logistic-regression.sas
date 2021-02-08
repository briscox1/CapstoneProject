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
    w=p1/r1; if hit=0 then w=(1-p1)/(1-r1);
    off=log( (r1*(1-p1)) / ((1-r1)*p1) );
run;

    