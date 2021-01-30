/* Author PRAKASH HULLATHI */
/*CREATING THE DATA FOR MULTICOLLINEARITY*/

%MACRO REMOVE_MULTICOLLINEARITY(DATASET=,YVAR=,VIF_CUTOFF=);

/*taking output of all variables*/
PROC CONTENTS DATA=&DATASET. VARNUM OUT=T;
RUN;

/*filter only numeric variables excluding dependent and date variables*/
DATA T1;
SET T;
KEEP NAME ;
WHERE TYPE=1 AND NAME NOT IN("&yvar.") and FORMAT not in('DATE') ;/* Remove target and date variables*/
RUN;

/*creating macro for independent variables*/
PROC SQL NOPRINT;
SELECT NAME INTO : XVARS SEPARATED BY ' '
FROM T1;
QUIT;

%PUT independent_variables=&XVARS;

/*running the regression model till independent variables vif< specified vif_cutoff*/
%DO %UNTIL (%SYSEVALF(&MAX_VIF.<=&VIF_CUTOFF.) );

/*taking the output of independent variables vif by removing the intercept*/
ODS OUTPUT PARAMETERESTIMATES=PAREST2;

PROC REG DATA=&DATASET. ;

MODEL &YVAR.= &XVARS. / VIF ;

RUN;

QUIT;

/*dropping the independent variables with missing vif value*/


DATA T11;
SET PAREST2;
IF VarianceInflation NOT IN(.) ;
RUN;

/*sorting the vif value by descending order*/
PROC SORT DATA=PAREST2 OUT=PAREST2_SORT ;
BY DESCENDING VarianceInflation;
RUN;

/*considering the highest vif value */
DATA PAREST2_SORT_2;
SET PAREST2_SORT;
IF _N_=1;
RUN;

/*creating the macro for highest vif value*/
PROC SQL NOPRINT;
SELECT VARIABLE INTO: REMOVE_VAR
FROM PAREST2_SORT_2;
QUIT;

/*dropping the highest vif value variable*/

PROC SQL NOPRINT ;
SELECT Variable INTO: XVARS SEPARATED BY ' '
FROM T11
WHERE VARIABLE NOT IN("&REMOVE_VAR.","Intercept") ;
QUIT;

/*getiing the highest vif value*/
PROC SQL NOPRINT;
SELECT MAX(VarianceInflation) INTO: MAX_VIF
FROM PAREST2;
QUIT;

%PUT max_vif=&MAX_VIF. variable_removed=&REMOVE_VAR. ;

%END;

%MEND REMOVE_MULTICOLLINEARITY;


%REMOVE_MULTICOLLINEARITY(DATASET=mysaslib.capstone,YVAR=popularity,VIF_CUTOFF=4);


/* after running the above sas macro code
for multicollinearity then run the below code */

/* final data set with no multicollinearity variables*/
data NO_MULTICOLLINEARITY;
SET PAREST2;
KEEP VARIABLE;
RUN;

PROC SQL NOPRINT;
SELECT VARIABLE INTO : XVARS_final SEPARATED BY ' '
FROM NO_MULTICOLLINEARITY
WHERE VARIABLE NOT IN("Intercept");
QUIT;

PROC REG DATA=mysaslib.capstone;
MODEL popularity=&XVARS_final./ VIF ;
RUN;
QUIT;