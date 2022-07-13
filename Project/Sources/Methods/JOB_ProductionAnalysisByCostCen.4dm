//%attributes = {}
// Method: JOB_ProductionAnalysisByCostCen () -> 
// ----------------------------------------------------
// by: mel: 11/10/03, 12:13:48
// ----------------------------------------------------
// Description:
// based on mRptPAR, but fix and save to Excel
// Modified by: Mel Bohince (2/17/14) don't require budget values, so 503 shows up
// Modified by: Mel Bohince (10/18/16) missing random machtick, add sort and load first rec before looping
// Modified by: Mel Bohince (8/10/21) remove server side option, setup local aStdCC arrays and lock in 4D-PS changes

C_TEXT:C284(xText; xTitle; $client_call_back; $1; $methodNameOnClient; $2; docName; $3; $docShortName)
C_DATE:C307(dFrom; dTo; $To; $4; $5)
C_LONGINT:C283(cb1)

// Modified by: Mel Bohince (8/10/21) setup local $_aStdCC arrays
ARRAY TEXT:C222($_aStdCC; 0)
ARRAY TEXT:C222($_aCostCtrDes; 0)
ARRAY TEXT:C222($_aCostCtrGroup; 0)
READ ONLY:C145([Cost_Centers:27])
ALL RECORDS:C47([Cost_Centers:27])
SELECTION TO ARRAY:C260([Cost_Centers:27]ID:1; $_aStdCC; [Cost_Centers:27]Description:3; $_aCostCtrDes; [Cost_Centers:27]cc_Group:2; $_aCostCtrGroup)
MULTI SORT ARRAY:C718($_aCostCtrGroup; >; $_aStdCC; >; $_aCostCtrDes; >)
// end Modified by: Mel Bohince (8/10/21) setup local $_aStdCC arrays

SET MENU BAR:C67(4)
DEFAULT TABLE:C46([Job_Forms_Machine_Tickets:61])
DIALOG:C40([Job_Forms_Machine_Tickets:61]; "Select4.5A")
ERASE WINDOW:C160
zDefFilePtr:=->[Job_Forms_Machine_Tickets:61]
$client_call_back:=""
docName:="Prod_Analysis_by_CC_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
$methodNameOnClient:=""


$docShortName:=docName  //capture before path is prepended
C_TIME:C306($docRef)
$docRef:=util_putFileName(->docName)

If (dFrom#!00-00-00!)
	If (dTo=!00-00-00!)
		dTo:=dFrom
	End if 
	
	If (cb1=1)
		
		QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms:42]JobType:33="3@"; *)
		QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms:42]JobFormID:5#"020@"; *)
		
	End if 
	
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5>=dFrom; *)
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5<=dTo)
	
	
	
	If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
		ORDER BY:C49([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobFormSeq:16; >)  // Modified by: Mel Bohince (10/18/16) missing random machtick, add sort and load first rec before looping
		
		CostCtrCurrent("init"; "00/00/00")
		
		
		zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Job_Forms_Machines:43])+" file. Please Wait...")
		ARRAY TEXT:C222($_JobForm; 0)
		DISTINCT VALUES:C339([Job_Forms_Machine_Tickets:61]JobForm:1; $_JobForm)
		QUERY WITH ARRAY:C644([Job_Forms_Machines:43]JobForm:1; $_JobForm)
		zwStatusMsg(""; "")
		
		C_LONGINT:C283($i; $numMJ)
		$numMJ:=Records in selection:C76([Job_Forms_Machines:43])
		ARRAY TEXT:C222($aMJform; 0)
		ARRAY INTEGER:C220($aMJseq; 0)
		ARRAY REAL:C219($_aMJmrHrs; 0)
		ARRAY REAL:C219($_aMJrunHrs; 0)
		ARRAY REAL:C219($_aMJsheets; 0)
		SELECTION TO ARRAY:C260([Job_Forms_Machines:43]JobForm:1; $aMJform; [Job_Forms_Machines:43]Sequence:5; $aMJseq; [Job_Forms_Machines:43]Planned_MR_Hrs:15; $_aMJmrHrs; [Job_Forms_Machines:43]Planned_RunHrs:37; $_aMJrunHrs; [Job_Forms_Machines:43]Planned_Qty:10; $_aMJsheets)
		REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
		ARRAY TEXT:C222($_aMJsequence; $numMJ)
		For ($i; 1; $numMJ)
			$_aMJsequence{$i}:=$aMJform{$i}+String:C10($aMJseq{$i}; "000")  // [Job_Forms_Machines]JobSequence
		End for 
		ARRAY TEXT:C222($aMJform; 0)
		ARRAY INTEGER:C220($aMJseq; 0)
		SORT ARRAY:C229($_aMJsequence; $_aMJmrHrs; $_aMJsheets; $_aMJrunHrs; >)
		
		C_LONGINT:C283($numElements)
		$numElements:=Size of array:C274($_aStdCC)
		ARRAY REAL:C219($aCCmrHrs; $numElements)
		ARRAY REAL:C219($aCCrunHrs; $numElements)
		ARRAY LONGINT:C221($aCCsheets; $numElements)
		ARRAY REAL:C219($aCCmrAct; $numElements)
		ARRAY REAL:C219($aCCrunAct; $numElements)
		ARRAY LONGINT:C221($aCCshtAct; $numElements)
		ARRAY REAL:C219($aCCdown; $numElements)
		ARRAY REAL:C219($aCCrate; $numElements)
		ARRAY REAL:C219($aCCadjRun; $numElements)
		
		C_LONGINT:C283($i; $numRecs)
		C_BOOLEAN:C305($break)
		$break:=False:C215
		
		
		$numRecs:=Records in selection:C76([Job_Forms_Machine_Tickets:61])
		
		
		uThermoInit($numRecs; "Gathering data for Production Analysis")
		
		ARRAY TEXT:C222($_CostCenterID; 0)
		ARRAY REAL:C219($_MR_Act; 0)
		ARRAY REAL:C219($_Run_Act; 0)
		ARRAY LONGINT:C221($_Good_Units; 0)
		ARRAY REAL:C219($_DownHrs; 0)
		ARRAY TEXT:C222($_JobForm; 0)
		ARRAY INTEGER:C220($_Sequence; 0)
		
		SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]CostCenterID:2; $_CostCenterID; \
			[Job_Forms_Machine_Tickets:61]MR_Act:6; $_MR_Act; \
			[Job_Forms_Machine_Tickets:61]Run_Act:7; $_Run_Act; \
			[Job_Forms_Machine_Tickets:61]Good_Units:8; $_Good_Units; \
			[Job_Forms_Machine_Tickets:61]DownHrs:11; $_DownHrs; \
			[Job_Forms_Machine_Tickets:61]JobForm:1; $_JobForm; \
			[Job_Forms_Machine_Tickets:61]Sequence:3; $_Sequence)
		
		For ($i; 1; $numRecs; 1)
			
			$hit:=Find in array:C230($_aStdCC; $_CostCenterID{$i})
			If ($hit>-1)
				$aCCmrAct{$hit}:=$aCCmrAct{$hit}+$_MR_Act{$i}
				$aCCrunAct{$hit}:=$aCCrunAct{$hit}+$_Run_Act{$i}
				$aCCshtAct{$hit}:=$aCCshtAct{$hit}+$_Good_Units{$i}
				$aCCdown{$hit}:=$aCCdown{$hit}+$_DownHrs{$i}
				
				$jobit:=Find in array:C230($_aMJsequence; ($_JobForm{$i}+String:C10($_Sequence{$i}; "000")))
				If ($jobit>-1)
					$aCCmrHrs{$hit}:=$aCCmrHrs{$hit}+$_aMJmrHrs{$jobit}
					$aCCrunHrs{$hit}:=$aCCrunHrs{$hit}+$_aMJrunHrs{$jobit}
					$aCCsheets{$hit}:=$aCCsheets{$hit}+$_aMJsheets{$jobit}
					If ($aCCsheets{$hit}>0)
						$aCCrate{$hit}:=Round:C94($aCCsheets{$hit}/$aCCrunHrs{$hit}; -2)
					Else 
						$aCCrate{$hit}:=0
					End if 
					$_aMJsequence{$jobit}:=""
					$_aMJmrHrs{$jobit}:=0
					$_aMJrunHrs{$jobit}:=0
					$_aMJsheets{$jobit}:=0
				End if 
				If ($aCCrate{$hit}>0)
					$aCCadjRun{$hit}:=$aCCshtAct{$hit}/$aCCrate{$hit}
				Else 
					$aCCadjRun{$hit}:=0
				End if 
			End if 
			
			uThermoUpdate($i)
		End for 
		
		
		uThermoClose
		
		C_TEXT:C284($t; $cr)
		$t:=","
		$cr:="\r"
		xTitle:="Production Analysis Report from "+String:C10(dFrom; System date short:K1:1)+" to "+String:C10(dTo; System date short:K1:1)
		xText:="CostCtrGroup"+$t+"CC"+$t+"Name"+$t
		xText:=xText+"Act_Qty"+$t+"Bud_Qty"+$t+"Act_MR"+$t+"Bud_MR"+$t+"MR_Eff"+$t+"Act_Run"+$t+"Bud_Run"+$t+"Flex_Run"+$t+"Bud_Rate"+$t+"Act_Rate"+$t+"Run_Eff"+$t+"Act_Tot"+$t+"Flex_Tot"+$t+"Eff_Tot"+$t+"Downtime"+$cr
		
		uThermoInit($numElements; "Saving Production Analysis Report")
		For ($i; 1; $numElements)
			If (($aCCmrHrs{$i}+$aCCrunHrs{$i}+$aCCsheets{$i}+$aCCmrAct{$i}+$aCCrunAct{$i})>0)  // Modified by: Mel Bohince (2/17/14) don't require budget values
				xText:=xText+$_aCostCtrGroup{$i}+$t+$_aStdCC{$i}+$t+Replace string:C233($_aCostCtrDes{$i}; ","; "-")+$t
				xText:=xText+String:C10($aCCshtAct{$i})+$t+String:C10($aCCsheets{$i})+$t
				xText:=xText+String:C10($aCCmrAct{$i})+$t+String:C10($aCCmrHrs{$i})+$t
				xText:=xText+String:C10(Round:C94(($aCCmrHrs{$i}/$aCCmrAct{$i}*100); 0))+$t  //mr eff
				xText:=xText+String:C10($aCCrunAct{$i})+$t+String:C10($aCCrunHrs{$i})+$t
				xText:=xText+String:C10(Round:C94($aCCadjRun{$i}; 2))+$t  //flex run
				xText:=xText+String:C10(Round:C94($aCCrate{$i}; -2))+$t
				xText:=xText+String:C10(Round:C94($aCCshtAct{$i}/$aCCrunAct{$i}; -2))+$t
				xText:=xText+String:C10(Round:C94(($aCCadjRun{$i}/$aCCrunAct{$i}*100); 0))+$t  //run eff
				xText:=xText+String:C10($aCCmrAct{$i}+$aCCrunAct{$i})+$t+String:C10(Round:C94($aCCmrHrs{$i}+$aCCadjRun{$i}; 2))+$t+String:C10(Round:C94((($aCCmrHrs{$i}+$aCCadjRun{$i})/($aCCmrAct{$i}+$aCCrunAct{$i})*100); 0))+$t
				xText:=xText+String:C10($aCCdown{$i})+$t
				xText:=xText+$cr
				
			End if 
			uThermoUpdate($i)
		End for 
		uThermoClose
		
		SEND PACKET:C103($docRef; xTitle+$cr+$cr)
		SEND PACKET:C103($docRef; xText)
		SEND PACKET:C103($docRef; $cr+$cr+"------ END OF FILE ------")
		CLOSE DOCUMENT:C267($docRef)
		
		ARRAY TEXT:C222($_aMJsequence; 0)
		ARRAY REAL:C219($_aMJmrHrs; 0)
		ARRAY REAL:C219($_aMJrunHrs; 0)
		ARRAY REAL:C219($_aMJsheets; 0)
		
		$err:=util_Launch_External_App(docName)
		
	End if 
End if 

ARRAY TEXT:C222($_aStdCC; 0)
ARRAY TEXT:C222($_aCostCtrDes; 0)
ARRAY TEXT:C222($_aCostCtrGroup; 0)
