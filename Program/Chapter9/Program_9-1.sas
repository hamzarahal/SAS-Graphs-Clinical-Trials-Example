/****************************************************************************************
Program:          Program_9-1.sas

SAS Version:      SAS 9.4M3
Developer:        Hamza Rahal 
Date:             2024-09-22
Purpose:          Produce outputs for SAS® Graphics for Clinical Trials by Example book. 
Operating Sys:    Windows 10

Macros:           NONE

Input:            NONE

Output:           NONE

Comments:         Use CustomSapphire style that was provided by SAS press
                  Note CustomSapphire is not provided with SAS but rather created 
                  specifically for SAS Press books
----------------------------------------------------------------------------------------- 
****************************************************************************************/

/*******************************************/
/*** BEGIN SECTION TO BE UPDATED BY USER ***/
/*******************************************/
%include  "/home/rahal.hmza/Clinical graphs using SAS/Program/CustomSapphire.sas";
/*****************************************/
/*** END SECTION TO BE UPDATED BY USER ***/
/*****************************************/

proc template;
   source STYLES.SAPPHIRE / expand;
run;

proc template;
   source CustomSapphire / expand;
run;
