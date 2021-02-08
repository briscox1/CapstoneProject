%include '/folders/myfolders/sasuser.v94/SASDATA/KW_MC.sas';

ods output Members=Members;
proc datasets library=work memtype=data;
run;
quit;

/*-----------------------*
Explicit Analysis (dataset #1)
-------------------------*/

PROC NPAR1WAY WILCOXON data=capstone2;
	CLASS spotify_track_explicit;
	var spotify_track_popularity;
	title 'Explicit analysis dataset #1';
run; quit;

/*-----------------------*
Explicit Analysis (dataset #2)
-------------------------*/

PROC NPAR1WAY WILCOXON data=unique_merged2;
	CLASS spotify_track_explicit;
	var spotify_track_popularity;
	title 'Explicit analysis dataset #2';
run; quit;

