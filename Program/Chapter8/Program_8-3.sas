/****************************************************************************************
Program:          Program_8-3.sas

SAS Version:      SAS 9.4M3
Developer:        Hamza Rahal 
Date:             2024-09-21
Purpose:          Produce outputs for SAS® Graphics for Clinical Trials by Example book. 
Operating Sys:    Windows 10

Macros:           NONE

Input:            diabprof.sas7bdat

Output:           Output_8-3.rtf

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
%let outname = Output_8-3;
/*****************************************/
/*** END SECTION TO BE UPDATED BY USER ***/
/*****************************************/

/* formats to display time point */
proc format;
   picture dy2mo (round)
              0 = 'Baseline' (noedit)
       1 - high = 09 (/*prefix = 'Month '*/ mult = 0.035714)
                ;
run;

/* template if only producing graph for HbA1c */
proc template;
   define statgraph hba1cprof;
      begingraph / border = false;
         layout overlay / xaxisopts = (label = 'Months on Treatment'
                                       griddisplay = on 
                                       gridattrs = (pattern = 35 color=libgr)
                                       labelattrs = (color = black weight = bold)
                                       linearopts = (viewmin = 0 viewmax = 180
                                                     tickvaluelist = (0 56 112 168)
                                                     tickvalueformat = dy2mo.))
                          yaxisopts = (label = 'HbA1c (%)'
                                       offsetmin = 0.07 offsetmax = 0.07
                                       labelattrs = (color = cornflowerblue weight = bold)
                                       linearopts = (viewmin = 0 viewmax = 8));
            seriesplot x = strtday y = hba1c / display = all
                                               markerattrs = (symbol = squarefilled 
                                                              color = cornflowerblue size = 6)
                                               lineattrs = (color = cornflowerblue
                                                            pattern = 12 thickness = 3);
         endlayout;
      endgraph;
   end;
run;

ods graphics on / imagefmt = png width = 5in;
ods rtf file = "&outpath.\&outname..rtf"
        image_dpi = 300
        style = customSapphire;

/* render graph for Serum Glucose only */
title 'Graph to Illustrate Serum HbA1c Only';
proc sgrender data = adam.diabprof template = hba1cprof;
   where usubjid = "ABC-DEF-0001";
   *by usubjid;
run;

ods rtf close;
ods graphics off;
