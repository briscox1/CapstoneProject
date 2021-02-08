%include '/folders/myfolders/sasuser.v94/CapstoneProject/load-data.sas';

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

ods graphics on;
proc glmselect data=unique_merged2 plot=CriterionPanel;
   model spotify_track_popularity = &dwVarNames
                / selection=stepwise(select=AdjRSq) stats=all;
ods select SelectionSummary CriterionPanel;
quit;