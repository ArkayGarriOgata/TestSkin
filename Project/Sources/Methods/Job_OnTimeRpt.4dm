//%attributes = {"publishedWeb":true}
//PM: Job_OnTimeRpt(distributionList;dateBegin) -> 
//@author mlb - 12/3/02  11:25

C_TEXT:C284($t; $cr)
C_TEXT:C284($1; xTitle; xText; $met; $late)
C_LONGINT:C283($ontime; $numJobsDue)
C_DATE:C307($promise; $period; $2)
C_REAL:C285($percent)

$t:=Char:C90(9)
$cr:=Char:C90(13)
xTitle:=""
xText:=""
$met:=""
$late:=""
$ontime:=0
If (Count parameters:C259=2)
	$period:=$2
Else 
	$period:=(4D_Current_date-7)
End if 
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
	
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]MAD:21>=$period; *)
	QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]MAD:21<=4D_Current_date; *)
	QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]OrigRevDate:20=!00-00-00!)
	CREATE SET:C116([Job_Forms_Master_Schedule:67]; "MADonly")
	
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]OrigRevDate:20>=$period; *)
	QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]OrigRevDate:20<=4D_Current_date)
	CREATE SET:C116([Job_Forms_Master_Schedule:67]; "Revved")
	
	UNION:C120("MADonly"; "Revved"; "jobsDue")
	USE SET:C118("jobsDue")
	CLEAR SET:C117("jobsDue")
	CLEAR SET:C117("MADonly")
	CLEAR SET:C117("Revved")
	
Else 
	
	C_DATE:C307($curent_date)
	$curent_date:=4D_Current_date
	
	QUERY BY FORMULA:C48([Job_Forms_Master_Schedule:67]; \
		(\
		([Job_Forms_Master_Schedule:67]MAD:21>=$period)\
		 & ([Job_Forms_Master_Schedule:67]MAD:21<=$curent_date)\
		 & ([Job_Forms_Master_Schedule:67]OrigRevDate:20=!00-00-00!)\
		)\
		 | \
		(\
		([Job_Forms_Master_Schedule:67]OrigRevDate:20>=$period)\
		 & ([Job_Forms_Master_Schedule:67]OrigRevDate:20<=$curent_date)\
		)\
		)
	
End if   // END 4D Professional Services : January 2019 


If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
	//• mlb - 12/3/02  11:19 was [JobMasterLog]ActualFirstShip  
	SELECTION TO ARRAY:C260([Job_Forms_Master_Schedule:67]GoalMetOn:62; $aGoalMet; [Job_Forms_Master_Schedule:67]MAD:21; $aMAD; [Job_Forms_Master_Schedule:67]OrigRevDate:20; $aREV; [Job_Forms_Master_Schedule:67]JobForm:4; $aJF; [Job_Forms_Master_Schedule:67]Line:5; $aCustLine)
	$numJobsDue:=Size of array:C274($aGoalMet)
	For ($i; 1; $numJobsDue)
		If ($aGoalMet{$i}#!00-00-00!)
			If ($aREV{$i}=!00-00-00!)
				$promise:=$aMAD{$i}
			Else 
				$promise:=$aREV{$i}
			End if 
			
			If ($aGoalMet{$i}<=$promise)  //looks like it was ontime
				$ontime:=$ontime+1
				$met:=$met+$cr+$aJF{$i}+" - "+$aCustLine{$i}
			Else 
				$late:=$late+$cr+$aJF{$i}+" - "+$aCustLine{$i}
			End if 
			
		Else 
			$late:=$late+$cr+$aJF{$i}+" - "+$aCustLine{$i}
		End if 
	End for 
	$percent:=Round:C94($ontime/$numJobsDue*100; 0)
	xTitle:="Ontime Production Rpt "+String:C10($period; System date short:K1:1)+" thru today"
	xText:=String:C10($percent)+"%  This report compares the date of 'GoalMetOn' from a job"+$cr
	xText:=xText+"to the MAD or Revised Date."+$cr
	xText:=xText+"A point is given for being on time or early, zero otherwise."+$cr
	xText:=xText+"Total points are divided by number of jobs shipped in this period."+$cr
	xText:=xText+"In other words, this is a tests the accuracy of your ATP dates."+$cr+$cr
	xText:=xText+"Jobs that Met the target date:"+$cr
	xText:=xText+$met+$cr+$cr
	xText:=xText+"Jobs that missed the target date:"+$cr
	xText:=xText+$late+$cr+$cr
	xText:=xText+"_______________ END OF REPORT ______________"
	QM_Sender(xTitle; ""; xText; distributionList)
End if 