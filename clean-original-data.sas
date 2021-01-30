%include '/folders/myfolders/sasuser.v94/CapstoneProject/KW_MC.sas';
%include '/folders/myfolders/sasuser.v94/CapstoneProject/remove-multicollinearity.sas';
%include '/folders/myfolders/sasuser.v94/CapstoneProject/load-data.sas';

*Create value formats;
proc format library=mysaslib;
	value modeFmt     0 = "minor"
				      1 = "major";
	value keyFmt      0 = "C"
				      1	= "C#/Db"
				      2 = "D"
				      3 = "Eb"
				      4 = "E"
				      5 = "F"
				      6 = "F#"
				      7 = "G"
				      8 = "G#/Ab"
				      9 = "A"
				     10 = "Bb"
				     11 = "B";
	value explicitFmt 0 = "No Explicit Content"
					  1 = "Explicit Content";
run; quit;

ods trace on;
proc contents data=mysaslib.capstone order=varnum out=_contents_;
	ods select position;
run; quit;

* remove char. variables including artist, id, name, and real_date;
* remove popularity (target variables);
proc sql;
 	select name into :varNames separated by ' ' 
    	from  _contents_ 
    	where name ^= ('popularity')
    	and   type ^= 2;
quit;

proc contents data=Billboard_with_hit order=varnum out=_contents2_;
	ods select position;
run; quit;

proc contents data=acousticAttributesBillboard order=varnum;
run; quit;

proc means data=acousticAttributesBillboard n nmiss mean std min max sum;
run; quit;

proc print data=acousticAttributesBillboard;
where spotify_track_popularity = .;

* names for the regression on popularity for the 2nd data set;
proc sql;
	select name into :Dataset2_without_popularity separated by ' '
	from _contents2_
	where name ^= ('spotify_track_popularity')
	and type ^= 2;
quit;

proc corr data=Billboard_with_hit spearman rank plots(maxpoints=none)=matrix(histogram);
	var &dataset2_without_popularity; with spotify_track_popularity;
run;

proc sql;
	select name into :varNamesLogistic separated by ' '
	from _contents2_
	where name ^= ('hit')
	and type ^= 2;
quit;

%REMOVE_MULTICOLLINEARITY(DATASET=mysaslib.capstone,YVAR=popularity,VIF_CUTOFF=4);
%REMOVE_MULTICOLLINEARITY(DATASET=mysaslib.merged2, YVAR=hit, VIF_CUTOFF=5);

/* after running the above sas macro code
for multicollinearity then run the below code */

/* final data set with no multicollinearity variables */
data NO_MULTICOLLINEARITY;
SET PAREST2;
KEEP VARIABLE;
RUN;

PROC SQL NOPRINT;
SELECT VARIABLE INTO : XVARS_final SEPARATED BY ' '
FROM NO_MULTICOLLINEARITY
WHERE VARIABLE NOT IN("Intercept");
QUIT;

* multiple regression for first data set;
PROC REG DATA=mysaslib.merged2;
MODEL hit=&XVARS_final./ VIF ;
RUN;
QUIT;

proc corr data=mysaslib.merged2 rank;
	var &XVARS_final.;
run;

proc sql;
	select name into :energyReg separated by ' '
	from _contents_
	where name ^= ('energy')
	and type ^= 2;
quit;

* provide descriptive statistics;
proc means data=mysaslib.capstone n nmiss mean std min max;
	title 'Means Procedure 1st dataset';
run; quit;

*multicollinearity analysis;
proc corr data=mysaslib.capstone spearman pearson rank;
	var &varNames;
	title 'MultiCollinearity analysis';
run; quit;

* spearman and pearson correlation coefficients ranked by most sig. descending;
proc corr data=mysaslib.capstone spearman pearson rank;
	var &varNames; with popularity; 
	title 'Correlation Analysis First Dataset';
run; quit;

proc logistic data=mysaslib.merged2;
	model hit = &varNamesLogistic / corrb;
	title 'logistic regression';
run; quit;

proc reg data=mysaslib.merged2;
	model hit=&varNamesLogistic / vif;
	title 'vif check';
run; quit;

proc reg data=mysaslib.capstone;
	model energy=&energyReg /vif;
	title 'regression test';
run; quit;


						
