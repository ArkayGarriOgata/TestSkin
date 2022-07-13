//%attributes = {"publishedWeb":true}
//PM:  JML_getDollars  3/05/01  mlb
//for batch to apply formula to jml records
// Modified by: Mel Bohince (4/13/16) add some stuff for scheduling
If ([Job_Forms:42]JobFormID:5#[Job_Forms_Master_Schedule:67]JobForm:4)
	READ ONLY:C145([Job_Forms:42])
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=[Job_Forms_Master_Schedule:67]JobForm:4)
End if 
$totalUnits:=[Job_Forms:42]QtyWant:22

$variableCost:=JML_getVariableCost([Job_Forms_Master_Schedule:67]JobForm:4)  // Modified by: Mel Bohince (4/13/16) 

If ($totalUnits>0)
	$unitVariable:=$variableCost/$totalUnits
Else 
	$unitVariable:=1
End if 

$shippingUnits:=0
[Job_Forms_Master_Schedule:67]CashFlow:34:=Job_CashFlow([Job_Forms_Master_Schedule:67]JobForm:4; ->$shippingUnits)

[Job_Forms_Master_Schedule:67]ThroughPut:86:=Round:C94(([Job_Forms_Master_Schedule:67]CashFlow:34-($shippingUnits*$unitVariable)); 0)  // Modified by: Mel Bohince (4/13/16)
[Job_Forms_Master_Schedule:67]Investment:87:=Round:C94((($totalUnits-$shippingUnits)*$unitVariable); 0)


//x:=JML_getInvestment([Job_Forms_Master_Schedule]JobForm) // Modified by: Mel Bohince (4/13/16)   

[Job_Forms_Master_Schedule:67]SalesValue:35:=Job_SalesValue([Job_Forms_Master_Schedule:67]JobForm:4)  //these are orders pegged to the jobit, released or not
//temporarty 
[Job_Forms_Master_Schedule:67]WeekNumber:38:=util_weekNumber([Job_Forms_Master_Schedule:67]PressDate:25)

JML_getOperations

If (False:C215)  //(Length([JobMasterLog]Operations)=0)
	If (Position:C15("**"; [Job_Forms_Master_Schedule:67]JobForm:4)=0)
		READ ONLY:C145([Job_Forms_Machines:43])
		QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=[Job_Forms_Master_Schedule:67]JobForm:4)
		If (Records in selection:C76([Job_Forms_Machines:43])>0)
			SELECTION TO ARRAY:C260([Job_Forms_Machines:43]CostCenterID:4; $aCC; [Job_Forms_Machines:43]Sequence:5; $aSeq; [Job_Forms_Machines:43]Planned_MR_Hrs:15; $aMR; [Job_Forms_Machines:43]Planned_RunHrs:37; $aRun)
			SORT ARRAY:C229($aSeq; $aCC; $aRun; $aMR; >)
			$presses:=""
			$hours:=0
			For ($i; 1; Size of array:C274($aSeq))
				If (Position:C15($aCC{$i}; <>PRESSES)>0)
					//If ($aCC{$i}#"415")
					$presses:=$presses+$aCC{$i}+" "
					$hours:=$hours+$aMR{$i}+$aRun{$i}
					//Else 
					//$presses:=$presses+"BS+ "
					//End if 
				End if 
			End for 
			[Job_Forms_Master_Schedule:67]Operations:36:=$presses
			If ($hours>0) & ($hours<1)
				[Job_Forms_Master_Schedule:67]DurationPrinting:37:=1
			Else 
				[Job_Forms_Master_Schedule:67]DurationPrinting:37:=Round:C94($hours; 0)
			End if 
		End if 
		REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
	End if 
End if 