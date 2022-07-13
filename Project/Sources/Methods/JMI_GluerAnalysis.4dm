//%attributes = {}

// Method: JMI_GluerAnalysis ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 04/08/14, 15:28:04
// ----------------------------------------------------
// Description
// look for problems with run rate
//
// ----------------------------------------------------

READ ONLY:C145([Finished_Goods_Transactions:33])
READ ONLY:C145([Job_Forms_Machines:43])
READ ONLY:C145([Job_Forms_Items:44])
READ ONLY:C145([Job_Forms_Machine_Tickets:61])
C_REAL:C285($ttl_hrs; $mr; $run; $reporting_threshold)
C_LONGINT:C283($ttl_units; $cnt_of_gluers)
C_DATE:C307($target_date)
C_TEXT:C284($fixed_line; $tSubject; $tBodyHeader; $tText; $gluer_ids; $distributionList; $2)

//Look for items completed two days ago, that actually glued, see also PSG_Transaction
If (Count parameters:C259>0)
	$target_date:=$1
	$distributionList:=$2
Else 
	$target_date:=Date:C102(Request:C163("Based on what date?"; String:C10(Current date:C33; Internal date short:K1:7)))
	$distributionList:=Email_WhoAmI
End if 
//$target_date:=!04/07/2014!  //testing
//utl_LogIt ("init")

$r:="</td></tr>"+Char:C90(13)
$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"

$fixed_line:=" "*80+$r  //going to print in fixed width columns for nonproportional font
$tSubject:="Job Item Exception Report - "+String:C10($target_date; Internal date short:K1:7)
$tBodyHeader:="The Job Form Items listed below have unfavorable variance as of "+String:C10($target_date; System date long:K1:3)+":"+$r+$r
$tText:=""
$reporting_threshold:=25  //percent    Change it here if needed.

$gluer_ids:=txt_Trim(<>GLUERS)  //load all gluers in an array for a build query below
$cnt_of_gluers:=Num:C11(util_TextParser(16; $gluer_ids; Character code:C91(" "); 13))



If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	zwStatusMsg("Pls wait"; "Looking for FG Receipts from yesterday...")
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3=$target_date; *)
	QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Receipt")
	SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]Jobit:31; $aFGT_jobits)
	zwStatusMsg("Pls wait"; "Looking for Jobits for those transactions that were completed...")
	QUERY WITH ARRAY:C644([Job_Forms_Items:44]Jobit:4; $aFGT_jobits)
	QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39=$target_date)
	
	zwStatusMsg("Done"; "Found "+String:C10(Records in selection:C76([Job_Forms_Items:44])))
	
Else 
	
	//zwStatusMsg ("Pls wait";"Looking for FG Receipts from yesterday...")
	zwStatusMsg("Pls wait"; "Looking for Jobits for those transactions that were completed...")
	QUERY BY FORMULA:C48([Job_Forms_Items:44]; \
		([Job_Forms_Items:44]Completed:39=$target_date)\
		 & ([Job_Forms_Items:44]Jobit:4=[Finished_Goods_Transactions:33]Jobit:31)\
		 & ([Finished_Goods_Transactions:33]XactionDate:3=$target_date)\
		 & ([Finished_Goods_Transactions:33]XactionType:2="Receipt")\
		)
	
	zwStatusMsg("Done"; "Found "+String:C10(Records in selection:C76([Job_Forms_Items:44])))
	
End if   // END 4D Professional Services : January 2019 query selection

//Now for each of these look at the MachineTickets
C_LONGINT:C283($i; $numRecs)
C_BOOLEAN:C305($break)

$break:=False:C215
$numRecs:=Records in selection:C76([Job_Forms_Items:44])
ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4; >)
$lastJobit:=""  //this will weedout subforms
$lastJobform:=""  //need to allocate budget jobsequence to jobitems of the form, once per form

uThermoInit($numRecs; "Looking up Machine Tickets")
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
	
	For ($i; 1; $numRecs)
		If ($break)
			$i:=$i+$numRecs
		End if 
		
		If ($lastJobform#[Job_Forms_Items:44]JobForm:1)
			$lastJobform:=[Job_Forms_Items:44]JobForm:1
			//find the glue sequences in this form's budget
			QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=[Job_Forms_Items:44]JobForm:1)
			QUERY SELECTION:C341([Job_Forms_Machines:43]; [Job_Forms_Machines:43]CostCenterID:4=util_TextParser(1); *)
			For ($gluer; 2; $cnt_of_gluers)
				QUERY SELECTION:C341([Job_Forms_Machines:43];  | ; [Job_Forms_Machines:43]CostCenterID:4=util_TextParser($gluer); *)
			End for 
			QUERY SELECTION:C341([Job_Forms_Machines:43])
			
			If (Records in selection:C76([Job_Forms_Machines:43])>0)  //some gluer(s) specified
				//$mr:=Sum([Job_Forms_Machines]Planned_MR_Hrs)
				//$run:=Sum([Job_Forms_Machines]Planned_RunHrs)
				//$ttl_hrs:=$mr+$run
				//
				//$planned_MR:=$mr
				$planned_Rate:=Max:C3([Job_Forms_Machines:43]Planned_RunRate:36)
			End if 
			
		End if 
		
		If ($lastJobit#[Job_Forms_Items:44]Jobit:4)  //not a subform
			$lastJobit:=[Job_Forms_Items:44]Jobit:4
			
			QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Jobit:23=[Job_Forms_Items:44]Jobit:4)
			If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
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
				//$variance_MR:=$actual_MR-$planned_MR  //positive is bad
				$variance_Rate:=$planned_Rate-$actual_Rate  //positive is bad
				//$variance_Qty:=$actual_Qty-$planned_Qty  //positive is bad
				
				//If ($planned_MR#0)
				//$percent_MR:=Round($variance_MR/$planned_MR;2)*100
				//Else 
				//$percent_MR:=100
				//End if 
				If ($planned_Rate#0)
					$percent_Rate:=Round:C94($variance_Rate/$planned_Rate; 2)*100
				Else 
					$percent_Rate:=100
				End if 
				
				$print_line:=$fixed_line  //start with a fresh blank chunk, then pack in the data where needed
				//If ($percent_MR>=$reporting_threshold) & ($actual_MR>0)
				//$print_line:=Change string($print_line;([Job_Forms_Machines]JobSequence+" ("+$actual_CC+"): ");1)
				//$print_line:=Change string($print_line;("MR");21)
				//$realText:=String($actual_MR;"##0.0")
				//$len:=Length($realText)
				//$print_line:=Change string($print_line;$realText;33-$len)
				//
				//$realText:=String($planned_MR;"##0.0")
				//$len:=Length($realText)
				//$print_line:=Change string($print_line;$realText;43-$len)
				//
				//$realText:=String($percent_MR;"##0")+" %"
				//$len:=Length($realText)
				//$print_line:=Change string($print_line;$realText;54-$len)
				//
				//$tText:=$tText+$print_line
				//  //$tText:=$tText+[Job_Forms_Machines]JobSequence+" ("+[Job_Forms_Machines]CostCenterID+") : Actual MR   = "+String($actual_MR;"##0.0")+", Budgeted MR   = "+String($planned_MR;"##0.0")+", over by "+String($percent_MR;"#,#00")+" %."+$r
				//End if 
				
				If ($percent_Rate>=$reporting_threshold) & ($actual_Rate>0)
					//$print_line:=Change string($print_line;([Job_Forms_Items]Jobit+" ("+$actual_CC+"): ");1)
					//$print_line:=Change string($print_line;("Rate");21)
					//$realText:=String($actual_Rate;"###,##0")
					//$len:=Length($realText)
					//$print_line:=Change string($print_line;$realText;33-$len)
					//
					//$realText:=String($planned_Rate;"###,##0")
					//$len:=Length($realText)
					//$print_line:=Change string($print_line;$realText;43-$len)
					//
					//$realText:=String($percent_Rate;"##0")+" %"
					//$len:=Length($realText)
					//$print_line:=Change string($print_line;$realText;54-$len)
					$tText:=$tText+$b+[Job_Forms_Items:44]Jobit:4+$t+$actual_CC+$t+"Rate"+$t+String:C10($actual_Rate; "###,##0")+$t+String:C10($planned_Rate; "###,##0")+$t+String:C10($percent_Rate; "##0")+$r
					//$tText:=$tText+$print_line
					//$tText:=$tText+[Job_Forms_Machines]JobSequence+" ("+[Job_Forms_Machines]CostCenterID+") : Actual Rate = "+String($actual_Rate;"###,##0")+", Budgeted Rate = "+String($planned_Rate;"###,##0")+", under by "+String($percent_Rate;"#,#00")+" %."+$r
					
					//utl_LogIt ($print_line)
					
				End if 
				
			End if   //machine ticket found
			
		End if   //not a subform
		
		
		
		NEXT RECORD:C51([Job_Forms_Items:44])
		uThermoUpdate($i)
	End for 
	
Else 
	
	ARRAY TEXT:C222($_cnt_of_gluers; $cnt_of_gluers)
	For ($Iter; 1; $cnt_of_gluers; 1)
		$_cnt_of_gluers{$Iter}:=util_TextParser($Iter)
	End for 
	
	SELECTION TO ARRAY:C260([Job_Forms_Items:44]JobForm:1; $_JobForm; \
		[Job_Forms_Items:44]Jobit:4; $_Jobit)
	
	For ($i; 1; $numRecs; 1)
		
		If ($lastJobform#$_JobForm{$i})
			$lastJobform:=$_JobForm{$i}
			QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=$_JobForm{$i})
			QUERY SELECTION WITH ARRAY:C1050([Job_Forms_Machines:43]CostCenterID:4; $_cnt_of_gluers)
			
			If (Records in selection:C76([Job_Forms_Machines:43])>0)  //some gluer(s) specified
				$planned_Rate:=Max:C3([Job_Forms_Machines:43]Planned_RunRate:36)
			End if 
			
		End if 
		
		If ($lastJobit#$_Jobit{$i})  //not a subform
			$lastJobit:=$_Jobit{$i}
			
			QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Jobit:23=$_Jobit{$i})
			If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
				$actual_CC:=[Job_Forms_Machine_Tickets:61]CostCenterID:2  // Modified by: Mel Bohince (2/28/14) 
				$actual_MR:=Sum:C1([Job_Forms_Machine_Tickets:61]MR_Act:6)
				$actual_Run:=Sum:C1([Job_Forms_Machine_Tickets:61]Run_Act:7)
				$actual_Qty:=Sum:C1([Job_Forms_Machine_Tickets:61]Good_Units:8)
				If ($actual_Run>0)  //get the adjusted (effective) rate
					$actual_Rate:=Round:C94($actual_Qty/$actual_Run; 0)
				Else 
					$actual_Rate:=0
				End if 
				$variance_Rate:=$planned_Rate-$actual_Rate  //positive is bad
				If ($planned_Rate#0)
					$percent_Rate:=Round:C94($variance_Rate/$planned_Rate; 2)*100
				Else 
					$percent_Rate:=100
				End if 
				
				$print_line:=$fixed_line  //start with a fresh blank chunk, then pack in the data where needed
				
				If ($percent_Rate>=$reporting_threshold) & ($actual_Rate>0)
					
					$tText:=$tText+$b+$_Jobit{$i}+$t+$actual_CC+$t+"Rate"+$t+String:C10($actual_Rate; "###,##0")+$t+String:C10($planned_Rate; "###,##0")+$t+String:C10($percent_Rate; "##0")+$r
					
				End if 
			End if   //machine ticket found
		End if   //not a subform
		
		uThermoUpdate($i)
	End for 
	
End if   // END 4D Professional Services : January 2019 

uThermoClose

//utl_LogIt ("show")
If (Length:C16($tText)>0)
	//$tText:="JOB ITEM     (C/C): DATA   ACTUAL  BUDGETED VARIANCE %"+$r+$tText  //now add the column headings
	$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
	$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
	$tText:=$b+"JOB ITEM"+$t+"C/C"+$t+"DATA"+$t+"ACTUAL"+$t+"BUDGET"+$t+"VAR%"+$r+$tText  //now add the column headings
	//EMAIL_Sender ($tSubject;"TESTING";$tBodyHeader+$tText;"mel.bohince@arkay.com")  //testing
	If (Length:C16($distributionList)>0)
		//EMAIL_Sender ($tSubject;"";$tBodyHeader+$tText;$distributionList)
		Email_html_table($tSubject; $tBodyHeader; $tText; 550; $distributionList)
	End if 
End if 

