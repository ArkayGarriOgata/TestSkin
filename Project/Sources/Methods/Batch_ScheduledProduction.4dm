//%attributes = {"publishedWeb":true}
//PM: Batch_ScheduledProduction()->
//@author mlb - 4/13/01  08:37
// Modified by: Mel Bohince (4/14/16) change from sales to throughput
//btw no one is on distribution
C_TEXT:C284($t; $cr)
C_TEXT:C284($1; $docName; xTitle; xText)

$t:=Char:C90(9)
$cr:=Char:C90(13)
xTitle:=""
xText:=""

READ ONLY:C145([zz_control:1])
ALL RECORDS:C47([zz_control:1])
ONE RECORD SELECT:C189([zz_control:1])
<>Auto_Ink_Percent:=Num:C11([zz_control:1]Auto_Ink_Percent:41)
If (<>Auto_Ink_Percent<=0)
	<>Auto_Ink_Percent:=0.029
End if 
<>Auto_Coating_Percent:=[zz_control:1]Auto_Coating_Percent:63
<>Auto_Corr_Percent:=[zz_control:1]Auto_Corrugate_Percent:68  // Modified by: Mel Bohince (5/15/17) 
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
	
	UNLOAD RECORD:C212([zz_control:1])
	
Else 
	
	// you have read only mode
	
End if   // END 4D Professional Services : January 2019 

READ WRITE:C146([Job_Forms_Master_Schedule:67])
QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!)
APPLY TO SELECTION:C70([Job_Forms_Master_Schedule:67]; JML_getDollars)

$thisWeek:=util_weekNumber(4D_Current_date)
$fourthWeek:=$thisWeek+4
QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]WeekNumber:38>=$thisWeek; *)
QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]WeekNumber:38<=$fourthWeek)
If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
	SELECTION TO ARRAY:C260([Job_Forms_Master_Schedule:67]WeekNumber:38; $aWeek; [Job_Forms_Master_Schedule:67]ThroughPut:86; $aDollars)
	SORT ARRAY:C229($aWeek; $aDollars; >)
	xTitle:="Job Master Sched week "+String:C10($thisWeek)+" thru "+String:C10($fourthWeek)
	xText:="WEEK"+"    "+"$ THROUGH-PUT VALUE"+$cr
	xText:=xText+"----"+"    "+"---------"+$cr
	$lastWeek:=$aWeek{1}
	$dollars:=0
	For ($i; 1; Size of array:C274($aWeek))
		If ($aWeek{$i}#$lastWeek)
			xText:=xText+" "+String:C10($lastWeek)+" "+"     "+String:C10($dollars; "###,###,###")+$cr
			$lastWeek:=$aWeek{$i}
			$dollars:=0
		End if 
		
		$dollars:=$dollars+NaNtoZero($aDollars{$i})
		
	End for 
	xText:=xText+" "+String:C10($lastWeek)+" "+"     "+String:C10($dollars; "#,###,###")+$cr
	xText:=xText+"calc by Batch_ScheduledProduction"+$cr
	xText:=xText+"Batch_FGclearPressDate and Job_SetNeedDate to follow this calc"+$cr
	xText:=xText+"_______________ END OF REPORT ______________"
	QM_Sender(xTitle; ""; xText; distributionList)
	//rPrintText ("JOBMSTR"+(fYYMMDD (4D_Current_date))+"_"+Replace string(String(Curr
End if 