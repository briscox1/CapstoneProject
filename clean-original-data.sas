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

proc reg data=mysaslib.capstone;
	model energy=&energyReg /vif;
	title 'regression test';
run; quit;


						
