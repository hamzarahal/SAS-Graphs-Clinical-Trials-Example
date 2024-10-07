/****************************************************************************************
Program:          Program_8-8.sas

SAS Version:      SAS 9.4M3
Developer:        Hamza Rahal 
Date:             2024-09-21
Purpose:          Produce outputs for SAS® Graphics for Clinical Trials by Example book. 
Operating Sys:    Windows 10

Macros:           NONE

Input:            diabmod.sas7bdat

Output:           Display_8-2.rtf, Output_8-8.rtf

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
%let outname = Output_8-8;
%let dispname = Display_8-2;
/*****************************************/
/*** END SECTION TO BE UPDATED BY USER ***/
/*****************************************/

/* formats to display time point */
proc format;
   picture dy2mo (round)
              0 = 'Baseline' (noedit)
       1 - high = 09 (/*prefix = 'Month '*/ mult = 0.035714)
                ;

   picture dy2wk (round)
              0 = 'Baseline' (noedit)
       1 - high = 09 (/*prefix = 'Wk '*/ mult = 0.142857)
                ;
run;

/* this step is not needed since adam.diabmod is provided as a permanent data set   */
/* this is kept here so that you can see the relationship between aedecod and event */
/*
data adam.diabmod (drop = event1 event2);
   set adam.diabprof;

   if index(aedecod, 'Hypo') then event = 8;
   else if index(aedecod, 'Hyper') then event = 9;
run;
*/

proc template;
   define statgraph ptprof2;
      begingraph / border = false;

         discreteattrmap name = "evtcolor" / ignorecase = true trimleading = true;
            value 'Hypoglycemia'  / markerattrs = (symbol = diamondfilled color = red size = 6);
            value 'Hyperglycemia' / markerattrs = (symbol = trianglefilled color = orange size = 6);
         enddiscreteattrmap;

         discreteattrvar attrvar = colorevt var = aedecod attrmap = "evtcolor";       

         /* define the color attribute map */
         discreteattrmap name = "medcolor" / ignorecase = true trimleading = true;
            value 'Glucose Supplement' / lineattrs = (pattern =  1 color = green);
            value 'Elevating Agent'    / lineattrs = (pattern =  2 color = lightslategray);
            value 'Rapid-acting'       / lineattrs = (pattern = 35 color = firebrick);
            value 'Fast-acting'        / lineattrs = (pattern = 41 color = cornflowerblue);
         enddiscreteattrmap;

         discreteattrvar attrvar = colormed var = acat attrmap = "medcolor";

         layout lattice / columns = 1 rows = 2
                          rowweights = (0.7 0.3);

            layout overlay / xaxisopts = (display = (line) 
                                          griddisplay = on 
                                          gridattrs = (pattern = 35 color=libgr)
                                          linearopts = (viewmin = 0 viewmax = 240
                                                        tickvaluesequence = (start = 0 end = 168
                                                                             increment = 28))) 

                             yaxisopts = (label = 'Glucose (mg/dL)'
                                          offsetmin = 0.07 offsetmax = 0.07
                                          labelattrs = (color = firebrick weight = bold)
                                          linearopts = (viewmin = 50 viewmax = 155))
                                                                              
                             x2axisopts = (label = 'Months on Treatment'
                                           griddisplay = on 
                                           gridattrs = (pattern = 35 color=libgr)
                                           labelattrs = (color = black weight = bold)
                                           linearopts = (viewmin = 0 viewmax = 240
                                                         tickvaluelist = (0 56 112 168)
                                                         tickvalueformat = dy2mo.))

                             y2axisopts = (label = 'HbA1c (%)'
                                           offsetmin = 0.07 offsetmax = 0.07
                                           labelattrs = (color = cornflowerblue weight = bold)
                                           linearopts = (viewmin = 2 viewmax = 8));

               seriesplot x = strtday y = sgluc / display = all
                                                  markerattrs = (symbol = circlefilled 
                                                                 color = firebrick size = 6)
                                                  lineattrs = (color = firebrick
                                                               pattern = 34 thickness = 3);
         
               seriesplot x = strtday y = hba1c / xaxis = x2
                                                  yaxis = y2
                                                  display = all
                                                  markerattrs = (symbol = squarefilled 
                                                                  color = cornflowerblue size = 6)
                                                  lineattrs = (color = cornflowerblue
                                                               pattern = 12 thickness = 3);
            endlayout;
               
            layout overlay / walldisplay=none
                             xaxisopts = (label = 'Weeks on Treatment'
                                          griddisplay = on 
                                          gridattrs = (pattern = 35 color=libgr)
                                          labelattrs = (color = black weight = bold) 
                                          linearopts = (viewmin = 0 viewmax = 240
                                                        tickvaluesequence = (start = 0 end = 168
                                                                             increment = 28)
                                                        tickvalueformat = dy2wk.)) 
                             yaxisopts = (display = (line)
                                          linearopts = (viewmin = 0 viewmax = 10))
                             y2axisopts = (display = (line)
                                           linearopts = (viewmin = 0 viewmax = 10));

               scatterplot x = strtday y = event / group = colorevt yaxis = y2
                                                   name = 'evt';

               highlowplot y = med low = strtday high = endday / group = colormed
                                                                 lineattrs = (thickness = 3)
                                                                 type = line lowcap = SERIF highcap = cmcap
                                                                 name = 'med';
            endlayout;   

            sidebar / align = bottom;            
               discretelegend 'evt' / title = 'Events:' border = false exclude = (" " ".");
            endsidebar; 
            sidebar / align = bottom;            
               discretelegend 'med' / title = 'Medications:' border = false exclude = (" " ".");
            endsidebar; 
         endlayout;
      endgraph;
   end;
run;

ods rtf file = "&outpath.\&dispname..rtf"
        image_dpi = 300
        style = customSapphire;

proc print data=adam.diabmod;
run;

ods rtf close;

ods graphics on / imagefmt = png width = 5in;
ods rtf file = "&outpath.\&outname..rtf"
        image_dpi = 300
        style = customSapphire;

proc sgrender data = adam.diabmod template = ptprof2;
   where usubjid = "ABC-DEF-0001";
   *by usubjid;
run;

ods rtf close;
ods graphics off;
