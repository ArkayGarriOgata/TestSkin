//%attributes = {}

// Method: Job_trackProofsLineTrials ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 02/12/15, 13:39:40
// ----------------------------------------------------
// Description
//  find un completed job form that are non-production and show their workflow dates
//
// ----------------------------------------------------
// ---------------------------------------------------


C_DATE:C307($dateBegin)
C_LONGINT:C283($weekday)
C_TEXT:C284($body)
READ ONLY:C145([Job_Forms:42])

$dateBegin:=Current date:C33

$subject:="Proofs and Line Trials "+String:C10($dateBegin; Internal date short:K1:7)
$body:=""

// get firm releases in that date range
ARRAY TEXT:C222($aJFid; 0)
ARRAY TEXT:C222($aJFtype; 0)

ARRAY DATE:C224($aJFReleased; 0)
ARRAY DATE:C224($aJFStart; 0)
ARRAY DATE:C224($aJMLSheeted; 0)
ARRAY DATE:C224($aJMLPress; 0)
ARRAY DATE:C224($aJMLBlanked; 0)
ARRAY DATE:C224($aJMLHRD; 0)
ARRAY DATE:C224($aJFNeed; 0)
ARRAY TEXT:C222($aLine; 0)
ARRAY TEXT:C222($aDesc; 0)
//ARRAY TEXT($aCust;0)

Begin SQL
	SELECT jf.JobFormID, jf.JobType, jf.PlnnerReleased, jf.StartDate, jml.DateStockSheeted, jml.PressDate, jml.GlueReady, jml.MAD, jf.NeedDate, jf.CustomerLine, jf.JobTypeDescription
	FROM Job_Forms AS 'jf', Job_Forms_Master_Schedule AS 'jml'
	WHERE SUBSTRING(jf.JobType,1,1) in ('2', '5', '6') and jf.Completed < '01-01-1995' and jf.JobFormID = jml.JobForm
	ORDER BY jml.MAD ASC
	INTO :$aJFid, :$aJFtype, :$aJFReleased, :$aJFStart, :$aJMLSheeted, :$aJMLPress, :$aJMLBlanked, :$aJMLHRD, :$aJFNeed, :$aLine, :$aDesc;
End SQL

C_LONGINT:C283($i; $numRecs)

$numRecs:=Size of array:C274($aJFid)
$body:=""
$r:=Char:C90(13)
$t:=Char:C90(9)  //"  "

uThermoInit($numRecs; "Checking Proofs and Line Trials")
For ($i; 1; $numRecs)
	$body:=$body+$aJFid{$i}+$t+txt_Pad($aJFtype{$i}; " "; 1; 12)+$t+String:C10($aJFReleased{$i}; Internal date short:K1:7)+$t+String:C10($aJFStart{$i}; Internal date short:K1:7)+$t
	$body:=$body+String:C10($aJMLSheeted{$i}; Internal date short:K1:7)+$t+String:C10($aJMLPress{$i}; Internal date short:K1:7)+$t+String:C10($aJMLBlanked{$i}; Internal date short:K1:7)+$t
	$body:=$body+String:C10($aJMLHRD{$i}; Internal date short:K1:7)+$t+String:C10($aJFNeed{$i}; Internal date short:K1:7)+$t+$aLine{$i}+$t+$aDesc{$i}+$r
	
	uThermoUpdate($i)
End for 

uThermoClose



If (Length:C16($body)>0)
	docName:="Proofs-Line_Trials"+fYYMMDD(4D_Current_date)+".xls"
	$docRef:=util_putFileName(->docName)
	
	$body:=txt_Pad("JOBFORM"; " "; 1; 8)+$t+txt_Pad("JOB TYPE"; " "; 1; 12)+$t+txt_Pad("PLNR_REL"; " "; 1; 10)+$t+txt_Pad("STARTED"; " "; 1; 10)+$t+txt_Pad("SHEETED"; " "; 1; 10)+$t+txt_Pad("ON_PRESS"; " "; 1; 10)+$t+txt_Pad("BLANKED"; " "; 1; 10)+$t+txt_Pad("HRD"; " "; 1; 10)+$t+txt_Pad("NEEDED"; " "; 1; 10)+$t+"LINE"+$t+"JOB_DESC\r"+$body
	SEND PACKET:C103($docRef; $body)
	CLOSE DOCUMENT:C267($docRef)
	// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
	$preheader:=String:C10($numRecs)+" open proof/line trial jobs. Open attached with Excel.\rReport run each Monday and Thursday. See Job_trackProofsLineTrials."
	$body:="Attached spreadsheet has columns for: Jobform#, Job Type, Line, and Description; Dates of Planner's release, started, sheeted, on press, blanked, HRD, and Needed."
	distributionList:=Batch_GetDistributionList(""; "PROD")  //"Kristopher.Koertge@arkay.com, frank.clark@arkay.com,"+"mel.bohince@arkay.com,"
	distributionList:=distributionList+"\tNonProdJobs@arkay.com,"  // Modified by: Mel Bohince (1/17/19) 
	
	//  distributionList:="mel.bohince@arkay.com,"
	//EMAIL_Sender ($subject;"";$body;distributionList;docName)
	Email_html_body($subject; $preheader; $body; 500; distributionList; docName)
	util_deleteDocument(docName)
End if 


