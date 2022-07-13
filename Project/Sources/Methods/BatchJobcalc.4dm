//%attributes = {"publishedWeb":true}
//Procedure: BatchJobcalc()  052196  MLB
//roll up the planned productions to the cpn level
//•1/29/97 cs- added code so that this rountine will run only one time a day
//•022497  MLB  sort by array rather than by selection
// • mel (9/16/04, 14:34:14) look at jobit's that arent marked as complete
// • mel (9/16/04, 14:34:14) didn't reach yield level yet
// Modified by: Mark Zinke (11/14/12) Removed all user interface items so we can 
//  run this on the server.

C_LONGINT:C283($i; $numJobs; $JobCursor; $1)
C_LONGINT:C283($weeks; $wk)

$weeks:=12
ARRAY LONGINT:C221($aWeekNo; $weeks)

$aWeekNo{1}:=util_weekNumber(4D_Current_date)
For ($wk; 1; Size of array:C274($aWeekNo)-1)
	$aWeekNo{$wk+1}:=$aWeekNo{1}+$wk
End for 

//If (<>JobBatchDat#Current date)  //•1/29/97 skip this routine if it has already run today
If (Count parameters:C259=1)
	ARRAY TEXT:C222(<>aJMIKey; $1)
	ARRAY LONGINT:C221(<>aQty_JMI; $1)
	ARRAY LONGINT:C221(<>aQty_JMIweekly; $1; $weeks)
	
Else 
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39=!00-00-00!)  // • mel (9/16/04, 14:34:14) look at jobit's that arent marked as complete
	ARRAY TEXT:C222($aCust; 0)
	ARRAY TEXT:C222($aCPN; 0)
	ARRAY LONGINT:C221($aQty; 0)
	ARRAY LONGINT:C221($aActQty; 0)
	ARRAY DATE:C224($aHRD; 0)
	SELECTION TO ARRAY:C260([Job_Forms_Items:44]CustId:15; $aCust; [Job_Forms_Items:44]ProductCode:3; $aCPN; [Job_Forms_Items:44]Qty_Yield:9; $aQty; [Job_Forms_Items:44]Qty_Actual:11; $aActQty; [Job_Forms_Items:44]MAD:37; $aHRD)
	uClearSelection(->[Job_Forms_Items:44])
	$numJobs:=Size of array:C274($aCust)
	ARRAY TEXT:C222($aJMIKey; $numJobs)
	For ($i; 1; $numJobs)
		$aJMIKey{$i}:=$aCust{$i}+":"+$aCPN{$i}
	End for 
	ARRAY TEXT:C222($aCust; 0)
	ARRAY TEXT:C222($aCPN; 0)
	SORT ARRAY:C229($aJMIKey; $aQty; $aActQty; $aHRD; >)
	//*Over allocate array sizes for now
	ARRAY TEXT:C222(<>aJMIKey; 0)
	ARRAY TEXT:C222(<>aJMIKey; $numJobs)
	ARRAY LONGINT:C221(<>aQty_JMI; 0)
	ARRAY LONGINT:C221(<>aQty_JMI; $numJobs)
	ARRAY LONGINT:C221(<>aQty_JMIweekly; 0; 0)
	ARRAY LONGINT:C221(<>aQty_JMIweekly; $numJobs; $weeks)
	
	$jobCursor:=0  //track the use of above arrays
	
	//*Tally the job yields
	//uThermoInit ($numJobs;"Batch Job Roll-up")
	For ($i; 1; $numJobs)
		If (<>aJMIKey{$jobCursor}#$aJMIKey{$i})  //*     Set up a bucket  
			$jobCursor:=$jobCursor+1
			<>aJMIKey{$jobCursor}:=$aJMIKey{$i}
		End if 
		//*    Tally based on bin type  
		If ($aQty{$i}>$aActQty{$i})  // • mel (9/16/04, 14:34:14) didn't reach yield level yet
			<>aQty_JMI{$jobCursor}:=<>aQty_JMI{$jobCursor}+($aQty{$i}-$aActQty{$i})
			$wk:=util_weekNumber($aHRD{$i})
			$hit:=Find in array:C230($aWeekNo; $wk)
			If ($hit=-1)
				If ($wk<$aWeekNo{1})
					$hit:=1
				Else 
					$hit:=$weeks
				End if 
			End if 
			<>aQty_JMIweekly{$jobCursor}{$hit}:=<>aQty_JMIweekly{$jobCursor}{$hit}+($aQty{$i}-$aActQty{$i})
		End if 
		//uThermoUpdate ($i)
	End for 
	//uThermoClose 
	//*Shrink arrays to fit
	
	ARRAY TEXT:C222(<>aJMIKey; $jobCursor)
	ARRAY LONGINT:C221(<>aQty_JMI; $jobCursor)
	ARRAY LONGINT:C221(<>aQty_JMIweekly; $jobCursor; $weeks)
	
	//$timer:=Current time-$timer
	
	<>JobCalcDone:=True:C214
	<>JobBatchDat:=Current date:C33
End if 

//Else   //•1/29/97 make sure completed flag is set on
//<>JobCalcDone:=True
//End if 