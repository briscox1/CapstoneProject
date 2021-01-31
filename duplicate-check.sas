%macro dupcheck(inputds=,
 var=,
 uniqueds=singles,
 dupds=dups);
*Detecting duplicates with PROC SQL;
proc sql;
title "Checking for duplicates of &var in &inputds";
select count(distinct &var) as Ndistinct,
 count(*) as Nobs
 into :Ndistinct,:Nobs
from &inputds;
quit;
%if %sysevalf(&Ndistinct/&Nobs) ne 1 %then %do;
 *Summarizing duplicates with PROC FREQ;
 proc freq data=&inputds;
 tables &var/out=freqout noprint;
 run;
 proc freq data=freqout;
 tables count;
 title "FREQ of singles, doubles, etc. of &var in data set &inputds";
 run;
 *Outputting duplicates with PROC SORT;
 proc sort data=&inputds nouniquekeys uniqueout=&uniqueds out=&dupds;
 by &var;
 run;
%end;
%mend dupcheck;