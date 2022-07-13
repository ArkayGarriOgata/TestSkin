//%attributes = {}
// -------
// Method: Job_GluingShort   ( ) ->
// By: Mel Bohince @ 09/23/16, 10:05:58
// Description
// like Job_GluingStatus but dum it down to only show short
// ----------------------------------------------------
// Modified by: Mel Bohince (9/26/16) wheels now want customer and description on the report

READ ONLY:C145([Job_Forms_Items:44])
READ ONLY:C145([Finished_Goods:26])

C_TIME:C306($docRef)
C_TEXT:C284($t; $cr)
$t:=Char:C90(9)
$cr:=Char:C90(13)
C_TEXT:C284($1)
C_DATE:C307($dateEnd; $2)

ARRAY TEXT:C222($aJobit; 0)
ARRAY TEXT:C222($aCPN; 0)
ARRAY LONGINT:C221($aWant; 0)
ARRAY LONGINT:C221($aAct; 0)
ARRAY LONGINT:C221($aShort; 0)
ARRAY DATE:C224($aCompleted; 0)

If (Count parameters:C259=0)
	//pattern_DateRange
	windowTitle:="Shortages between"
	$winRef:=OpenFormWindow(->[zz_control:1]; "DateRange2"; ->windowTitle; windowTitle)
	dDateBegin:=UtilGetDate(Current date:C33; "ThisMonth")  // the first
	$To:=UtilGetDate(Current date:C33; "ThisMonth"; ->dDateEnd)  //last day of month
	
	DIALOG:C40([zz_control:1]; "DateRange2")
	CLOSE WINDOW:C154($winRef)
	If (ok=1)
		$beginTS:=TSTimeStamp(dDateBegin; ?00:00:00?)
		$endTS:=TSTimeStamp(dDateEnd; ?23:59:59?)
		
		Begin SQL
			select Jobit, ProductCode, Qty_Want, (Qty_Want-Qty_Actual), Completed
			from Job_Forms_Items
			where CompletedTimeStamp >= :$beginTS and CompletedTimeStamp <= :$endTS and Qty_Actual < Qty_Want and JobForm not in
			(select JobFormID from job_forms where upper(status) = 'KILL' or  JobType not like '3%')
			order by Completed, ProductCode 
			INTO :$aJobit, :$aCPN, :$aWant, :$aShort, :$aCompleted
		End SQL
		
	Else 
		REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
	End if 
	
Else   //called by batch runner
	$dateEnd:=4D_Current_date
	$dateBegin:=$dateEnd-1
	$beginTS:=TSTimeStamp($dateBegin; ?23:00:00?)
	Begin SQL
		select Jobit, ProductCode, Qty_Want, (Qty_Want-Qty_Actual), Completed
		from Job_Forms_Items
		where CompletedTimeStamp > :$beginTS and Qty_Actual < Qty_Want and JobForm not in
		(select JobFormID from job_forms where upper(status) = 'KILL' or  JobType not like '3%')
		order by Completed, ProductCode 
		INTO :$aJobit, :$aCPN, :$aWant, :$aShort, :$aCompleted
	End SQL
	
End if 

C_LONGINT:C283($i; $numElements)
$numElements:=Size of array:C274($aCPN)

//get walter's cost of shortage
$text:=""
docName:="DailyJobItemShortages"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
$docRef:=util_putFileName(->docName)

If (Count parameters:C259=0)
	$Title:="Job Item Status, Custom Query Between "+String:C10(dDateBegin)+" & "+String:C10(dDateEnd)+"; "+String:C10($numElements)+" Jobits selected"+$cr+$cr
	$body:=""
Else 
	$Title:="Jobits completed short after "+TS2String($beginTS)+"; "+String:C10($numElements)+" Jobits found completed"+$cr+$cr
	$body:="Attached is a listing of job items completed short after "+TS2String($beginTS)+". "
End if 
$body:=$body+" Open the attachment with Excel."+$cr+$cr

If ($numElements>0)
	
	$text:="JOB_ITEM"+$t+"PRODUCT_CODE"+$t+"WANT"+$t+"SHORT"+$t+"LASTPRICE"+$t+"EXTENDED"+$t+"COMPLETED"+$t+"CUSTOMER"+$t+"DESCRIPTION"+$cr
	
	ARRAY REAL:C219($aLastPrice; $numElements)
	ARRAY LONGINT:C221($aExtended; $numElements)
	
	uThermoInit($numElements; "Getting pricing...")
	For ($i; 1; $numElements)
		$numFG:=qryFinishedGood("#CPN"; $aCPN{$i})
		If ($numFG>0)
			$aLastPrice{$i}:=FG_getLastPrice([Finished_Goods:26]FG_KEY:47)
			$aExtended{$i}:=Round:C94(($aShort{$i}/1000*$aLastPrice{$i}); 0)
		Else 
			$aLastPrice{$i}:=-1
			$aExtended{$i}:=0
		End if 
		
		$text:=$text+$aJobit{$i}+$t+$aCPN{$i}+$t+String:C10($aWant{$i})+$t+String:C10($aShort{$i})+$t+String:C10($aLastPrice{$i})+$t+String:C10($aExtended{$i})+$t+String:C10($aCompleted{$i}; Internal date short special:K1:4)+$t+CUST_getName([Finished_Goods:26]CustID:2; "elc")+$t+[Finished_Goods:26]CartonDesc:3+$cr
		
		uThermoUpdate($i)
	End for 
	uThermoClose
	
	$body:=$body+String:C10($numElements)+" found short."
	
Else   //no shortages
	$text:="No items ran short"+$cr
	$body:=$body+$text
End if   //shorts found

SEND PACKET:C103($docRef; $Title)
SEND PACKET:C103($docRef; $text)
CLOSE DOCUMENT:C267($docRef)
$distribution:="kristopher.koertge@arkay.com,"+"mel.bohince@arkay.com,"
$distribution:=Batch_GetDistributionList("Daily Shortages")

If (Count parameters:C259=1)
	EMAIL_Sender("Daily Gluing Shortage"; ""; $body; $distribution; docName)
	util_deleteDocument(docName)
Else 
	BEEP:C151
	ALERT:C41("The report has been save to the file named "+$cr+docName)
	$err:=util_Launch_External_App(docName)
End if 