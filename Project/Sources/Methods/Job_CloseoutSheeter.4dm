//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 07/23/14, 14:56:45
// ----------------------------------------------------
// Method: Job_CloseoutSheeter
// Description
// compare bud v act on sheeter for closed jobs
//
// Parameters
// ----------------------------------------------------
// Modified by: Mel Bohince (7/29/14) change from rate to qty


C_DATE:C307(dDateBegin; $1; $2; dDateEnd)
C_TEXT:C284($customer; $t; $r)
C_TEXT:C284(docName; $docShortName; $3; $distributionList)
$t:=Char:C90(9)
$r:=Char:C90(13)

If (Count parameters:C259>=2)
	dDateBegin:=$1
	dDateEnd:=$2
	$distributionList:=$3
	docName:="SheeterAnalysis_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
	$customer:="@"
	OK:=1
	bSearch:=0
	
Else 
	dDateBegin:=!00-00-00!
	dDateEnd:=!00-00-00!
	$customer:="@"
	DIALOG:C40([zz_control:1]; "DateRange2")
	docName:="SheeterAnalysis_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
End if 
//TRACE
If (ok=1)
	$docShortName:=docName  //capture before path is prepended
	C_TIME:C306($docRef)
	$docRef:=util_putFileName(->docName)
	
	
	xText:=""
	If (bSearch=0)
		QUERY:C277([Job_Forms_CloseoutSummaries:87]; [Job_Forms_CloseoutSummaries:87]CloseDate:19>=dDateBegin; *)
		QUERY:C277([Job_Forms_CloseoutSummaries:87];  & ; [Job_Forms_CloseoutSummaries:87]CloseDate:19<=dDateEnd; *)
		QUERY:C277([Job_Forms_CloseoutSummaries:87];  & ; [Job_Forms_CloseoutSummaries:87]Customer:2=$customer)
		xTitle:="Sheeter Analysis for the period from "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1)+" and Customer = "+$customer
		
	Else 
		QUERY:C277([Job_Forms_CloseoutSummaries:87])
		xTitle:="Sheeter Analysis for user-selected records"
		SELECTION TO ARRAY:C260([Job_Forms_CloseoutSummaries:87]CloseDate:19; $aDate)
		SORT ARRAY:C229($aDate; >)
		dDateBegin:=$aDate{1}
		dDateEnd:=$aDate{Size of array:C274($aDate)}
	End if 
	
	$numJCS:=Records in selection:C76([Job_Forms_CloseoutSummaries:87])
	
	ARRAY TEXT:C222($jfc_jobform; 0)
	ARRAY TEXT:C222($jfc_cust; 0)
	ARRAY TEXT:C222($jfc_line; 0)
	SELECTION TO ARRAY:C260([Job_Forms_CloseoutSummaries:87]JobForm:1; $jfc_jobform; [Job_Forms_CloseoutSummaries:87]Customer:2; $jfc_cust; [Job_Forms_CloseoutSummaries:87]Line:3; $jfc_line)
	SORT ARRAY:C229($jfc_jobform; $jfc_cust; $jfc_line; >)
	
	$sql_date_begin:=fYYMMDD(dDateBegin; 0; "-")
	$sql_date_end:=fYYMMDD(dDateEnd; 0; "-")
	
	ARRAY TEXT:C222($mt_jobform; 0)
	ARRAY LONGINT:C221($mt_good; 0)
	ARRAY REAL:C219($mt_mr; 0)
	ARRAY REAL:C219($mt_run; 0)
	ARRAY REAL:C219($mt_rate; 0)
	
	Begin SQL
		select JobForm, sum(Good_Units), sum(MR_Act), sum(Run_Act) 
		from Job_Forms_Machine_Tickets 
		where (CostCenterID = '428' or CostCenterID = '429') and JobForm in
		(select JobFormID from Job_Forms where ClosedDate between :$sql_date_begin and :$sql_date_end) 
		group by JobForm
		into :$mt_jobform, :$mt_good, :$mt_mr, :$mt_run;
	End SQL
	
	ARRAY REAL:C219($mt_rate; Size of array:C274($mt_jobform))  // do this separate to avoid div/0 in sql formula
	For ($i; 1; Size of array:C274($mt_jobform))
		If ($mt_run{$i}>0)
			$mt_rate{$i}:=Round:C94($mt_good{$i}/$mt_run{$i}; -2)
		Else 
			$mt_rate{$i}:=0
		End if 
	End for 
	//add one more in case jobform not found in actuals
	APPEND TO ARRAY:C911($mt_jobform; "N/F")
	APPEND TO ARRAY:C911($mt_good; 0)
	APPEND TO ARRAY:C911($mt_mr; 0)
	APPEND TO ARRAY:C911($mt_run; 0)
	APPEND TO ARRAY:C911($mt_rate; 0)
	
	ARRAY TEXT:C222($jm_jobform; 0)
	ARRAY LONGINT:C221($jm_good; 0)
	ARRAY REAL:C219($jm_mr; 0)
	ARRAY REAL:C219($jm_run; 0)
	ARRAY REAL:C219($jm_rate; 0)
	
	Begin SQL
		select JobForm, sum(Planned_Qty), sum(Planned_MR_Hrs), sum(Planned_RunHrs) 
		from Job_Forms_Machines 
		where (CostCenterID = '428' or CostCenterID = '429') and JobForm in
		(select JobFormID from Job_Forms where ClosedDate between :$sql_date_begin and :$sql_date_end) 
		group by JobForm
		into :$jm_jobform, :$jm_good, :$jm_mr, :$jm_run;
	End SQL
	
	ARRAY REAL:C219($jm_rate; Size of array:C274($jm_jobform))  // do this separate to avoid div/0 in sql formula
	For ($i; 1; Size of array:C274($jm_jobform))
		If ($jm_run{$i}>0)
			$jm_rate{$i}:=Round:C94($jm_good{$i}/$jm_run{$i}; -2)
		Else 
			$jm_rate{$i}:=0
		End if 
	End for 
	//add one more in case jobform not found in budget
	APPEND TO ARRAY:C911($jm_jobform; "N/F")
	APPEND TO ARRAY:C911($jm_good; 0)
	APPEND TO ARRAY:C911($jm_mr; 0)
	APPEND TO ARRAY:C911($jm_run; 0)
	APPEND TO ARRAY:C911($jm_rate; 0)
	
	xText:=xText+"Job Close Outs"+$r+"Sheeter Qty Variance"+$r+"Week Ending "+String:C10(dDateEnd)+$r+$r
	//xText:=xText+$t+"JobForm"+$t+"Customer"+$t+"Line"+$t+"Bud_Rate"+$t+"Act_Rate"+$t+"Var_Rate(unfav)"+$t+"Bud_MR"+$t+"Act_MR"+$t+"Var_MR(unfav)"+$t+"Bud_Run"+$t+"Act_Run"+$t+"Var_Run(unfav)"+$r
	xText:=xText+$t+"JobForm"+$t+"Customer"+$t+"Line"+$t+"Act_Qty"+$t+"Bud_Qty"+$t+"Var_Qty"+$t+"Percent>10"+$r
	
	uThermoInit($numJCS; "Gluer Analysis By Job")
	For ($i; 1; $numJCS)
		If (Length:C16(xText)>28000)  //flush the buffer
			SEND PACKET:C103($docRef; xText)
			xText:=""
		End if 
		
		$hitBud:=Find in array:C230($jm_jobform; $jfc_jobform{$i})
		If ($hitBud=-1)
			$hitBud:=Size of array:C274($jm_jobform)
		End if 
		
		$hitAct:=Find in array:C230($mt_jobform; $jfc_jobform{$i})
		If ($hitAct=-1)
			$hitAct:=Size of array:C274($mt_jobform)
		End if 
		
		If ($mt_good{$hitAct}>0)
			$var:=Round:C94(($jm_good{$hitBud}-$mt_good{$hitAct})/$jm_good{$hitBud}; 2)*100
			If (Abs:C99($var)<=10)
				$variance:=""
			Else 
				$variance:=String:C10(Abs:C99($var))
			End if 
			
			xText:=xText+$t+$jfc_jobform{$i}+$t+$jfc_cust{$i}+$t+$jfc_line{$i}
			xText:=xText+$t+String:C10($mt_good{$hitAct})+$t+String:C10($jm_good{$hitBud})+$t+String:C10($mt_good{$hitAct}-$jm_good{$hitBud})+$t+$variance
			//xText:=xText+$t+String($jm_rate{$hitBud})+$t+String($mt_rate{$hitAct})+$t+String($mt_rate{$hitAct}-$jm_rate{$hitBud})
			//xText:=xText+$t+String($jm_mr{$hitBud})+$t+String($mt_mr{$hitAct})+$t+String($jm_mr{$hitBud}-$mt_mr{$hitAct})
			//xText:=xText+$t+String($jm_run{$hitBud})+$t+String($mt_run{$hitAct})+$t+String($jm_run{$hitBud}-$mt_run{$hitAct})
			xText:=xText+$r
		End if 
		
		uThermoUpdate($i)
	End for 
	uThermoClose
	
	SEND PACKET:C103($docRef; xText)
	SEND PACKET:C103($docRef; $r+$r+"------ END OF FILE ------")
	CLOSE DOCUMENT:C267($docRef)
	
	xText:=xText+xTitle+$r+$r
	
	If (Count parameters:C259>=2)
		EMAIL_Sender(xTitle; ""; "Attached text doc"; $distributionList; docName)
		util_deleteDocument(docName)
	Else 
		$err:=util_Launch_External_App(docName)
	End if 
	
End if   //ok
