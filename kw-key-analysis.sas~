%include '/folders/myfolders/sasuser.v94/SASDATA/KW_MC.sas';

/*-----------------------*
Dataset #1 (key)
-------------------------*/

%let numgroups=12;
%let dataname=capstone2;
%let obsvar=spotify_track_popularity;
%let group=key;
%let alpha=0.05;
title 'Dunn''s Test Key Comparison dataset #1';

%kw_mc(source=&dataname, groups=&numgroups, obsname=&obsvar, gpname=&group, sig=&alpha);

/*-----------------------*
Dataset #2 (key)
-------------------------*/

%include '/folders/myfolders/sasuser.v94/SASDATA/KW_MC.sas';

%let numgroups=12;
%let dataname=unique_merged2;
%let obsvar=spotify_track_popularity;
%let group=key;
%let alpha=0.05;
title 'Dunn''s Test Key Comparison dataset #2';

%kw_mc(source=&dataname, groups=&numgroups, obsname=&obsvar, gpname=&group, sig=&alpha);

/*-----------------------*
End First analysis
-------------------------*/