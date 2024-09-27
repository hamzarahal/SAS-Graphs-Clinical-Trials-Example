/****************************************************************************************
Program:          Program_4-3.sas
SAS Version:      SAS 9.4M3
Developer:        Hamza Rahal 
Date:             2024-09-06
Purpose:          Produce Step 3 of Napoleon Plot output for SAS® Graphics for Clinical Trials by Example book. 
Operating Sys:    Windows 7
Macros:           NONE
Input:            tfldata.napoleon_data1
Output:           Output 4-3.png
Comments:         Use CustomSapphire style that was provided by SAS press
                  Note CustomSapphire is not provided with SAS but rather created 
                  specifically for SAS Press books
----------------------------------------------------------------------------------------- 
****************************************************************************************/

/*******************************************/
/*** BEGIN SECTION TO BE UPDATED BY USER ***/
/*******************************************/
*Including Custom Sapphire Style;
%include "/home/rahal.hmza/Clinical graphs using SAS/Program/CustomSapphire.sas";
%let outputpath = /home/rahal.hmza/Clinical graphs using SAS/Output;
libname tfldata "/home/rahal.hmza/Clinical graphs using SAS/Data/TFLData";
/*****************************************/
/*** END SECTION TO BE UPDATED BY USER ***/
/*****************************************/

* Associating subject number with the order;
proc sql;
   create table format_dataset as
   select distinct order_subject as start, subjid as label, "subjfmt" as fmtname
   from tfldata.napoleon_data1;
quit;

* Creating format;
proc format cntlin=format_dataset;
run;

*Image 3;

*** Note when referencing the DiscreteattrMap directly in the discrete legend you need
to add in the type ***;
proc template;
   define statgraph napplot2;
      begingraph;

         DiscreteAttrMap name="Dose_Group";
            Value "50" / fillattrs = (color = white) lineattrs = (color = black pattern = solid);
            Value "100" / fillattrs = (color = yellow transparency = 0.3) lineattrs = (color = black pattern = solid);
            Value "200" / fillattrs = (color = darkbrown) lineattrs = (color = black pattern = solid);
         EndDiscreteAttrMap;
         DiscreteAttrVar attrvar = id_dose_group var = dose attrmap = "Dose_Group";

         DiscreteAttrMap name = "Visit_Dose_Group";
            Value "1-50" "2-50" "3-50" "4-50" / fillattrs = (color = white)
               lineattrs = (color = black pattern = solid);
            Value "1-100" "2-100" "3-100" "4-100" / fillattrs = (color = yellow transparency = 0.3)
               lineattrs=(color=black pattern=solid);
            Value "1-200" "2-200" "3-200" "4-200" / fillattrs = (color = darkbrown)
               lineattrs = (color = black pattern = solid);
         EndDiscreteAttrMap;
         DiscreteAttrVar attrvar = id_visit_dose_group var = visit_dose attrmap = "Visit_Dose_Group";

         DiscreteAttrMap name = "Response_Markers";
            Value "A" "Adverse Event" /
               markerattrs = (color = GraphData4:color symbol = squarefilled);
            Value "D" "Death" /
               markerattrs = (color = GraphData5:color symbol = squarefilled);
            Value "O" "Ongoing" /
               markerattrs = (color = GraphData6:color symbol = squarefilled);
            Value "PD" "Progressive Disease" /  
               markerattrs=(color= GraphData7:color symbol=squarefilled);
         EndDiscreteAttrMap;
         DiscreteAttrVar attrvar = id_response_markers var = result attrmap = "Response_Markers";

         layout overlay / xaxisopts = (label = "Days on Treatment"  linearopts = (viewmin = 0)) 
                          yaxisopts = (label="Patient" reverse = true);

            BarChartParm X = order_subject Y = cycledays / barwidth=0.8 
                                                           orient = horizontal 
                                                           group = id_visit_dose_group;

		    Scatterplot X = length Y = order_subject / markerattrs = (size = 12pt) 
                                                       group=id_response_markers;

		    Scatterplot X = length Y = order_subject / markercharacter = result_label 
                                                       markercharacterattrs=(size=9pt);

            DiscreteLegend "Dose_Group"/ type=fillcolor
                                         autoalign = (bottomright) 
                                         across = 1 
                                         location = inside 
                                         title = "Dose";

            DiscreteLegend "Response_Markers"/ type = marker 
                                               exclude = ("A" "D" "O" "PD") 
                                               location = outside 
                                               valign = bottom 
                                               down = 1
                                               title="Reason for Treatment Discontinuation" 
                                               titleattrs=(size=8pt) 
                                               valueattrs=(size=7pt);
         endlayout;
      endgraph;
   end;
run;

ods graphics on / reset = all maxlegendarea = 30 imagename ="Output 4-3" height = 3.33in width = 5in ;
ods listing gpath = "&outputpath" dpi = 300 style=customSapphire;

proc sgrender data = tfldata.napoleon_data1 template = napplot2;
   format order_subject subjfmt.;
run;

ods listing close;
