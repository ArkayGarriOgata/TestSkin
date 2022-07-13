//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 01/08/14, 09:32:51
// ----------------------------------------------------
// Method: MachineTicketsOverBudget
// Description:
// Looks at all [Job_Forms_Machine_Tickets] to see if their
// MR or Run exceeds the budget by 25%. If it does, send a email.
// ----------------------------------------------------

C_LONGINT:C283($xlTicketCount; $xlCount; $i; $x; $y; $xlMR; $xlActualRate; $xlPlannedRate; $xlGoodUnits; $xlRunActual; $xlRunPlanned)
C_REAL:C285($rMRPercent; $rRunPercent)
C_TEXT:C284($tSequence; $tSubject; $tBodyHeader; $tBody; $tText)
C_BOOLEAN:C305($bSendEmail)
ARRAY TEXT:C222($atSequences; 0)  //Which sequence does it point to.
ARRAY TEXT:C222($atProblem; 0)  //Text of the problem for the user email.

READ ONLY:C145([Job_Forms_Machines:43])
READ ONLY:C145([Job_Forms_Machine_Tickets:61])

$tSubject:="Exception Report - "+String:C10(Current date:C33; Internal date short:K1:7)
$tBodyHeader:="The Job Form Sequences listed below have the following problems."
$tBody:=""
$rMRPercent:=1.25  //Change it here if needed.
$rRunPercent:=0.75  //Change it here if needed.
$rQtyPercent:=0.25  //Change it here if needed.
$tPrintedMRPercent:=Substring:C12(String:C10($rMRPercent); 3)
$bSendEmail:=False:C215
$tText:=""

QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5=4D_Current_date)  //-35)
CREATE SET:C116([Job_Forms_Machine_Tickets:61]; "Tickets")
$xlTicketCount:=Records in selection:C76([Job_Forms_Machine_Tickets:61])


If ($xlTicketCount>0)
	For ($i; 1; $xlTicketCount)
		USE SET:C118("Tickets")
		
		$tSequence:=[Job_Forms_Machine_Tickets:61]JobForm:1+"."+String:C10([Job_Forms_Machine_Tickets:61]Sequence:3; "000")
		QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobSequence:8=$tSequence)
		If ([Job_Forms_Machines:43]Planned_RunHrs:37#0)  //Don't divide by zero!
			$xlPlannedRate:=[Job_Forms_Machines:43]Planned_Qty:10/[Job_Forms_Machines:43]Planned_RunHrs:37
			$xlRunPlanned:=[Job_Forms_Machines:43]Planned_Qty:10
		Else 
			$xlPlannedRate:=0
		End if 
		
		//Now look back at the tickets associated with this machine, may be more than one.
		QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1=[Job_Forms_Machines:43]JobForm:1; *)
		QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]Sequence:3=[Job_Forms_Machines:43]Sequence:5)
		$xlCount:=Records in selection:C76([Job_Forms_Machine_Tickets:61])
		If ($xlCount>0)
			$xlMR:=0
			$xlActualRate:=0
			$xlGoodUnits:=0
			$xlRunActual:=0
			
			//Add the MR and Actuals up
			For ($x; 1; $xlCount)
				GOTO SELECTED RECORD:C245([Job_Forms_Machine_Tickets:61]; $x)
				$xlMR:=$xlMR+[Job_Forms_Machine_Tickets:61]MR_Act:6
				$xlGoodUnits:=$xlGoodUnits+[Job_Forms_Machine_Tickets:61]Good_Units:8
				$xlRunActual:=$xlRunActual+[Job_Forms_Machine_Tickets:61]Run_Act:7
				REMOVE FROM SET:C561([Job_Forms_Machine_Tickets:61]; "Tickets")  //So we don't do them again.
			End for 
			If ($xlRunActual#0)  //Don't divide by zero!
				$xlActualRate:=$xlGoodUnits/$xlRunActual
			End if 
			
			//Compare MR to the budget, the correct [Job_Forms_Machines] record is still loaded.
			If ([Job_Forms_Machines:43]Planned_MR_Hrs:15>0)  //Check the MR Hrs
				If ([Job_Forms_Machines:43]Planned_MR_Hrs:15*$rMRPercent<=$xlMR)  //$rMRPercent over
					$bSendEmail:=True:C214
					APPEND TO ARRAY:C911($atSequences; $tSequence)
					$tText:="("+[Job_Forms_Machines:43]CostCenterID:4+") : Actual MR = "+String:C10($xlMR)+", Budgeted MR = "+String:C10([Job_Forms_Machines:43]Planned_MR_Hrs:15)+", over by "+String:C10(($xlMR/[Job_Forms_Machines:43]Planned_MR_Hrs:15)*100; "#00.00")+"%."
					APPEND TO ARRAY:C911($atProblem; $tText)
				End if 
			End if 
			
			//Report if Actual Run is $rRunPercent under Planned Run
			If ($xlPlannedRate#0)  //Don't divide by zero!
				$rPercent:=($xlActualRate-$xlPlannedRate)/$xlPlannedRate
				If ($rPercent<0)
					If (($xlActualRate-$xlPlannedRate)/$xlPlannedRate<=$rRunPercent)  //Rate is below $rRunPercent.
						$bSendEmail:=True:C214
						APPEND TO ARRAY:C911($atSequences; $tSequence)
						$tText:="("+[Job_Forms_Machines:43]CostCenterID:4+") : Actual Rate = "+String:C10($xlActualRate)+", Budgeted Rate = "+String:C10($xlPlannedRate)+", under by "+String:C10((($xlActualRate-$xlPlannedRate)/$xlPlannedRate)*100; "#00.00")+"%."
						APPEND TO ARRAY:C911($atProblem; $tText)
					End if 
				End if 
			End if 
			
			//Report if Planned Quantity is $rMRPercent over Actual Quantity
			If ($xlRunPlanned#0)  //Don't divide by zero!
				If (($xlGoodUnits-$xlRunPlanned)/$xlRunPlanned>=$rQtyPercent)
					$bSendEmail:=True:C214
					APPEND TO ARRAY:C911($atSequences; $tSequence)
					$tText:="("+[Job_Forms_Machines:43]CostCenterID:4+") : Actual Quantity = "+String:C10($xlGoodUnits)+", Budgeted Quantity = "+String:C10($xlRunPlanned)+", over by "+String:C10((($xlGoodUnits-$xlRunPlanned)/$xlRunPlanned)*100; "####0.00")+"%."
					APPEND TO ARRAY:C911($atProblem; $tText)
				End if 
			End if 
			
		End if 
	End for 
End if 

If ($bSendEmail)
	SORT ARRAY:C229($atSequences; $atProblem; >)
	For ($y; 1; Size of array:C274($atSequences))
		$tBody:=$tBody+$atSequences{$y}+" "+$atProblem{$y}+<>CR
	End for 
	EMAIL_Sender($tSubject; $tBodyHeader; $tBody; distributionList)
End if 