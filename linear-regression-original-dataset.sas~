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