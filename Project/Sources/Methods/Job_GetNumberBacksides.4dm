//%attributes = {}
// -------
// Method: Job_GetNumberBacksides   ( ) ->
// By: Mel Bohince @ 11/10/16, 09:00:32
// Description
// count the number of b/s (backside) jobs 
// SELECT JobForm from Job_Forms_Machines where ModDate > '07/01/16' and Flex_field6 = True and CostCenterID in ('413', '414', '417', '418', '419')
//  found dif result ignoring flex6 flag and just counting inks and coatings specified
// ----------------------------------------------------

C_DATE:C307($1; $2; dDateBegin; dDateEnd)
C_TEXT:C284(windowTitle; $jobform; $title; $text)
C_LONGINT:C283($winRef; $job; $numInks; $numCoatings; $numJobs; $sequence)


If (Count parameters:C259=0)
	windowTitle:="Backside jobs between"
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
ARRAY LONGINT:C221($aSequence; 0)
ARRAY LONGINT:C221($aNumInks; 0)
ARRAY LONGINT:C221($aNumCoatings; 0)
ARRAY LONGINT:C221($aNumRM; 0)

$pressess:=<>PRESSES  //just a marker for Find in Design, sql needs list not string
// and Flex_field6 = True
Begin SQL
	select JobForm, Sequence from Job_Forms_Machines where ModDate between :dDateBegin and :dDateEnd and CostCenterID in ('413', '414', '417', '418', '419') order by JobForm into :$aJobform, :$aSequence
End SQL
$numJobs:=Size of array:C274($aJobform)

ARRAY LONGINT:C221($aNumInks; $numJobs)  // store the number of distinct outlines
ARRAY LONGINT:C221($aNumCoatings; $numJobs)  //number of (sub)form changes
ARRAY LONGINT:C221($aNumRM; $numJobs)

For ($job; 1; $numJobs)
	$jobform:=$aJobform{$job}
	$sequence:=$aSequence{$job}
	$numInks:=0
	$numCoatings:=0
	$numRM:=0
	Begin SQL
		select count(Raw_Matl_Code) from Job_Forms_Materials where JobForm = :$jobform and Sequence = :$sequence and Commodity_Key like '02%' into :$numInks
	End SQL
	
	$aNumInks{$job}:=$numInks
	
	Begin SQL
		select count(Raw_Matl_Code) from Job_Forms_Materials where JobForm = :$jobform and Sequence = :$sequence and Commodity_Key like '03%' into :$numCoatings
	End SQL
	
	$aNumCoatings{$job}:=$numCoatings
	$aNumRM{$job}:=$numInks+$numCoatings
End for 


If ($numJobs>0)  //save a report
	
	$text:=""
	docName:="Backside_count_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
	$docRef:=util_putFileName(->docName)
	
	$title:="Backside count on sequences modified between "+String:C10(dDateBegin; Internal date short special:K1:4)+" and "+String:C10(dDateEnd; Internal date short special:K1:4)+" \r"
	$text:=$text+"Jobform\tNumInks\tNumCoatings\tNumRM\r"
	
	For ($job; 1; $numJobs)
		If ($aNumRM{$job}<3)
			$text:=$text+$aJobform{$job}+"\t"+String:C10($aNumInks{$job})+"\t"+String:C10($aNumCoatings{$job})+"\t"+String:C10($aNumRM{$job})+"\r"
		End if 
	End for 
	
	
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