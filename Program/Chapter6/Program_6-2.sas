/****************************************************************************************
Program:          Program_6-2.sas

SAS Version:      SAS 9.4M3
Developer:        Hamza Rahal 
Date:             2024-09-19
Purpose:          Produce outputs for SAS� Graphics for Clinical Trials by Example book. 
Operating Sys:    Windows 10

Macros:           NONE

Input:            adtmdmod.sas7bdat

Output:           Output_6-1.rtf

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
%let outputpath = /home/rahal.hmza/Clinical graphs using SAS/Output;
libname adam "/home/rahal.hmza/Clinical graphs using SAS/Data/ADaM";
libname tfldata "/home/rahal.hmza/Clinical graphs using SAS/Data/TFLData";
%let outname = Output_6-1;
/*****************************************/
/*** END SECTION TO BE UPDATED BY USER ***/
/*****************************************/

proc format;
   picture vis
            -1 = 'Screening' (noedit)
             0 = 'Baseline' (noedit)
      1 - high = 09 (prefix = 'Month ');
run;

title;

options nobyline nodate nonumber;
ods graphics on / imagefmt = png width = 5in noborder;
ods rtf file = "&outpath.\&outname..rtf"
        image_dpi = 300
        style = customSapphire;

proc template;
   define statgraph tumd;
      begingraph;
         dynamic _byval_ _byval2_;
         entrytitle halign = left textattrs = (size = 11pt) "Patient: " _byval2_;
         entrytitle halign = left textattrs = (size = 11pt) "Treatment: " _byval_;

         layout overlay / xaxisopts = (type = linear 
                                       linearopts = (tickvaluesequence = (start = -1 end = 6 increment = 1)
                                                     tickvaluefitpolicy = rotatealways
                                                     tickvaluerotation = diagonal))
                          yaxisopts = (type = linear label = 'Longest Diameter (mm)'
                                       labelattrs = (size = 7pt)
                                       linearopts = (viewmin = 0 viewmax = 60)
                                       griddisplay = on
                                       gridattrs = (pattern = 35 color = libgr))
                          y2axisopts = (type = linear label = 'Sum of Longest Diameters (mm)'
                                       labelattrs = (size = 7pt)
                                       linearopts = (viewmin = 0 viewmax = 135));

            barchart x = avisitn y = sumldiam / yaxis = y2 name = 'SumLD';
            seriesplot x = avisitn y = aval / name = 'LDiam' group = tuloc;

            discretelegend 'SumLD' 'LDiam'/ location=outside title = 'Longest Diameter';
         endlayout;
      endgraph;
   end;
run;

proc sgrender data = adam.adtmdmod template = tumd;
   by trtp usubjid;
   format avisitn vis.;
   where usubjid ? '1015';
run;

ods rtf close;
ods graphics off;