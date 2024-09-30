/****************************************************************************************
Program:          Program 5-7.sas
SAS Version:      SAS 9.4M3
Developer:        Hamza Rahal 
Date:             2024-09-19
Purpose:          Used to show how to create the dataset work.HazardRatios_Subgroup_All 
                  for SAS� Graphics for Clinical Trials by Example book. 
Operating Sys:    Windows 7
Macros:           NONE
Input:            adam.adtteeff 
output:           work.hazardratios_subgroup_all 
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
value trt
  0 = "Placebo"
  54 = "Low Dose"
  81 = "High Dose";
run;

proc format;
value $trt
  "0" = "Placebo"
  "54" = "Low Dose"
  "81" = "High Dose";
run;

proc format;
  value overfmt
        1 = "Overall";

  value agefmt
        1 = "<65"
		2 = "65-80"
		3 = ">80";

  value racefmt
        1 = "White"
		2 = "Black or African American";

  value $sexfmt
        "F" = "Female"
		"M" = "Male";
run;

* Format representing the order.;
proc format;
  value $overfmto
        "Overall" = 1;

  value $agefmto
        "<65" = 1
		"65-80" = 2
		">80" = 3;

  value $racefmto
        "White" = 1
		"Black or African American" = 2;

  value $sexfmto
        "Female" = 1
		"Male" = 2;
run;

data adtteeff;
   set adam.adtteeff;
   overall = 1;
run;

options mprint;
%macro subgroup(variable=, displayvariable=, fmt=, fmt2=, ord=);

proc sort data = adtteeff;
  by &variable.;
run;

ods output HazardRatios = HazardRatios_&variable.;
proc phreg data = adtteeff;
   by &variable.;
   class trtpn /ref=last;
   model aval * cnsr(1) = trtpn;
   hazardratio trtpn /diff=ref;
   format trtpn trt.;
run;

data HazardRatios_&variable.2(drop=&variable.);
  set HazardRatios_&variable.;
  length variable $30;
  variable = put(&variable., &fmt..);
  original_order=put(variable, &fmt2..);
  ord = &ord.;
  if variable = "Overall" then ord2 = 1;
  else ord2 = 2;
run;

* Creating Variable Headers;
data headers_&variable.;
   length variable $30 description $28;
   description = "TRTPN High Dose vs Placebo"; * Need this because there are two hazard ratios;
   variable = "&displayvariable"; 
   ord = &ord; 
   ord2 = 1; output; * This is so the order is correct when stacking the data;
   description = "TRTPN Low Dose vs Placebo";
   variable = "&displayvariable";
   ord = &ord; 
   ord2 = 1; output; * This is so the order is correct when stacking the data;
run;

data headers;  
   set %if &ord > 2 %then headers;
   headers_&variable.;
run;

data HazardRatios_Subgroup;
   %if &ord = 1 %then %do;
      set HazardRatios_&variable.2;
   %end;
   %else %if &ord > 1 %then %do;
      set HazardRatios_Subgroup HazardRatios_&variable.2; 
   %end;
run;

%mend;
%subgroup(variable=overall, fmt=overfmt, fmt2=$overfmto, ord=1);
%subgroup(variable=agegr1n, displayvariable=Age, fmt=agefmt, fmt2=$agefmto, ord=2);
%subgroup(variable=racen, displayvariable=Race, fmt=racefmt, fmt2=$racefmto, ord=3);
%subgroup(variable=sex, displayvariable=Sex, fmt=$sexfmt, fmt2=$sexfmto, ord=4);

data HazardRatios_Subgroup_All;
   set HazardRatios_Subgroup headers;
   if ord2 = 1 then do;
      indent = 0;
	  subgroup_header = "Yes";
   end;
   else do;
      indent = 1;
	  subgroup_header = "No";
   end;	
run;
