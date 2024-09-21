/****************************************************************************************
Program:          Program 2-5.sas
SAS Version:      SAS 9.4M3
Developer:        Hamza Rahal 
Date:             2024-09-16
Purpose:          Create KM plot of Time-to First Dermatological Event (in Days) by Treatment outputs for SAS� Graphics for Clinical Trials by Example book.
Operating Sys:    Windows 7
Macros:           NONE
Input:            adam.adtte
Output:           Output 2-5.png
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

ods listing style=customsapphire gpath = "&outputpath." dpi=300; 
ods graphics /reset=all imagename="Output 2-5" imagefmt=png height=3.33in width=5in;

ods select survivalplot;
proc lifetest data = adtte plots=survival(atrisk=0 to 210 by 30);
   time aval * cnsr(1);
   strata trtan;
run;
