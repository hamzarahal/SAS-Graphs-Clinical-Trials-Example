/****************************************************************************************
Program:          Program_9-3.sas

SAS Version:      SAS 9.4M3
Developer:        Hamza Rahal 
Date:             2024-09-22
Purpose:          Produce outputs for SAS� Graphics for Clinical Trials by Example book. 
Operating Sys:    Windows 10

Macros:           NONE

Input:            adslmod.sas7bdat

Output:           Output_9-3.rtf

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
%let outname = Output_9-3;
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

/* modify CustomSapphire template to illustrate different features that can be modified with styles */
proc template;
   define style mySapphire;
      parent = CustomSapphire;
 
      class GraphFonts / 'GraphDataFont' = ("Courier New", 7pt); 

      /* style elements */
      class GraphWalls / lineThickness = 3px;
      class GraphOutlines / lineThickness = 3px;
      style GraphBoxWhisker from GraphBoxWhisker / lineThickness = 4px;
      style GraphBoxMedian from GraphBoxMedian / lineThickness = 4px;
      class GraphBoxMean / markersize = 10px;
      class GraphDataText / fontsize = 12pt fontweight = bold color = cadetblue;  
      class GraphLabelText / fontfamily = "Times Roman" fontstyle = italic fontsize = 12pt;
      class GraphValueText / font = GraphFonts("GraphDataFont");
   end;
run;

options nobyline nodate nonumber;
ods graphics on / imagefmt = png width = 5in noborder;
ods rtf file = "&outpath.\&outname..rtf"
        image_dpi = 300
        style = mySapphire;

proc sgplot data = adam.adslmod noautolegend; 
   format trt01pn trt.;

   vbox age / category = trt01pn extreme;
   xaxis type = discrete label = "Treatment";
   yaxis type = linear label = "Change from Baseline";

   xaxistable n_c  / x = trt01pn location = inside separator;
   xaxistable  mean_sd min_max / x = trt01pn location = inside;
run;

ods rtf close;
ods graphics off;