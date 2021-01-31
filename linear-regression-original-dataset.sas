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
	title 'Initial Regression on Popularity Using All Variables';
run; quit;

*simple linear regression using only the year;
proc reg data=capstone2 plots(maxpoints=none);
	model spotify_track_popularity = year;
	title 'Regression on Popularity Using Just The Year Variable';
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
	title 'stepwise regression on popularity with year removed';
run; quit;
	