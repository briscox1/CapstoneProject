%include '/folders/myfolders/sasuser.v94/SASDATA/KW_MC.sas';

/*-----------------------*
Dataset #1 (mode)
-------------------------*/

PROC NPAR1WAY WILCOXON data=capstone2;
	CLASS mode;
	var spotify_track_popularity;
	title 'Mode Comparison Dataset #1;';
run; quit;


/*-----------------------*
Dataset #2 (mode)
-------------------------*/

PROC NPAR1WAY WILCOXON data=unique_merged2;
	CLASS mode;
	var spotify_track_popularity;
	title 'Mode Comparison Dataset #2';
run; quit;

/*-----------------------*
End Second analysis
-------------------------*/
