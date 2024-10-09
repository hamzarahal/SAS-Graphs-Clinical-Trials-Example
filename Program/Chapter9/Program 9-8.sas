/****************************************************************************************
Program:          Program 9-8.sas
SAS Version:      SAS 9.4M3
Developer:        Hamza Rahal 
Date:             2024-09-22
Purpose:          Used to create the Survival plot using SGPLOT with default settings for SAS� Graphics for Clinical Trials by Example book. 
Operating Sys:    Windows 7
Macros:           NONE
Input:            adam.adtteeff     
Output:           Output 9-4.png
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

libname adam "/home/rahal.hmza/Clinical graphs using SAS/Data/ADaM";
/*****************************************/
/*** END SECTION TO BE UPDATED BY USER ***/
/*****************************************/
proc format;
value $trt
  "0" = "Placebo"
  "54" = "Low Dose"
  "81" = "High Dose";
run;

ods listing close;
ods output survivalplot = survivalplot;
proc lifetest data = adam.adtteeff plots=survival(atrisk = 0 to 210 by 30);
   time aval * cnsr(1);
   strata trtpn;
run;

ods graphics / reset = all imagename = "Display 9-4";
ods listing gpath = "&outputpath" image_dpi=96;

title1 'Product-Limit Survival Estimates';
title2 'With Number of Subjects at-Risk';

proc sgplot data=SurvivalPlot;
   step x = time y = survival / group = stratum name = 'survival';
   scatter x = time y = censored / markerattrs = (symbol = plus color = black) name = 'censored';
   scatter x = time y = censored / markerattrs = (symbol = plus) group = stratum;

   xaxistable atrisk / x = tatrisk class = stratum location = inside
                       colorgroup = stratum separator;
   keylegend 'censored' / location = inside position = topright;
   keylegend 'survival';

   yaxis min = 0;
   xaxis values = (0 to 210 by 30) label = "Days from Randomisation";
   format stratum $trt.;
run;
