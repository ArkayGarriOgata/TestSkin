//%attributes = {}
// Method: Job_UnfavorableVariance ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 01/30/14, 08:15:05
// ----------------------------------------------------
// Description
// Send an email when machince job budget is unfavorable by 25%
// based on the day's machine tickets so that questions can be
// asked of operators while the job is fresh in their mind
// ----------------------------------------------------
// Modified by: Mel Bohince (2/5/14) don't report 428, 493, 503 or Qtys
// Modified by: Mel Bohince (2/28/14) show actual costcenter, not planned.
// Modified by: Mel Bohince (3/25/15) html'ize the mailing


C_LONGINT:C283($i; $num_mt; $numRecs)
C_REAL:C285($planned_MR; $planned_Run; $planned_Rate; $actual_MR; $actual_Run; $actual_Rate; $reporting_threshold)  //$planned_Qty;$actual_Qty
C_REAL:C285($variance_MR; $variance_Run; $variance_Rate; $percent_MR; $percent_Rate)  //$percent_Qty
C_TEXT:C284($tSubject; $tBodyHeader; $tText; $r; $fixed_line; $print_line; $distributionList; $2)
C_BOOLEAN:C305($break)
C_DATE:C307($target_date)


Case of 
	: (Count parameters:C259=2)
		$target_date:=$1
		$distributionList:=$2
		
	: (Count parameters:C259=1)
		$target_date:=$1
		$distributionList:=""
		
	Else 
		$target_date:=Date:C102(Request:C163("Based on what date?"; String:C10(Current date:C33; Internal date short:K1:7)))
		$distributionList:="mel.bohince@arkay.com"
End case 
//$target_date:=!03/23/2015!  //testing


READ ONLY:C145([Job_Forms_Machines:43])
READ ONLY:C145([Job_Forms_Machine_Tickets:61])

$r:=Char:C90(13)

$b:="<tr><td width=\"150\" style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"
$t:="</td><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"
$e:="</td></tr>"+$r

$fixed_line:=" "*80+$r  //going to print in fixed width columns for nonproportional font
$tSubject:="Job Budget Exception Report - "+String:C10($target_date; Internal date short:K1:7)
$tBodyHeader:="The Job Form Sequences listed below have unfavorable variance as of "+String:C10($target_date; System date long:K1:3)+"."
$tText:=""
$tableData:=""
$reporting_threshold:=20  //percent    Change it here if needed.

//Find the [Job_Forms_Machines]JobSequence's with activity today
QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5=$target_date)

//SELECTION TO ARRAY([Job_Forms_Machine_Tickets]JobForm;$mt_jobform;[Job_Forms_Machine_Tickets]Sequence;$mt_sequence_number)
//$num_mt:=Size of array($mt_jobform)
//ARRAY TEXT($mt_jobform_sequence;$num_mt)
//For ($i;1;$num_mt)
//$mt_jobform_sequence{$i}:=$mt_jobform{$i}+"."+String($mt_sequence_number{$i};"000")
//End for 
SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]JobFormSeq:16; $mt_jobform_sequence)

SORT ARRAY:C229($mt_jobform_sequence; >)
QUERY WITH ARRAY:C644([Job_Forms_Machines:43]JobSequence:8; $mt_jobform_sequence)
ORDER BY:C49([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobSequence:8; >)

//Compare planned vs actual for these targets sequences
$break:=False:C215
$numRecs:=Records in selection:C76([Job_Forms_Machines:43])
uThermoInit($numRecs; "Analyzing Records")
$row:=1
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
	
	For ($i; 1; $numRecs)
		If ($break)
			$i:=$i+$numRecs
		End if 
		
		If (Position:C15([Job_Forms_Machines:43]CostCenterID:4; " 428 493 !503 ")=0)  // Modified by: Mel Bohince (2/5/14) don't report 428, 493, 503 or Qtys
			//get the planned
			$planned_MR:=[Job_Forms_Machines:43]Planned_MR_Hrs:15
			$planned_Run:=[Job_Forms_Machines:43]Planned_RunHrs:37
			$planned_Qty:=[Job_Forms_Machines:43]Planned_Qty:10
			$planned_Rate:=[Job_Forms_Machines:43]Planned_RunRate:36
			$planned_CC:=[Job_Forms_Machines:43]CostCenterID:4  // Modified by: Mel Bohince (2/28/14) 
			If ($planned_Run>0)
				If ($planned_Rate<=0)
					$planned_Rate:=Round:C94($planned_Qty/$planned_Run; 0)
				End if 
			End if 
			
			//get the actuals
			//Now look back at the tickets associated with this machine, may be more than one.
			//QUERY([Job_Forms_Machine_Tickets];[Job_Forms_Machine_Tickets]JobForm=[Job_Forms_Machines]JobForm;*)
			//QUERY([Job_Forms_Machine_Tickets]; & ;[Job_Forms_Machine_Tickets]Sequence=[Job_Forms_Machines]Sequence)
			QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobFormSeq:16=[Job_Forms_Machines:43]JobSequence:8)
			$actual_CC:=[Job_Forms_Machine_Tickets:61]CostCenterID:2  // Modified by: Mel Bohince (2/28/14) 
			$actual_MR:=Sum:C1([Job_Forms_Machine_Tickets:61]MR_Act:6)
			$actual_Run:=Sum:C1([Job_Forms_Machine_Tickets:61]Run_Act:7)
			$actual_Qty:=Sum:C1([Job_Forms_Machine_Tickets:61]Good_Units:8)
			If ($actual_Run>0)  //get the adjusted (effective) rate
				$actual_Rate:=Round:C94($actual_Qty/$actual_Run; 0)
			Else 
				$actual_Rate:=0
			End if 
			
			//get the variance
			$variance_MR:=$actual_MR-$planned_MR  //positive is bad
			$variance_Rate:=$planned_Rate-$actual_Rate  //positive is bad
			//$variance_Qty:=$actual_Qty-$planned_Qty  //positive is bad
			
			If ($planned_MR#0)
				$percent_MR:=Round:C94($variance_MR/$planned_MR; 2)*100
			Else 
				$percent_MR:=100
			End if 
			If ($planned_Rate#0)
				$percent_Rate:=Round:C94($variance_Rate/$planned_Rate; 2)*100
			Else 
				$percent_Rate:=100
			End if 
			//If ($planned_Qty#0)
			//$percent_Qty:=Round($variance_Qty/$planned_Qty;2)*100
			//Else 
			//$percent_Qty:=100
			//End if 
			
			$print_line:=$fixed_line  //start with a fresh blank chunk, then pack in the data where needed
			If ($percent_MR>=$reporting_threshold) & ($actual_MR>0)
				$row:=$row+1
				If (($row%2)#0)  //alternate row color
					$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"  //start white $normwhite:="background-color:#ffffff"
				Else 
					$b:="<tr style=\"background-color:#fefcff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"  //`milk white, slightly darker white $milkwhite:="background-color:#fefcff"
				End if 
				$print_line:=Change string:C234($print_line; ([Job_Forms_Machines:43]JobSequence:8+" ("+$actual_CC+"): "); 1)
				$print_line:=Change string:C234($print_line; ("MR"); 21)
				$realText:=String:C10($actual_MR; "##0.0")
				$len:=Length:C16($realText)
				$print_line:=Change string:C234($print_line; $realText; 33-$len)
				
				$realText:=String:C10($planned_MR; "##0.0")
				$len:=Length:C16($realText)
				$print_line:=Change string:C234($print_line; $realText; 43-$len)
				
				$realText:=String:C10($percent_MR; "##0")+" %"
				$len:=Length:C16($realText)
				$print_line:=Change string:C234($print_line; $realText; 54-$len)
				
				$tText:=$tText+$print_line
				$tableData:=$tableData+$b+[Job_Forms_Machines:43]JobSequence:8+$t+$actual_CC+$t+"MR"+$t+String:C10($actual_MR; "##0.0")+$t+String:C10($planned_MR; "##0.0")+$t+String:C10($percent_MR; "##0")+$e
			End if 
			
			If ($percent_Rate>=$reporting_threshold) & ($actual_Rate>0)
				$row:=$row+1
				If (($row%2)#0)  //alternate row color
					$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"  //start white $normwhite:="background-color:#ffffff"
				Else 
					$b:="<tr style=\"background-color:#fefcff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"  //`milk white, slightly darker white $milkwhite:="background-color:#fefcff"
				End if 
				$print_line:=Change string:C234($print_line; ([Job_Forms_Machines:43]JobSequence:8+" ("+$actual_CC+"): "); 1)
				$print_line:=Change string:C234($print_line; ("Rate"); 21)
				$realText:=String:C10($actual_Rate; "###,##0")
				$len:=Length:C16($realText)
				$print_line:=Change string:C234($print_line; $realText; 33-$len)
				
				$realText:=String:C10($planned_Rate; "###,##0")
				$len:=Length:C16($realText)
				$print_line:=Change string:C234($print_line; $realText; 43-$len)
				
				$realText:=String:C10($percent_Rate; "##0")+" %"
				$len:=Length:C16($realText)
				$print_line:=Change string:C234($print_line; $realText; 54-$len)
				
				$tText:=$tText+$print_line
				$tableData:=$tableData+$b+[Job_Forms_Machines:43]JobSequence:8+$t+$actual_CC+$t+"Rate"+$t+String:C10($actual_Rate; "###,##0")+$t+String:C10($planned_Rate; "###,##0")+$t+String:C10($percent_Rate; "##0")+$e
			End if 
			
			// Modified by: Mel Bohince (2/5/14) don't report 428, 493, 503 or Qtys
			//If ($percent_Qty>=$reporting_threshold) & ($actual_Qty>0)
			//$tText:=$tText+[Job_Forms_Machines]JobSequence+" ("+[Job_Forms_Machines]CostCenterID+") : Actual Quantity = "+String($actual_Qty;"###,###,###")+", Budgeted Quantity = "+String($planned_Qty;"###,###,###")+", over by "+String($percent_Qty;"#,##0")+" %."+$r
			//End if 
			
		End if   //skip some cc #'s
		
		NEXT RECORD:C51([Job_Forms_Machines:43])
		uThermoUpdate($i)
	End for   //each jobform sequence
	
	
Else 
	
	ARRAY TEXT:C222($_CostCenterID; 0)
	ARRAY REAL:C219($_Planned_MR_Hrs; 0)
	ARRAY REAL:C219($_Planned_RunHrs; 0)
	ARRAY REAL:C219($_Planned_Qty; 0)
	ARRAY REAL:C219($_Planned_RunRate; 0)
	ARRAY TEXT:C222($_JobSequence; 0)
	
	SELECTION TO ARRAY:C260([Job_Forms_Machines:43]CostCenterID:4; $_CostCenterID; \
		[Job_Forms_Machines:43]Planned_MR_Hrs:15; $_Planned_MR_Hrs; \
		[Job_Forms_Machines:43]Planned_RunHrs:37; $_Planned_RunHrs; \
		[Job_Forms_Machines:43]Planned_Qty:10; $_Planned_Qty; \
		[Job_Forms_Machines:43]Planned_RunRate:36; $_Planned_RunRate; \
		[Job_Forms_Machines:43]JobSequence:8; $_JobSequence)
	
	For ($i; 1; $numRecs)
		If ($break)
			$i:=$i+$numRecs
		End if 
		
		If (Position:C15($_CostCenterID{$i}; " 428 493 !503 ")=0)  // Modified by: Mel Bohince (2/5/14) don't report 428, 493, 503 or Qtys
			//get the planned
			$planned_MR:=$_Planned_MR_Hrs{$i}
			$planned_Run:=$_Planned_RunHrs{$i}
			$planned_Qty:=$_Planned_Qty{$i}
			$planned_Rate:=$_Planned_RunRate{$i}
			$planned_CC:=$_CostCenterID{$i}  // Modified by: Mel Bohince (2/28/14) 
			If ($planned_Run>0)
				If ($planned_Rate<=0)
					$planned_Rate:=Round:C94($planned_Qty/$planned_Run; 0)
				End if 
			End if 
			
			QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobFormSeq:16=$_JobSequence{$i})
			$actual_CC:=[Job_Forms_Machine_Tickets:61]CostCenterID:2  // Modified by: Mel Bohince (2/28/14) 
			$actual_MR:=Sum:C1([Job_Forms_Machine_Tickets:61]MR_Act:6)
			$actual_Run:=Sum:C1([Job_Forms_Machine_Tickets:61]Run_Act:7)
			$actual_Qty:=Sum:C1([Job_Forms_Machine_Tickets:61]Good_Units:8)
			If ($actual_Run>0)  //get the adjusted (effective) rate
				$actual_Rate:=Round:C94($actual_Qty/$actual_Run; 0)
			Else 
				$actual_Rate:=0
			End if 
			
			//get the variance
			
			$variance_MR:=$actual_MR-$planned_MR  //positive is bad
			$variance_Rate:=$planned_Rate-$actual_Rate  //positive is bad
			
			
			If ($planned_MR#0)
				$percent_MR:=Round:C94($variance_MR/$planned_MR; 2)*100
			Else 
				$percent_MR:=100
			End if 
			If ($planned_Rate#0)
				$percent_Rate:=Round:C94($variance_Rate/$planned_Rate; 2)*100
			Else 
				$percent_Rate:=100
			End if 
			
			$print_line:=$fixed_line  //start with a fresh blank chunk, then pack in the data where needed
			If ($percent_MR>=$reporting_threshold) & ($actual_MR>0)
				$row:=$row+1
				If (($row%2)#0)  //alternate row color
					$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"  //start white $normwhite:="background-color:#ffffff"
				Else 
					$b:="<tr style=\"background-color:#fefcff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"  //`milk white, slightly darker white $milkwhite:="background-color:#fefcff"
				End if 
				$print_line:=Change string:C234($print_line; ($_JobSequence{$i}+" ("+$actual_CC+"): "); 1)
				$print_line:=Change string:C234($print_line; ("MR"); 21)
				$realText:=String:C10($actual_MR; "##0.0")
				$len:=Length:C16($realText)
				$print_line:=Change string:C234($print_line; $realText; 33-$len)
				
				$realText:=String:C10($planned_MR; "##0.0")
				$len:=Length:C16($realText)
				$print_line:=Change string:C234($print_line; $realText; 43-$len)
				
				$realText:=String:C10($percent_MR; "##0")+" %"
				$len:=Length:C16($realText)
				$print_line:=Change string:C234($print_line; $realText; 54-$len)
				
				$tText:=$tText+$print_line
				$tableData:=$tableData+$b+$_JobSequence{$i}+$t+$actual_CC+$t+"MR"+$t+String:C10($actual_MR; "##0.0")+$t+String:C10($planned_MR; "##0.0")+$t+String:C10($percent_MR; "##0")+$e
			End if 
			
			If ($percent_Rate>=$reporting_threshold) & ($actual_Rate>0)
				$row:=$row+1
				If (($row%2)#0)  //alternate row color
					$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"  //start white $normwhite:="background-color:#ffffff"
				Else 
					$b:="<tr style=\"background-color:#fefcff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"  //`milk white, slightly darker white $milkwhite:="background-color:#fefcff"
				End if 
				$print_line:=Change string:C234($print_line; ($_JobSequence{$i}+" ("+$actual_CC+"): "); 1)
				$print_line:=Change string:C234($print_line; ("Rate"); 21)
				$realText:=String:C10($actual_Rate; "###,##0")
				$len:=Length:C16($realText)
				$print_line:=Change string:C234($print_line; $realText; 33-$len)
				
				$realText:=String:C10($planned_Rate; "###,##0")
				$len:=Length:C16($realText)
				$print_line:=Change string:C234($print_line; $realText; 43-$len)
				
				$realText:=String:C10($percent_Rate; "##0")+" %"
				$len:=Length:C16($realText)
				$print_line:=Change string:C234($print_line; $realText; 54-$len)
				
				$tText:=$tText+$print_line
				$tableData:=$tableData+$b+$_JobSequence{$i}+$t+$actual_CC+$t+"Rate"+$t+String:C10($actual_Rate; "###,##0")+$t+String:C10($planned_Rate; "###,##0")+$t+String:C10($percent_Rate; "##0")+$e
			End if 
			
		End if   //skip some cc #'s
		
		uThermoUpdate($i)
	End for   //each jobform sequence
	
	
End if   // END 4D Professional Services : January 2019 
uThermoClose

If (Length:C16($tText)>0)
	$tText:="JOB SEQUENCE (C/C): DATA   ACTUAL  BUDGETED VARIANCE %"+$r+$tText  //now add the column headings
	
	$b:="<tr style=\"background-color:#fefcff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
	$t:="</td><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
	$columnHeadings:=$b+"JOB SEQ"+$t+"C/C"+$t+"DATA"+$t+"ACTUAL"+$t+"BUDGET"+$t+"VAR %"+$e
	$tableData:=$columnHeadings+$tableData
	
	If (Length:C16($distributionList)>0)
		//EMAIL_Sender ($tSubject;"";$tBodyHeader+$tText;$distributionList)
		Email_html_table($tSubject; $tBodyHeader; $tableData; 600; $distributionList)
	End if 
End if 