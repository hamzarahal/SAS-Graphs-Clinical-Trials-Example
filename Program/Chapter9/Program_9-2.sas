/****************************************************************************************
Program:          Program_9-2.sas

SAS Version:      SAS 9.4M3
Developer:        Hamza Rahal 
Date:             2024-09-22
Purpose:          Produce outputs for SAS® Graphics for Clinical Trials by Example book. 
Operating Sys:    Windows 10

Macros:           NONE

Input:            adslmod.sas7bdat

Output:           Output_9-1.rtf, Output_9-2.rtf

Comments:         Use CustomSapphire style that was provided by SAS press
                  Note CustomSapphire is not provided with SAS but rather created 
                  specifically for SAS Press books
----------------------------------------------------------------------------------------- 
****************************************************************************************/

/*******************************************/
/*** BEGIN SECTION TO BE UPDATED BY USER ***/
/*******************************************/
options validvarname=upcase;
%include  "/home/rahal.hmza/Clinical graphs using SAS/Program/CustomSapphire.sas";
libname adam "/home/rahal.hmza/Clinical graphs using SAS/Data/ADaM";
libname tfldata "/home/rahal.hmza/Clinical graphs using SAS/Data/TFLData";
%let outputpath = /home/rahal.hmza/Clinical graphs using SAS/Output;
%let outname = Output_9-1;
%let outname2 = Output_9-2;
/*****************************************/
/*** END SECTION TO BE UPDATED BY USER ***/
/*****************************************/

title;

/* formats to display time point */
proc format;
   value trt
       0 = 'Placebo'
       54 = 'Xanomeline Low Dose'
       81 = 'Xanomeline High Dose'
                ;
run;

options nobyline nodate nonumber;
ods graphics on / imagefmt = png width = 5in noborder;
ods rtf file = "&outpath.\&outname..rtf"
        image_dpi = 300
        style = customSapphire;

proc sgplot data = adam.adslmod noautolegend; 
   format trt01pn trt.;

   vbox age / category =  trt01pn extreme;

   xaxistable n_c  / x = trt01pn location = inside separator;
   xaxistable  mean_sd min_max / x = trt01pn location = inside;

   xaxis type = discrete label = "Treatment";
   yaxis type = linear label = "Change from Baseline";
run;

options nobyline nodate nonumber;
ods graphics on / imagefmt = png width = 5in noborder;
ods rtf file = "&outpath.\&outname2..rtf"
        image_dpi = 300
        style = customSapphire;

proc sgplot data = adam.adslmod; 
   format trt01pn trt.;

   vbox age / group =  trt01pn extreme;
   xaxis type = discrete label = "Treatment";
   yaxis type = linear label = "Change from Baseline";
run;

ods rtf close;
ods graphics off;
