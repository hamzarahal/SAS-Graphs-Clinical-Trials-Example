/****************************************************************************************
Program:          Program 7-8.sas
SAS Version:      SAS 9.4M3
Developer:        Hamza Rahal 
Date:             2024-09-21
Purpose:          Two-Way Venn Diagram with overlay equated layout and tick values. Created for the Appendix for 
                  the SAS� Graphics for Clinical Trials by Example book. 
Operating Sys:    Windows 7
Macros:           NONE
Input:            NONE
Output:           Output 7-13
Comments:         Use CustomSapphire style that was provided by SAS press
                  Note CustomSapphire is not provided with SAS but rather created 
                  specifically for SAS Press books.
                  The VennDiagramMacro was used to find the numbers that should be displayed on
                  the Venn diagram.
----------------------------------------------------------------------------------------- 
****************************************************************************************/

/*******************************************/
/*** BEGIN SECTION TO BE UPDATED BY USER ***/
/*******************************************/
goptions reset=all;
*Including Custom Sapphire Style;
%include  "/home/rahal.hmza/Clinical graphs using SAS/Program/CustomSapphire.sas";
libname adam "/home/rahal.hmza/Clinical graphs using SAS/Data/CDISC Pilot Study/adam";
libname tfldata "/home/rahal.hmza/Clinical graphs using SAS/Data/TFLData";
%let outputpath = /home/rahal.hmza/Clinical graphs using SAS/Output;
/*****************************************/
/*** END SECTION TO BE UPDATED BY USER ***/
/*****************************************/

/* Specify the ODS output path */
filename outp "&outputpath";

data data_for_plot_layout;
   do x = 1 to 100;
      y = x;
      output;
   end;
run;

proc template;
   define statgraph Venn2Way;
      begingraph / drawspace=datavalue;
      /* Plot */
      layout overlayequated / equatetype=square
                              yaxisopts=(display=(tickvalues ticks)) xaxisopts=(display=(tickvalues ticks));
         scatterplot x = x y = y / markerattrs=(size = 0);

	     /* Venn Diagram (Circles) */
         drawoval x = 37 y = 50 width = 45 height = 45 /
            display = all fillattrs = (color = red)
            transparency = 0.75 widthunit = percent heightunit = percent;

         drawoval x=63 y=50 width=45 height=45 /
            display=all fillattrs=(color=green)
            transparency=0.75 widthunit= percent heightunit =percent;

		 /* Numbers */
         drawtext "61" / x=33 y=50 anchor=center;
         drawtext "63" / x=50 y=50 anchor=center;
         drawtext "66" / x=66 y=50 anchor=center;

		 /* Labels */
         drawtext "Xanomeline Low Dose" / x=30 y=15 anchor=center width = 32;
         drawtext "Xanomeline High Dose" / x=70 y=15 anchor=center width = 32;
      endlayout;
   endgraph;
end;
run;

ods listing image_dpi=300 style = customsapphire gpath = "&outputpath";
ods graphics / reset=all imagename="Output 7-13" height=3.75in width=5in;

proc sgrender data=data_for_plot_layout template=Venn2Way;
run;
