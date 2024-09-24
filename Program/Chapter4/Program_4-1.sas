/****************************************************************************************
Program:          Program_4-1.sas
SAS Version:      SAS 9.4M3
Developer:        Kriss Harris 
Date:             2020-08-06
Purpose:          Produce Step 1 of Napoleon Plot output for SAS® Graphics for Clinical Trials by Example book. 
Operating Sys:    Windows 7
Macros:           NONE
Input:            tfldata.napoleon_data1
Output:           Output 4-1.png
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

*Image 1;

*** Note when referencing the DiscreteattrMap directly in the discrete legend you need
to add in the type ***;
proc template;
   define statgraph napplot1;
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

         layout overlay / xaxisopts = (label = "Days on Treatment"  linearopts = (viewmin = 0)) 
                          yaxisopts = (label="Patient" reverse = true);

            BarChartParm X = order_subject Y = cycledays / barwidth=0.8 
                                                           orient = horizontal 
                                                           group = id_visit_dose_group;

            DiscreteLegend "Dose_Group"/ type=fillcolor
                                         autoalign = (bottomright) 
                                         across = 1 
                                         location = inside 
                                         title = "Dose";
         endlayout;
      endgraph;
   end;
run;

ods graphics on / reset = all imagename ="Output 4-1" height = 3.33in width = 5in ;
ods listing gpath = "&outputpath" dpi = 300 style=customSapphire;

proc sgrender data = tfldata.napoleon_data1 template = napplot1;
   format order_subject subjfmt.;
run;

ods listing close;
