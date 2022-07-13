//%attributes = {}
// -------
// Method: Job_GetNumberOfCombos   ( ) ->
// By: Mel Bohince @ 11/09/16, 16:48:04
// Description
// look for distinct product codes on a jobform
// select jobform, count(ProductCode), count(distinct(ProductCode)) from Job_Forms_Items where JobForm in (select JobFormID from Job_Forms where Completed between '09/01/16' and '09/04/16') group by jobform
// ----------------------------------------------------
C_DATE:C307($1; $2; dDateBegin; dDateEnd)
C_TEXT:C284(windowTitle; $jobform; $title; $text)
C_LONGINT:C283($winRef; $job; $numItems; $numOutlines; $formChanges; $numJobs)


If (Count parameters:C259=0)
	windowTitle:="Combo count between"
	$winRef:=OpenFormWindow(->[zz_control:1]; "DateRange2"; ->windowTitle; windowTitle)
	dDateBegin:=UtilGetDate(Current date:C33; "ThisMonth")  // the first
	$To:=UtilGetDate(Current date:C33; "ThisMonth"; ->dDateEnd)  //last day of month
	
	DIALOG:C40([zz_control:1]; "DateRange2")
	CLOSE WINDOW:C154($winRef)
	
Else 
	dDateBegin:=$1
	dDateEnd:=$2
End if 

//get a selection of jobs to evaluate, then count their distinct items in key/value
ARRAY TEXT:C222($aJobform; 0)
ARRAY LONGINT:C221($aNumItems; 0)
ARRAY LONGINT:C221($aNumOutlines; 0)
ARRAY LONGINT:C221($aNumChanges; 0)

Begin SQL
	select JobFormID from Job_Forms where Completed between :dDateBegin and :dDateEnd order by JobFormID into :$aJobform
End SQL
$numJobs:=Size of array:C274($aJobform)

ARRAY LONGINT:C221($aNumItems; $numJobs)  // store the number of distinct productcodes
ARRAY LONGINT:C221($aNumOutlines; $numJobs)  // store the number of distinct outlines
ARRAY LONGINT:C221($aNumChanges; $numJobs)  //number of (sub)form changes

For ($job; 1; $numJobs)
	$jobform:=$aJobform{$job}
	$numItems:=0
	$numOutlines:=0
	$formChanges:=0
	
	Begin SQL
		select count(distinct(ProductCode)) from Job_Forms_Items where JobForm = :$jobform into :$numItems
	End SQL
	
	$aNumItems{$job}:=$numItems
	
	Begin SQL
		select count(distinct(OutlineNumber)) from Job_Forms_Items where JobForm = :$jobform into :$numOutlines
	End SQL
	
	$aNumOutlines{$job}:=$numOutlines
	
	Begin SQL
		select max(SubFormNumber) from Job_Forms_Items where JobForm = :$jobform into :$formChanges
	End SQL
	
	$aNumChanges{$job}:=$formChanges
End for 


If ($numJobs>0)  //save a report
	
	$text:=""
	docName:="Combo_count_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
	$docRef:=util_putFileName(->docName)
	
	$title:="Combo count on jobs completed between "+String:C10(dDateBegin; Internal date short special:K1:4)+" and "+String:C10(dDateEnd; Internal date short special:K1:4)+" \r"
	$text:=$text+"Jobform\tNumCodes\tNumOutlines\tFormChanges\r"
	$numCombos:=0
	
	For ($job; 1; $numJobs)
		$text:=$text+$aJobform{$job}+"\t"+String:C10($aNumItems{$job})+"\t"+String:C10($aNumOutlines{$job})+"\t"+String:C10($aNumChanges{$job})+"\r"
		If ($aNumItems{$job}>1)
			$numCombos:=$numCombos+1
		End if 
	End for 
	
	$summary:=String:C10($numCombos)+" of "+String:C10($numJobs)+" were combos or "+String:C10(Round:C94($numCombos/$numJobs*100; 0))+" percent\r\r"
	$text:=$summary+$text
	
	SEND PACKET:C103($docRef; $Title)
	SEND PACKET:C103($docRef; $text)
	CLOSE DOCUMENT:C267($docRef)
	BEEP:C151
	ALERT:C41("The report has been save to the file named "+docName)
	$err:=util_Launch_External_App(docName)
	
Else 
	BEEP:C151
	ALERT:C41("No jobs completed between "+String:C10(dDateBegin; Internal date short special:K1:4)+" and "+String:C10(dDateEnd; Internal date short special:K1:4))
End if 
