/****************************************************************************************
Program:          Program 2-7.sas
SAS Version:      SAS 9.4M3
Developer:        Hamza Rahal 
Date:             2024-09-17
Purpose:          Create KM plot of Time-to First Dermatological Event (in Days) by Treatment: 
                  Doing modifications with GTL Template also including summary table in outputs for SAS� Graphics for Clinical Trials by Example book.
Operating Sys:    Windows 7
Macros:           %ProvideSurvivalMacros, %SurvivalSummaryTable, and %CompileSurvivalTemplates
Input:            adam.adtte
Output:           Output 2-7.png
Comments:         Use CustomSapphire style that was provided by SAS press
                  Note CustomSapphire is not provided with SAS but rather created 
                  specifically for SAS Press books
----------------------------------------------------------------------------------------- 
****************************************************************************************/

/*******************************************/
/*** BEGIN SECTION TO BE UPDATED BY USER ***/
/*******************************************/
%include "/home/rahal.hmza/Clinical graphs using SAS/Program/CustomSapphire.sas";
%let libads = /home/rahal.hmza/Clinical graphs using SAS/Data/CDISC Pilot Study/adam;
libname adam "&libads";
%let outputpath = /home/rahal.hmza/Clinical graphs using SAS/Output;
* Program below included macros to edit Survival Graph;
%include "/home/rahal.hmza/Clinical graphs using SAS/Program/TEMPLFT.sas";

/*****************************************/
/*** END SECTION TO BE UPDATED BY USER ***/
/*****************************************/

* Formats;

proc format;
value trt
  1 = "Placebo"
  2 = "Low Dose"
  3 = "High Dose";

value trttot
    1-3=99;

value trtp
  1 = "Placebo"
  2 = "Xanomeline Low Dose"
  3 = "Xanomeline High Dose"
  99= "Total";
run;

data adtte;
   set adam.adtte;
   if trta = "Placebo" then trtan = 1;
   else if trta = "Xanomeline Low Dose" then trtan = 2;
   else if trta = "Xanomeline High Dose" then trtan = 3;
run;

%ProvideSurvivalMacros;
%let TitleText2 ="KM plot of Time-to First Dermatological Event (in Days) by Treatment";
%let yOptions = label="Probability";
%SurvivalSummaryTable;

%CompileSurvivalTemplates;

ods listing image_dpi=300 style = customsapphire gpath = "&outputpath" ;
ods graphics / reset=all imagename="Output 2-7" height=3.33in width=5in;
proc lifetest data = adtte plots=survival(atrisk=0 to 210 by 30);
   time aval * cnsr(1);
   strata trtan;
run;

proc template;
   delete Stat.Lifetest.Graphics.ProductLimitSurvival / store=sasuser.templat;
run;
