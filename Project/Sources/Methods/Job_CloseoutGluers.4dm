//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 07/23/14, 11:36:16
// ----------------------------------------------------
// Method: Job_CloseoutGluers
// Description
// compare bud v act on gluers for closed jobs
//
// Parameters
// ----------------------------------------------------

//using <>GLUERS which currently is " 476 477 478 479 480 481 482 483 484 485 487 488 489 491 493 505 " so we don't want flat packing
// Modified by: Mel Bohince (8/8/14) added a count of make readys

C_DATE:C307(dDateBegin; $2; dDateEnd; $3)
C_TEXT:C284($customer)
C_TEXT:C284(docName; $1; $docShortName; $gluers)
C_TEXT:C284($t; $r)
$t:=Char:C90(9)
$r:=Char:C90(13)
//below not used cause :$gluers didn't work in the IN clause
$gluers:="('476', '477', '478', '480', '481', '482', '483', '484', '485')"  //Replace string(<>GLUERS;"487 488 489 491 493 505";"")
If (False:C215)
	$seeAlso:=<>GLUERS  //uInit_CostCenterGroups
End if 

If (Count parameters:C259>=2)
	docName:=$1
	dDateBegin:=$2
	dDateEnd:=$3
	$customer:="@"
	OK:=1
	bSearch:=0
	
Else 
	dDateBegin:=!00-00-00!
	dDateEnd:=!00-00-00!
	$customer:="@"
	DIALOG:C40([zz_control:1]; "DateRange2")
	docName:="GluerAnalysis_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
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
		xTitle:="Gluer Analysis for the period from "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1)+" and Customer = "+$customer
		
	Else 
		QUERY:C277([Job_Forms_CloseoutSummaries:87])
		xTitle:="Gluer Analysis for user-selected records"
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
	
	If (dDateBegin=!00-00-00!)  //sql doesn't like the zero date
		dDateBegin:=!1995-01-01!
	End if 
	
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
		where CostCenterID  in ('476', '477', '478', '479', '480', '481', '482', '483', '484', '485') and JobForm in
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
	
	
	ARRAY TEXT:C222($mtc_jobform; 0)
	ARRAY LONGINT:C221($mtc_num_mr; 0)
	Begin SQL
		select JobForm, count(MR_Act) 
		from Job_Forms_Machine_Tickets 
		where CostCenterID  in ('476', '477', '478', '479', '480', '481', '482', '483', '484', '485') and MR_Act > 0 and JobForm in
		(select JobFormID from Job_Forms where ClosedDate between :$sql_date_begin and :$sql_date_end) 
		group by JobForm
		into :$mtc_jobform, :$mtc_num_mr;
	End SQL
	
	APPEND TO ARRAY:C911($mtc_jobform; "N/F")
	APPEND TO ARRAY:C911($mtc_num_mr; 0)
	
	ARRAY TEXT:C222($jm_jobform; 0)
	ARRAY LONGINT:C221($jm_good; 0)
	ARRAY REAL:C219($jm_mr; 0)
	ARRAY REAL:C219($jm_run; 0)
	ARRAY REAL:C219($jm_rate; 0)
	
	Begin SQL
		select JobForm, sum(Planned_Qty), sum(Planned_MR_Hrs), sum(Planned_RunHrs) 
		from Job_Forms_Machines 
		where CostCenterID in ('476', '477', '478', '479', '480', '481', '482', '483', '484', '485') and JobForm in
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
	
	xText:=xText+"Job Close Outs"+$r+"Glue Run Rate"+$r+"Week Ending "+String:C10(dDateEnd)+$r+$r
	xText:=xText+$t+"JobForm"+$t+"Customer"+$t+"Line"+$t+"Bud_Rate"+$t+"Act_Rate"+$t+"Var_Rate(unfav)"+$t+"Bud_MR"+$t+"Act_MR"+$t+"Var_MR(unfav)"+$t+"Bud_Run"+$t+"Act_Run"+$t+"Var_Run(unfav)"+$t+"NumMR"+$r
	
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
		
		$hitCnt:=Find in array:C230($mtc_jobform; $jfc_jobform{$i})
		If ($hitCnt=-1)
			$hitCnt:=Size of array:C274($mtc_jobform)
		End if 
		
		If ($jm_rate{$hitBud}>0)
			xText:=xText+$t+$jfc_jobform{$i}+$t+$jfc_cust{$i}+$t+$jfc_line{$i}
			xText:=xText+$t+String:C10($jm_rate{$hitBud})+$t+String:C10($mt_rate{$hitAct})+$t+String:C10($mt_rate{$hitAct}-$jm_rate{$hitBud})
			xText:=xText+$t+String:C10($jm_mr{$hitBud})+$t+String:C10($mt_mr{$hitAct})+$t+String:C10($jm_mr{$hitBud}-$mt_mr{$hitAct})
			xText:=xText+$t+String:C10($jm_run{$hitBud})+$t+String:C10($mt_run{$hitAct})+$t+String:C10($jm_run{$hitBud}-$mt_run{$hitAct})+$t+String:C10($mtc_num_mr{$hitCnt})
			xText:=xText+$r
		End if 
		
		uThermoUpdate($i)
	End for 
	uThermoClose
	
	SEND PACKET:C103($docRef; xText)
	SEND PACKET:C103($docRef; $r+$r+"------ END OF FILE ------")
	CLOSE DOCUMENT:C267($docRef)
	
	xText:=xText+xTitle+$r+$r
	
	$err:=util_Launch_External_App(docName)
	
End if   //ok
