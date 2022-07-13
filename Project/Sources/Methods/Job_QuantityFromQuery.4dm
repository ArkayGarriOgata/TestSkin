//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 10/02/15, 15:23:22
// ----------------------------------------------------
// Method: Job_QuantityFromQuery
// Description
// 
//
// ----------------------------------------------------



C_LONGINT:C283($i; $numRecs)
C_BOOLEAN:C305($break; $summary)
C_TEXT:C284($text; $r; $t)
$text:=""
$r:=Char:C90(Carriage return:K15:38)
$t:=Char:C90(Tab:K15:37)

CONFIRM:C162("Sheets or summary?"; "Summary"; "Sheets")
If (ok=1)
	$summary:=True:C214
Else 
	$summary:=False:C215
End if 
ARRAY TEXT:C222($aJobForms; 0)
CONFIRM:C162("search by Jobform or Schedule?"; "Jobform"; "Schedule")
If (ok=1)
	QUERY:C277([Job_Forms:42])
	SELECTION TO ARRAY:C260([Job_Forms:42]JobFormID:5; $aJobForms)
	$numRecs:=Size of array:C274($aJobForms)
Else 
	PS_qryPrintingOnly
	dDateBegin:=!00-00-00!
	dDateEnd:=!00-00-00!
	DIALOG:C40([zz_control:1]; "DateRange2")
	QUERY SELECTION:C341([ProductionSchedules:110]; [ProductionSchedules:110]StartDate:4>=dDateBegin; *)
	QUERY SELECTION:C341([ProductionSchedules:110]; [ProductionSchedules:110]StartDate:4<=dDateEnd)
	SELECTION TO ARRAY:C260([ProductionSchedules:110]JobSequence:8; $aJobSeqs)
	$numRecs:=Size of array:C274($aJobSeqs)
	For ($job; 1; $numRecs)
		$jobform:=Substring:C12($aJobSeqs{$job}; 1; 8)
		$hit:=Find in array:C230($aJobForms; $jobform)
		If ($hit=-1)
			APPEND TO ARRAY:C911($aJobForms; $jobform)
		End if 
	End for 
End if 

If (ok=1)
	$break:=False:C215
	$numRecs:=Size of array:C274($aJobForms)  //Records in selection([Job_Forms])
	SORT ARRAY:C229($aJobForms; >)
	uThermoInit($numRecs; "Updating Records")
	For ($job; 1; $numRecs)
		If ($break)
			$job:=$job+$numRecs
		End if 
		If ($summary)
			$text:=$text+JOB_QuantityControlSummary($aJobForms{$job})+$r
		Else 
			JOB_QuantityControlSheet($aJobForms{$job})
		End if 
		
		//NEXT RECORD([Job_Forms])
		uThermoUpdate($job)
	End for 
	
	uThermoClose
	
	If (Length:C16($text)>0)
		$headings:="Jobform"+$t+"ExistingSupply"+$t+"JobYield"+$t+"ProjectedSupply"+$t+"ReleasesCurrent"+$t+"ToAgedInventory"+$t+"TotalDemand"+$t+"RemainingInventory"+$t+"PercentToAge"+$t+"Customer"+$t+"Line"+$r
		docName:="JobQtySummary_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
		$docRef:=util_putFileName(->docName)
		SEND PACKET:C103($docRef; $headings)
		SEND PACKET:C103($docRef; $text)
		SEND PACKET:C103($docRef; $r+$r+"------ END OF FILE ------")
		CLOSE DOCUMENT:C267($docRef)
		$err:=util_Launch_External_App(docName)
	End if 
End if 