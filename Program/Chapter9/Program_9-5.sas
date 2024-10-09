/****************************************************************************************
Program:          Program_9-5.sas

SAS Version:      SAS 9.4M3
Developer:        Hamza Rahal 
Date:             2024-09-22
Purpose:          Produce outputs for SAS� Graphics for Clinical Trials by Example book. 
Operating Sys:    Windows 10

Macros:           NONE

Input:            NONE

Output:           STYLE 'mySapphire2' saved to ADAM.TEMPLAT

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
/*****************************************/
/*** END SECTION TO BE UPDATED BY USER ***/
/*****************************************/

/* modify CustomSapphire template to illustrate different features that can be modified with styles */
/* this template is still saved in SASUSER.TEMPLAT                                                  */
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

/* store new templates in the adam library */
ods path ADAM.TEMPLAT (update) SASUSER.TEMPLAT (read) SASHELP.TMPLMST (read);

/* modify CustomSapphire template to illustrate different features that can be modified with styles */
/* this template is now saved in ADAM.TEMPLAT                                                       */
proc template;
   define style mySapphire2;
      parent = mySapphire;

      class GraphBoxMean / markersize = 14px;
          
      class GraphColors /
         'gcdata1' = CX90B328
         'gcdata2' = cornflowerblue
         'gcdata3' = CX9D2E14
         'gdata1' = darkred
         'gdata2' = CX90B328
         'gdata3' = cornflowerblue
         ;

      class GraphData1 / markersymbol = "circlefilled";
      class GraphData2 / markersymbol = "trianglefilled";
      class GraphData3 / markersymbol = "starfilled";
   end;
run;