/****************************************************************************************
Program:          Program_9-6.sas

SAS Version:      SAS 9.4M3
Developer:        Hamza Rahal 
Date:             2024-09-22
Purpose:          Produce outputs for SAS® Graphics for Clinical Trials by Example book. 
Operating Sys:    Windows 10

Macros:           NONE

Input:            adslmod.sas7bdat, adsl.sas7bdat, adtte.sas7bdat

Output:           Output_9-5.pdf, Output_9-5.rtf, Output_9-5.html

Comments:         Use CustomSapphire style that was provided by SAS press
                  Note CustomSapphire is not provided with SAS but rather created 
                  specifically for SAS Press books
----------------------------------------------------------------------------------------- 
****************************************************************************************/

/*******************************************/
/*** BEGIN SECTION TO BE UPDATED BY USER ***/
/*******************************************/
options validvarname=upcase;
%include "/home/rahal.hmza/Clinical graphs using SAS/Program/CustomSapphire.sas";
libname adam ("/home/rahal.hmza/Clinical graphs using SAS/Data/ADaM",
              "/home/rahal.hmza/Clinical graphs using SAS/Data/CDISC Pilot Study/adam");
%let outputpath = /home/rahal.hmza/Clinical graphs using SAS/Output;
%let outname = Output_9-5;
/*****************************************/
/*** END SECTION TO BE UPDATED BY USER ***/
/*****************************************/

ods graphics on / imagefmt = png width = 3.5in noborder;
ods pdf file = "&outpath.\&outname..pdf"
        dpi = 300 
        style = customsapphire 
        columns = 2
        startpage = no 
        bookmarkgen = no;

ods rtf file = "&outpath.\&outname..rtf"
        image_dpi = 300 
        style = customsapphire
        startpage = no;

ods html path = "&outpath.\" file = "&outname..html" 
        image_dpi = 300 
        style = customsapphire
        sge = on;


proc sgplot data = adam.adslmod noautolegend; 
   format trt01pn trt.;

   vbox age / category = trt01pn extreme;
   xaxis type = discrete label = "Treatment";
   yaxis type = linear label = "Change from Baseline";

   xaxistable n_c  / x = trt01pn location = inside separator;
   xaxistable  mean_sd min_max / x = trt01pn location = inside;
run;

proc sgplot data = adam.adslmod noautolegend; 
   format trt01pn trt.;

   vbox age / group = trt01pn extreme;
   xaxis type = discrete label = "Treatment";
   yaxis type = linear label = "Change from Baseline";
run;

proc sgplot data = adam.adsl;
   scatter x = weightbl y = heightbl / colorresponse = heightbl colormodel = twocoloraltramp
                                       markerattrs = (symbol = circlefilled size = 8);
   xaxis label = 'Mean Weight (kg)';
   yaxis label = 'Mean Height (cm)';
run;

proc lifetest data = adam.adtte plots = survival notable;
   strata trtan;   
   time aval * cnsr (0);
run;

ods pdf close;
ods rtf close;
ods html close;
ods graphics off;
